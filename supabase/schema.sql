-- DAKIKA Supabase Schema
-- Version: 1.0
-- Date: September 2026

-- Enable required extensions
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- ============================================
-- TABLES
-- ============================================

-- News sources (The New Times, Igihe, KT Press, etc.)
create table sources (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  url text not null,
  rss_feed_url text,
  language text not null default 'en',
  credibility_score numeric(3,2) default 0.8,
  is_active boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Categories (Sports, Business, Tech, Politics, Entertainment, Health)
create table categories (
  id uuid primary key default uuid_generate_v4(),
  name text not null unique,
  name_en text not null,
  name_rw text,
  name_sw text,
  icon text,
  color text,
  is_active boolean default true,
  sort_order int default 0
);

-- Articles (ingested from sources)
create table articles (
  id uuid primary key default uuid_generate_v4(),
  source_id uuid references sources(id) on delete set null,
  external_id text, -- ID from source RSS/API
  title text not null,
  summary text, -- AI-generated 40-80 word summary
  content text, -- Full article content
  url text not null,
  image_url text,
  category_id uuid references categories(id) on delete set null,
  language text not null default 'en',
  confidence_score numeric(3,2), -- AI confidence 0-1
  status text not null default 'pending' check (status in ('pending', 'review', 'published', 'rejected')),
  published_at timestamptz,
  ingested_at timestamptz default now(),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(source_id, external_id)
);

-- Users (extends Supabase Auth)
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  phone text unique,
  display_name text,
  avatar_url text,
  language text not null default 'en' check (language in ('en', 'rw', 'sw')),
  subscription_tier text not null default 'free' check (subscription_tier in ('free', 'premium', 'premium_plus')),
  display_density text not null default 'comfortable' check (display_density in ('comfortable', 'compact')),
  data_saver boolean default false,
  notifications_enabled boolean default true,
  breaking_news_notifications boolean default true,
  daily_digest_notifications boolean default true,
  weekly_summary_notifications boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Digests (morning, afternoon, evening collections)
create table digests (
  id uuid primary key default uuid_generate_v4(),
  date date not null,
  period text not null check (period in ('morning', 'afternoon', 'evening')),
  title text,
  story_ids uuid[] not null default '{}',
  created_at timestamptz default now(),
  unique(date, period)
);

-- Saved stories (user bookmarks)
create table saved_stories (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references profiles(id) on delete cascade,
  article_id uuid not null references articles(id) on delete cascade,
  created_at timestamptz default now(),
  unique(user_id, article_id)
);

-- User reading history
create table reading_history (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references profiles(id) on delete cascade,
  article_id uuid not null references articles(id) on delete cascade,
  read_at timestamptz default now(),
  dwell_time_seconds int, -- How long they spent reading
  completed boolean default false
);

-- Subscriptions (premium tier tracking)
create table subscriptions (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references profiles(id) on delete cascade,
  tier text not null check (tier in ('free', 'premium', 'premium_plus')),
  provider text not null check (provider in ('mtn_momo', 'airtel_money', 'flutterwave', 'mpesa')),
  provider_subscription_id text,
  start_date timestamptz not null default now(),
  end_date timestamptz,
  payment_status text not null default 'active' check (payment_status in ('active', 'cancelled', 'expired', 'failed')),
  auto_renew boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Editor actions (audit trail)
create table editor_actions (
  id uuid primary key default uuid_generate_v4(),
  editor_id uuid not null references profiles(id) on delete cascade,
  article_id uuid not null references articles(id) on delete cascade,
  action text not null check (action in ('approve', 'reject', 'edit', 'categorize', 'add_source', 'remove_source')),
  previous_value jsonb,
  new_value jsonb,
  notes text,
  created_at timestamptz default now()
);

-- Analytics events
create table analytics_events (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references profiles(id) on delete set null,
  event_name text not null,
  event_data jsonb,
  created_at timestamptz default now()
);

-- ============================================
-- INDEXES
-- ============================================

create index idx_articles_status on articles(status);
create index idx_articles_published_at on articles(published_at desc);
create index idx_articles_category on articles(category_id);
create index idx_articles_source on articles(source_id);
create index idx_articles_confidence on articles(confidence_score);
create index idx_digests_date on digests(date desc);
create index idx_digests_period on digests(period);
create index idx_saved_stories_user on saved_stories(user_id);
create index idx_reading_history_user on reading_history(user_id);
create index idx_reading_history_article on reading_history(article_id);
create index idx_subscriptions_user on subscriptions(user_id);
create index idx_analytics_events_user on analytics_events(user_id);
create index idx_analytics_events_name on analytics_events(event_name);
create index idx_analytics_events_created on analytics_events(created_at desc);

-- Full-text search on articles
create index idx_articles_search on articles using gin(to_tsvector('english', title || ' ' || coalesce(summary, '')));

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

alter table sources enable row level security;
alter table categories enable row level security;
alter table articles enable row level security;
alter table profiles enable row level security;
alter table digests enable row level security;
alter table saved_stories enable row level security;
alter table reading_history enable row level security;
alter table subscriptions enable row level security;
alter table editor_actions enable row level security;
alter table analytics_events enable row level security;

-- Sources: anyone can read active sources
create policy "Sources are viewable by everyone"
  on sources for select
  using (is_active = true);

-- Categories: anyone can read active categories
create policy "Categories are viewable by everyone"
  on categories for select
  using (is_active = true);

-- Articles: anyone can read published articles
create policy "Published articles are viewable by everyone"
  on articles for select
  using (status = 'published');

-- Profiles: users can read their own profile
create policy "Users can view own profile"
  on profiles for select
  using (auth.uid() = id);

-- Profiles: users can update their own profile
create policy "Users can update own profile"
  on profiles for update
  using (auth.uid() = id);

-- Digests: anyone can read digests
create policy "Digests are viewable by everyone"
  on digests for select
  using (true);

-- Saved stories: users can CRUD their own saved stories
create policy "Users can view own saved stories"
  on saved_stories for select
  using (auth.uid() = user_id);

create policy "Users can insert own saved stories"
  on saved_stories for insert
  with check (auth.uid() = user_id);

create policy "Users can delete own saved stories"
  on saved_stories for delete
  using (auth.uid() = user_id);

-- Reading history: users can CRUD their own history
create policy "Users can view own reading history"
  on reading_history for select
  using (auth.uid() = user_id);

create policy "Users can insert own reading history"
  on reading_history for insert
  with check (auth.uid() = user_id);

-- Subscriptions: users can read their own subscriptions
create policy "Users can view own subscriptions"
  on subscriptions for select
  using (auth.uid() = user_id);

-- Editor actions: only editors can access
create policy "Editors can view editor actions"
  on editor_actions for select
  using (exists (
    select 1 from profiles where profiles.id = auth.uid() and profiles.subscription_tier = 'premium'
  ));

-- Analytics events: users can insert their own events
create policy "Users can insert own analytics events"
  on analytics_events for insert
  with check (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Update updated_at timestamp
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Apply updated_at trigger to all tables with updated_at
create trigger update_sources_updated_at before update on sources for each row execute function update_updated_at();
create trigger update_categories_updated_at before update on categories for each row execute function update_updated_at();
create trigger update_articles_updated_at before update on articles for each row execute function update_updated_at();
create trigger update_profiles_updated_at before update on profiles for each row execute function update_updated_at();
create trigger update_subscriptions_updated_at before update on subscriptions for each row execute function update_updated_at();

-- Get digest for a specific date and period
create or replace function get_digest(digest_date date, digest_period text)
returns table (
  id uuid,
  date date,
  period text,
  title text,
  story_ids uuid[],
  created_at timestamptz
) as $$
begin
  return query
  select d.id, d.date, d.period, d.title, d.story_ids, d.created_at
  from digests d
  where d.date = digest_date and d.period = digest_period
  order by d.created_at desc
  limit 1;
end;
$$ language plpgsql;

-- Search articles by keyword
create or replace function search_articles(search_query text, max_results int default 20)
returns table (
  id uuid,
  title text,
  summary text,
  source_name text,
  category_name text,
  published_at timestamptz
) as $$
begin
  return query
  select a.id, a.title, a.summary, s.name as source_name, c.name as category_name, a.published_at
  from articles a
  left join sources s on a.source_id = s.id
  left join categories c on a.category_id = c.id
  where a.status = 'published'
    and (to_tsvector('english', a.title || ' ' || coalesce(a.summary, '')) @@ plainto_tsquery('english', search_query))
  order by a.published_at desc
  limit max_results;
end;
$$ language plpgsql;

-- ============================================
-- SEED DATA
-- ============================================

-- Insert default categories
insert into categories (name, name_en, name_rw, name_sw, icon, color, sort_order) values
  ('general', 'General', 'Rusange', 'Jumuiya', 'article', '#6B6B60', 0),
  ('sports', 'Sports', 'Michezo', 'Michezo', 'sports_soccer', '#1B7A3D', 1),
  ('business', 'Business', 'Ubucuruzi', 'Biashara', 'trending_up', '#2563EB', 2),
  ('tech', 'Technology', 'Ikoranabuhanga', 'Teknolojia', 'computer', '#7C3AED', 3),
  ('politics', 'Politics', 'Politiki', 'Siasa', 'account_balance', '#D97706', 4),
  ('entertainment', 'Entertainment', 'Myidagaduro', 'Burudani', 'movie', '#DB2777', 5),
  ('health', 'Health', 'Ubuzima', 'Afya', 'favorite', '#0891B2', 6);

-- Insert default sources (Rwanda launch)
insert into sources (name, url, rss_feed_url, language, credibility_score) values
  ('The New Times', 'https://www.newtimes.co.rw', 'https://www.newtimes.co.rw/rss', 'en', 0.95),
  ('Igihe', 'https://www.igihe.com', 'https://www.igihe.com/rss', 'en', 0.90),
  ('KT Press', 'https://www.ktpress.rw', 'https://www.ktpress.rw/rss', 'en', 0.88),
  ('Rwanda Today', 'https://www.rwandatoday.com', null, 'en', 0.85),
  ('Express News Rwanda', 'https://www.expressnewsrwanda.com', null, 'en', 0.82),
  ('Rwanda News Agency', 'https://www.rna.gov.rw', 'https://www.rna.gov.rw/rss', 'en', 0.92),
  ('BBC Great Lakes', 'https://www.bbc.com/news/world/africa', 'https://feeds.bbci.co.uk/news/world/africa/rss.xml', 'en', 0.98),
  ('VOA Great Lakes', 'https://www.voaafrica.com', 'https://www.voaafrica.com/rss', 'en', 0.95);

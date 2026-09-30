-- DAKIKA Seed Data
-- Run after schema.sql to populate test data

-- Insert sample articles
insert into articles (source_id, title, summary, content, url, category_id, language, confidence_score, status, published_at)
values
  -- Business
  ((select id from sources where name = 'The New Times'),
   'Rwanda GDP Growth Exceeds Expectations in Q3 2026',
   'The National Institute of Statistics reported 8.2% growth driven by services and agriculture sectors, surpassing the projected 7.5% target.',
   'Full article content about Rwanda GDP growth...',
   'https://www.newtimes.co.rw/article/123',
   (select id from categories where name = 'business'),
   'en', 0.92, 'published', now() - interval '2 hours'),

  ((select id from sources where name = 'Igihe'),
   'MTN Launches 5G Expansion Across East Africa',
   'The telecom giant announced plans to expand 5G coverage to 15 additional cities across Rwanda, Kenya, and Uganda by end of 2027.',
   'Full article content about MTN 5G expansion...',
   'https://www.igihe.com/article/456',
   (select id from categories where name = 'tech'),
   'en', 0.88, 'published', now() - interval '3 hours'),

  ((select id from sources where name = 'KT Press'),
   'Kigali Named Top African City for Tech Startups',
   'Kigali ranked #1 in Africa for startup ecosystem growth, with over 200 active tech companies and $200M in venture funding this year.',
   'Full article content about Kigali tech scene...',
   'https://www.ktpress.rw/article/789',
   (select id from categories where name = 'tech'),
   'en', 0.90, 'published', now() - interval '4 hours'),

  -- Sports
  ((select id from sources where name = 'The New Times'),
   'Rwanda National Football Team Qualifies for AFCON',
   'Amavubi secured their spot in the 2027 Africa Cup of Nations after a decisive 2-1 victory in Kigali on Saturday evening.',
   'Full article content about AFCON qualification...',
   'https://www.newtimes.co.rw/article/101',
   (select id from categories where name = 'sports'),
   'en', 0.95, 'published', now() - interval '5 hours'),

  -- Health
  ((select id from sources where name = 'Rwanda Today'),
   'Rwanda Launches Digital Health Initiative',
   'The initiative will provide telemedicine services to 500,000 citizens in rural areas, reducing hospital visits by an estimated 30%.',
   'Full article content about digital health...',
   'https://www.rwandatoday.com/article/202',
   (select id from categories where name = 'health'),
   'en', 0.87, 'published', now() - interval '6 hours'),

  -- Politics
  ((select id from sources where name = 'Rwanda News Agency'),
   'Rwanda Hosts Pan-African Climate Summit',
   'Delegates from 40 African countries gathered in Kigali to discuss climate finance and green energy transition strategies.',
   'Full article content about climate summit...',
   'https://www.rna.gov.rw/article/303',
   (select id from categories where name = 'politics'),
   'en', 0.91, 'published', now() - interval '7 hours'),

  -- Entertainment
  ((select id from sources where name = 'Igihe'),
   'Rwandan Film Wins International Award',
   'A Rwandan documentary film won the Best Documentary award at the Pan-African Film Festival in Johannesburg.',
   'Full article content about film award...',
   'https://www.igihe.com/article/404',
   (select id from categories where name = 'entertainment'),
   'en', 0.89, 'published', now() - interval '8 hours'),

  -- Business
  ((select id from sources where name = 'Express News Rwanda'),
   'New Coffee Processing Plant Opens in Musanze',
   'The $12M facility will process 5,000 tons of coffee annually, creating 300 direct jobs and benefiting 2,000 local farmers.',
   'Full article content about coffee plant...',
   'https://www.expressnewsrwanda.com/article/505',
   (select id from categories where name = 'business'),
   'en', 0.86, 'published', now() - interval '9 hours'),

  -- Tech
  ((select id from sources where name = 'KT Press'),
   'Kigali Innovation City Attracts $50M Investment',
   'The Kigali Innovation City secured commitments from 12 international companies, creating an estimated 2,000 tech jobs.',
   'Full article content about innovation city...',
   'https://www.ktpress.rw/article/606',
   (select id from categories where name = 'tech'),
   'en', 0.93, 'published', now() - interval '10 hours'),

  -- Sports
  ((select id from sources where name = 'The New Times'),
   'Rwanda Basketball Team Qualifies for World Cup',
   'The national basketball team secured a spot in the 2027 FIBA World Cup after winning the African qualifiers.',
   'Full article content about basketball...',
   'https://www.newtimes.co.rw/article/707',
   (select id from categories where name = 'sports'),
   'en', 0.94, 'published', now() - interval '11 hours');

-- Insert a sample digest
insert into digests (date, period, title, story_ids)
values
  (current_date, 'morning', 'Morning Digest — ' || to_char(current_date, 'Day, Month DD'),
   (select array_agg(id) from articles where status = 'published' limit 12));

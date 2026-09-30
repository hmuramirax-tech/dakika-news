# Supabase Setup Guide

## 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up (free)
2. Click **New Project**
3. Name: `onenews`
4. Database Password: (save this — you'll need it)
5. Region: **Central EU (Frankfurt)** — closest to Rwanda
6. Click **Create new project** (takes ~2 minutes)

## 2. Run the Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Click **New query**
3. Copy the entire contents of `supabase/schema.sql`
4. Paste into the SQL editor
5. Click **Run**

This creates:
- 10 tables (sources, categories, articles, profiles, digests, saved_stories, reading_history, subscriptions, editor_actions, analytics_events)
- Indexes for fast queries
- Row-level security policies
- Helper functions
- Seed data (7 categories, 8 news sources)

## 3. Get Your Credentials

1. Go to **Project Settings** → **API**
2. Copy these values:
   - **Project URL** → `SUPABASE_URL`
   - **anon public** key → `SUPABASE_ANON_KEY`

## 4. Configure the App

Open `lib/config.dart` and replace:

```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key';
```

## 5. Enable Phone Auth

1. Go to **Authentication** → **Providers**
2. Find **Phone** and toggle it **ON**
3. For testing, you can disable "Confirm phone number" in **Authentication** → **Settings** (skips SMS)

## 6. Test the Connection

```bash
flutter pub get
flutter run
```

The app should connect to Supabase and load categories/sources.

## Free Tier Limits

| Resource | Limit | Your Need |
|---|---|---|
| Database | 500 MB | ~2-5M articles |
| Auth MAUs | 50,000 | 30K target |
| Storage | 1 GB | Thumbnails |
| Egress | 5 GB/month | ~12K API requests |

You won't pay anything until you hit 50K MAU.

## Next Steps

- [ ] Set up Edge Functions for AI summarization
- [ ] Configure Firebase for push notifications
- [ ] Set up Flutterwave for payments
- [ ] Deploy to Google Play Store

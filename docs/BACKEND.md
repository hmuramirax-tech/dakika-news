# OneNews Backend Architecture

## Overview

OneNews uses a serverless backend built on Supabase Edge Functions. This provides:
- Zero server management
- Automatic scaling
- Pay-per-use pricing (free tier available)
- Global edge deployment

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    FLUTTER APP                          │
│  ┌─────────┐  ┌──────────┐  ┌───────────┐  ┌────────┐ │
│  │ Digest  │  │ Category │  │  Offline   │  │  Auth  │ │
│  │  Feed   │  │   Feeds  │  │   Cache    │  │(Phone) │ │
│  └────┬────┘  └────┬─────┘  └─────┬─────┘  └───┬────┘ │
│       │             │              │              │      │
│       └─────────────┴──────────────┴──────────────┘      │
│                         │                                │
│                    Supabase Client                       │
└─────────────────────────┬───────────────────────────────┘
                          │ HTTPS
┌─────────────────────────▼───────────────────────────────┐
│                   SUPABASE PLATFORM                     │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              POSTGRESQL DATABASE                 │   │
│  │  articles | sources | categories | profiles      │   │
│  │  digests | saved_stories | subscriptions       │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              EDGE FUNCTIONS                      │   │
│  │  • summarize (AI)                               │   │
│  │  • ingest-rss (content)                         │   │
│  │  • generate-digest (curation)                   │   │
│  │  • send-push (notifications)                    │   │
│  │  • process-payment (billing)                    │   │
│  │  • payment-callback (webhook)                   │   │
│  │  • scheduled-tasks (cron)                       │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              AUTH (Phone + OTP)                  │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              STORAGE (Images)                    │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
┌───────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐
│   OpenAI     │  │  Flutterwave │  │  Firebase   │
│   GPT-4o     │  │  MoMo/Airtel │  │  Cloud Msg  │
└──────────────┘  └─────────────┘  └─────────────┘
```

## Edge Functions

### 1. summarize
- **Trigger:** Called by scheduled-tasks or manually
- **Input:** articleId, title, content, language
- **Output:** Updates article with AI summary + confidence score
- **Model:** OpenAI GPT-4o-mini
- **Cost:** ~$0.0001 per article

### 2. ingest-rss
- **Trigger:** Scheduled (every 30 minutes)
- **Input:** None (reads from sources table)
- **Output:** Inserts new articles with status "pending"
- **Rate limit:** 20 articles per source per run

### 3. generate-digest
- **Trigger:** Scheduled (6:00, 12:00, 18:00 CAT)
- **Input:** date, period
- **Output:** Creates digest with top 12 story IDs
- **Algorithm:** Confidence score + recency + category diversity

### 4. send-push
- **Trigger:** Called when breaking news is published
- **Input:** articleId, title, body
- **Output:** FCM topic message to all subscribed devices
- **Rate limit:** 3 per day per user (enforced client-side)

### 5. process-payment
- **Trigger:** User initiates premium subscription
- **Input:** userId, phone, amount, provider, tier
- **Output:** Payment URL or pending transaction
- **Providers:** Flutterwave, MTN MoMo, Airtel Money

### 6. payment-callback
- **Trigger:** Webhook from Flutterwave/MoMo/Airtel
- **Input:** transaction reference
- **Output:** Updates subscription status, upgrades user tier

### 7. scheduled-tasks
- **Trigger:** Cron job (Supabase pg_cron)
- **Tasks:**
  - `ingest` — every 30 minutes
  - `summarize` — every 15 minutes
  - `digest` — 6:00, 12:00, 18:00 CAT
  - `cleanup` — daily at 2:00 AM

## Database Schema

See `supabase/schema.sql` for full schema.

### Key Tables

| Table | Purpose | RLS |
|---|---|---|
| articles | News articles with AI summaries | Published only |
| sources | News sources (RSS feeds) | Active only |
| categories | News categories | Active only |
| profiles | User profiles | Own profile only |
| digests | Daily digest collections | Public read |
| saved_stories | User bookmarks | Own only |
| reading_history | Reading analytics | Own only |
| subscriptions | Premium subscriptions | Own only |
| editor_actions | Audit trail | Editors only |
| analytics_events | Product analytics | Own insert only |

## Security

### Row Level Security (RLS)
- All tables have RLS enabled
- Policies enforce data isolation
- Anon key has limited access
- Service role key bypasses RLS (backend only)

### API Keys
- **anon key** — safe in client code, protected by RLS
- **service_role key** — backend only, never in app

### Environment Variables
Store in Supabase Dashboard → Edge Functions → Secrets:
- `OPENAI_API_KEY`
- `FLUTTERWAVE_SECRET_KEY`
- `FCM_SERVER_KEY`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

## Deployment

### Deploy Edge Functions
```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link project
supabase link --project-ref your-project-ref

# Deploy all functions
supabase functions deploy summarize
supabase functions deploy ingest-rss
supabase functions deploy generate-digest
supabase functions deploy send-push
supabase functions deploy process-payment
supabase functions deploy payment-callback
supabase functions deploy scheduled-tasks
```

### Set Environment Variables
```bash
supabase secrets set OPENAI_API_KEY=sk-...
supabase secrets set FLUTTERWAVE_SECRET_KEY=FLWSECK-...
supabase secrets set FCM_SERVER_KEY=...
```

### Schedule Cron Jobs
```sql
-- In Supabase SQL Editor
select cron.schedule('ingest', '*/30 * * * *', $$ select net.http_post('https://your-project.supabase.co/functions/v1/scheduled-tasks', '{"task": "ingest"}') $$);
select cron.schedule('summarize', '*/15 * * * *', $$ select net.http_post('https://your-project.supabase.co/functions/v1/scheduled-tasks', '{"task": "summarize"}') $$);
select cron.schedule('digest-morning', '0 6 * * *', $$ select net.http_post('https://your-project.supabase.co/functions/v1/scheduled-tasks', '{"task": "digest"}') $$);
select cron.schedule('digest-afternoon', '0 12 * * *', $$ select net.http_post('https://your-project.supabase.co/functions/v1/scheduled-tasks', '{"task": "digest"}') $$);
select cron.schedule('digest-evening', '0 18 * * *', $$ select net.http_post('https://your-project.supabase.co/functions/v1/scheduled-tasks', '{"task": "digest"}') $$);
select cron.schedule('cleanup', '0 2 * * *', $$ select net.http_post('https://your-project.supabase.co/functions/v1/scheduled-tasks', '{"task": "cleanup"}') $$);
```

## Cost Estimate

| Service | Free Tier | MVP Usage | Cost |
|---|---|---|---|
| Supabase | 500MB DB, 50K MAU | 100MB, 10K MAU | $0 |
| OpenAI | None | 500 articles/day | ~$5/month |
| Flutterwave | None | 100 transactions | ~$1.50 |
| Firebase FCM | Free | Unlimited | $0 |
| Cloudflare | Free | Unlimited | $0 |
| **Total** | | | **~$7/month** |

## Monitoring

- Supabase Dashboard → Logs (Edge Function logs)
- Supabase Dashboard → Database → SQL Editor (query analytics)
- Sentry (error tracking)
- PostHog (product analytics)

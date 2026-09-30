# OneNews Deployment Guide

## Prerequisites

- [ ] Flutter SDK installed (`flutter doctor` passes)
- [ ] Supabase project created and schema deployed
- [ ] Firebase project created and `google-services.json` added
- [ ] Supabase CLI installed (`npm install -g supabase`)

---

## 1. Deploy Supabase Edge Functions

```bash
# Login to Supabase
supabase login

# Link your project
supabase link --project-ref your-project-ref

# Deploy all functions
./scripts/deploy-functions.sh

# Or deploy individually
supabase functions deploy summarize
supabase functions deploy ingest-rss
supabase functions deploy generate-digest
supabase functions deploy send-push
supabase functions deploy process-payment
supabase functions deploy payment-callback
supabase functions deploy scheduled-tasks
```

## 2. Set Environment Variables

```bash
./scripts/setup-secrets.sh
```

Or manually:
```bash
supabase secrets set OPENAI_API_KEY=sk-...
supabase secrets set FLUTTERWAVE_SECRET_KEY=FLWSECK-...
supabase secrets set FCM_SERVER_KEY=...
```

## 3. Set Up Cron Jobs

Run the SQL from `scripts/setup-cron.sh` in your Supabase SQL Editor.

## 4. Build & Deploy Android

```bash
# Build release APK
flutter build apk --release

# Build app bundle (for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## 5. Build & Deploy Web (Optional)

```bash
flutter build web --release
```

Deploy `build/web/` to Cloudflare Pages or Vercel.

## 6. Google Play Store

1. Create developer account ($25 one-time)
2. Go to [play.google.com/console](https://play.google.com/console)
3. Create app → `com.onenews.app`
4. Upload `app-release.aab`
5. Fill in store listing (screenshots, description, etc.)
6. Submit for review

## 7. Post-Launch Checklist

- [ ] Monitor Supabase logs for errors
- [ ] Check Edge Function execution counts
- [ ] Review analytics in PostHog
- [ ] Set up Sentry for error tracking
- [ ] Configure backups (Supabase Pro has automatic backups)

---

## Environment Variables Reference

| Variable | Where | Purpose |
|---|---|---|
| `SUPABASE_URL` | `lib/config.dart` | Supabase project URL |
| `SUPABASE_ANON_KEY` | `lib/config.dart` | Supabase public key |
| `OPENAI_API_KEY` | Supabase Secrets | AI summarization |
| `FLUTTERWAVE_SECRET_KEY` | Supabase Secrets | Payment processing |
| `FCM_SERVER_KEY` | Supabase Secrets | Push notifications |

---

## Rollback Plan

If something breaks:

1. **App issue:** Revert to previous APK in Play Store
2. **Database issue:** Restore from Supabase backup (Pro feature)
3. **Edge Function issue:** Redeploy previous version
4. **Auth issue:** Disable phone auth in Supabase dashboard

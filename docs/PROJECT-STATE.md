# OneNews App — Project State & Handoff

**Last Updated:** September 2026  
**Status:** MVP Build Phase  
**Next Session:** Tomorrow

---

## What We've Done So Far

### 1. Market Viability Assessment
- Researched Rwanda media landscape, mobile money, advertising market
- Analyzed comparable apps (Inshorts, SmartNews, KandaNews, Upday)
- **Conclusion:** Can make money, but Rwanda alone is too small. Must expand to East Africa.
- **Best revenue model:** Micro-subscriptions via mobile money + advertising + telecom partnerships
- **Key insight:** Rwanda's 90% mobile money penetration is the secret weapon

### 2. Competitive Analysis — East Africa
- Mapped competitors across Rwanda, Kenya, Uganda, Tanzania
- **Most dangerous competitor:** KandaNews (digital flipping newspaper, expanding to Rwanda)
- **Key gap:** Nobody is doing AI-powered 60-second news summaries for East Africa
- **Window of opportunity:** 12–18 months before market gets crowded

### 3. Business Requirements Document (BRD)
- 18 Functional Requirements (FR-001 to FR-018)
- 36 Business Rules (BR-001 to BR-036)
- 18 Non-Functional Requirements
- 5-Phase Roadmap (36 months)
- Budget: $120K for first 9 months
- **File:** `docs/BRD-Roadmap-Source.md` (editable) + `OneNews-App-BRD-Roadmap-v1.0.docx` (generated)

### 4. UI/UX Requirements
- **Design concept:** "A newsroom that fits in your pocket — read the day in 60 seconds"
- **Signature element:** The 60-Second Ring (circular progress indicator on every screen)
- **Design system:** Fraunces serif + Inter + JetBrains Mono, forest green accent, warm off-white ground
- **8 screens specified:** Splash, Onboarding, Digest Feed, Explore, Saved, Profile, Full Article, Premium Paywall
- **File:** `docs/UIUX-Requirements.md`

### 5. Flutter Project Scaffold
- **Tech stack:** Flutter (Dart), Python/FastAPI backend, Supabase (Postabase)
- **Dependencies:** go_router, supabase_flutter, flutter_riverpod, google_fonts, connectivity_plus, shared_preferences
- **Design tokens:** Colors, typography, spacing, radius, motion — all in `lib/theme/tokens.dart`
- **Screens:** Splash, Digest Feed, Explore, Saved, Profile, Full Article, Referral, Admin Dashboard
- **Components:** 60-Second Ring, Story Card, Category Tabs, Greeting, Skeleton Card, Empty State, Error State, Offline Banner
- **Tests:** 5 test files, all passing

### 6. Supabase Backend
- **Schema:** 10 tables (articles, sources, categories, profiles, digests, saved_stories, reading_history, subscriptions, editor_actions, analytics_events)
- **RLS:** Row-level security enabled on all tables
- **Indexes:** 13 indexes including full-text search
- **Seed data:** 7 categories, 8 sources, 10 articles
- **Edge Functions:** 7 functions (summarize, ingest-rss, generate-digest, send-push, process-payment, payment-callback, scheduled-tasks)
- **Credentials:** Configured in `lib/config.dart`

### 7. UI/UX Improvements
- Skeleton loading cards
- Empty states with CTAs
- Error states with retry
- Offline banner
- Animated story cards with staggered entrance
- Animated counters for stats
- Category chips with icons

### 8. Additional Features
- **Offline mode:** Cache digests locally, show offline banner, fallback to cached data
- **Admin dashboard:** Content management, analytics, editor review queue
- **Referral system:** Generate codes, track referrals, reward with premium
- **Real data fetching:** Digest Feed now fetches from Supabase

---

## What We Need to Do Tomorrow

### Priority 1: Clean Up
- Delete ~50 redundant chart component files from `lib/components/`
- Keep only: skeleton_card, empty_state, error_state, offline_indicator, category_chip, animated_story_card, animated_counter

### Priority 2: Integrate UI Improvements
- Add skeleton loading to Digest Feed
- Add empty states to all screens
- Add error states with retry
- Add offline banner to Digest Feed
- Add animated story cards to Digest Feed

### Priority 3: Test
- Run `flutter pub get` to install new dependencies
- Run `flutter test` to verify all tests pass
- Run `flutter run -d web-server` and test in browser
- Verify real Supabase data loads in Digest Feed

### Priority 4: Deploy Edge Functions
- Install Supabase CLI: `npm install -g supabase`
- Login: `supabase login`
- Link project: `supabase link --project-ref your-project-ref`
- Deploy all functions: `./scripts/deploy-functions.sh`
- Set secrets: `./scripts/setup-secrets.sh`
- Set up cron jobs: Run SQL from `scripts/setup-cron.sh`

---

## Key Decisions Made

| Decision | Choice | Rationale |
|---|---|---|
| Launch market | Rwanda | Small, manageable, mobile money infrastructure |
| Expansion order | Rwanda → Kenya → Uganda → Tanzania | Kenya is 10x the opportunity |
| Revenue model | Hybrid (ads + micro-subscriptions + telecom) | Don't rely on one stream |
| Price point | Rwf 300/month (~$0.20) | Impulse purchase, 10x cheaper than KandaNews |
| Languages | Kinyarwanda + English at launch, Swahili for expansion | Local differentiation |
| Content strategy | Aggregate, don't produce | Lower cost, faster to market |
| Signature element | 60-Second Ring | Unique, functional, motivating, shareable |
| Tech stack | Flutter + Python/FastAPI + Supabase | Fast MVP, built-in auth/realtime, free tier |
| Backend | Supabase (PostgreSQL) | Faster than raw AWS/GCP, built-in auth, realtime, RLS |
| Payments | MoMo + Airtel + Flutterwave | Pan-African coverage |
| Design system | Warm off-white + forest green + Fraunces serif | Distinct from competitors, editorial credibility |

---

## Key Decisions Still Needed

| Decision | Options | My Recommendation |
|---|---|---|
| **AI provider** | GPT-4o / Claude / Llama 3 | Start with API, fine-tune later |
| **Funding** | Bootstrap / pre-seed / seed | Pre-seed ($50K–$100K) |
| **Co-founder** | Technical co-founder? | Needed for execution |

---

## Project Structure

```
C:\Users\hmura\Desktop\OneNewsApp\
├── .github/workflows/flutter-ci.yml    # CI/CD pipeline
├── .gitignore                          # Git ignore rules
├── pubspec.yaml                        # Flutter dependencies
├── README.md                           # Project overview
├── lib/
│   ├── main.dart                       # App entry point
│   ├── config.dart                     # Supabase credentials
│   ├── router.dart                     # GoRouter navigation (6 tabs)
│   ├── theme/
│   │   └── tokens.dart                 # Design tokens
│   ├── models/
│   │   └── models.dart                 # Data models
│   ├── repositories/
│   │   ├── supabase_client.dart        # Supabase singleton
│   │   ├── article_repository.dart     # Article CRUD + search
│   │   ├── auth_repository.dart        # Phone auth
│   │   ├── category_repository.dart    # Category queries
│   │   ├── digest_repository.dart      # Digest queries
│   │   ├── profile_repository.dart     # User profile
│   │   └── offline_cache.dart          # Offline caching
│   ├── services/
│   │   ├── firebase_service.dart       # FCM push notifications
│   │   ├── connectivity_service.dart   # Network monitoring
│   │   └── referral_service.dart       # Referral program
│   ├── components/
│   │   ├── ring.dart                   # 60-Second Ring
│   │   ├── story_card.dart             # Story card
│   │   ├── category_tabs.dart          # Category filter
│   │   ├── greeting.dart               # Time-based greeting
│   │   ├── skeleton_card.dart         # Loading skeleton
│   │   ├── empty_state.dart            # Empty state
│   │   ├── error_state.dart            # Error state
│   │   ├── offline_banner.dart         # Offline banner
│   │   ├── offline_indicator.dart      # Offline indicator
│   │   ├── category_chip.dart          # Category chip
│   │   ├── animated_story_card.dart    # Animated story card
│   │   └── animated_counter.dart        # Animated counter
│   ├── screens/
│   │   ├── splash.dart                 # Splash
│   │   ├── digest_feed.dart            # Core feed (real data)
│   │   ├── explore.dart                # Search + categories
│   │   ├── saved.dart                  # Saved stories
│   │   ├── profile.dart                # Settings + density toggle
│   │   ├── full_article.dart           # Article + AI summary
│   │   ├── referral_screen.dart        # Referral program
│   │   └── admin_dashboard.dart        # Admin panel
│   └── providers/
│       └── providers.dart              # Riverpod state
├── supabase/
│   ├── schema.sql                      # Database schema
│   ├── schema-referrals.sql            # Referral system schema
│   ├── seed.sql                        # Test data
│   ├── config.toml                     # Edge Function config
│   ├── README.md                       # Setup guide
│   └── functions/
│       ├── summarize/index.ts          # AI summarization
│       ├── ingest-rss/index.ts         # RSS ingestion
│       ├── generate-digest/index.ts    # Digest generation
│       ├── send-push/index.ts          # Push notifications
│       ├── process-payment/index.ts    # Payment processing
│       ├── payment-callback/index.ts   # Payment webhook
│       └── scheduled-tasks/index.ts    # Cron jobs
├── scripts/
│   ├── deploy-functions.sh             # Deploy Edge Functions
│   ├── setup-secrets.sh                # Set Supabase secrets
│   └── setup-cron.sh                   # Cron job SQL
├── test/                               # Flutter tests (5 files, all passing)
├── docs/
│   ├── BRD-Roadmap-Source.md           # BRD + roadmap
│   ├── UIUX-Requirements.md            # UI/UX spec
│   ├── BACKEND.md                      # Backend architecture
│   ├── API.md                          # API reference
│   ├── FIREBASE.md                     # Firebase setup guide
│   ├── DEPLOYMENT.md                   # Deployment guide
│   └── PROJECT-STATE.md                # This file
└── OneNews-App-BRD-Roadmap-v1.0.docx   # Generated Word doc
```

---

## Quick Reference

| Item | Value |
|---|---|
| **App name** | OneNews |
| **Tagline** | "Read the day in 60 seconds" |
| **Launch target** | Q1 2027 (Rwanda) |
| **Year 1 target** | 100K downloads, 30K MAU, $50K–$100K revenue |
| **Year 3 target** | 1.5M downloads, 500K MAU, $1M–$2M revenue |
| **Funding needed** | $50K–$100K pre-seed |
| **Team size** | 5 founding members |
| **Budget (9 months)** | $120K |
| **Supabase project** | oadzaefwrfgazsyqqjqk.supabase.co |
| **Flutter SDK** | C:\src\flutter |

---

## Tomorrow's Agenda

1. **Clean up** — delete redundant component files
2. **Integrate** — add UI improvements to screens
3. **Test** — verify app works with real data
4. **Deploy** — Edge Functions + Firebase + Flutterwave

---

*See you tomorrow. We've got a solid foundation — requirements, design direction, competitive analysis, working code. Now we polish and ship.*

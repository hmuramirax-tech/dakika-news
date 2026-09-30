# DAKIKA — Read the day in 60 seconds

AI-powered news summarization app for East Africa. Launching in Rwanda, expanding to Kenya, Uganda, and Tanzania.

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (Dart) |
| Backend | Python (FastAPI) |
| Database | Supabase (PostgreSQL) |
| Auth | Supabase Auth (phone + OTP) |
| Payments | MTN MoMo, Airtel Money, Flutterwave |
| Push Notifications | Firebase Cloud Messaging |
| Analytics | PostHog + Firebase Analytics |
| CDN | Cloudflare |

## Project Structure

```
lib/
├── main.dart              # App entry point
├── router.dart            # GoRouter navigation
├── theme/
│   └── tokens.dart        # Design tokens (colors, spacing, type)
├── components/
│   ├── ring.dart          # 60-Second Ring (signature element)
│   ├── story_card.dart    # Story card (unit of consumption)
│   ├── category_tabs.dart # Horizontal category filter
│   └── greeting.dart      # Time-based greeting
├── screens/
│   ├── splash.dart        # Splash (1.5s, ring animation)
│   ├── digest_feed.dart   # Core screen — story feed
│   ├── explore.dart       # Search, trending, categories
│   ├── saved.dart         # Saved stories
│   ├── profile.dart       # Settings, language, density
│   └── full_article.dart  # Article view with AI summary
└── providers/
    └── providers.dart     # Riverpod state management
```

## Design System

- **Colors:** Warm off-white (#FAFAF8) + forest green (#1B7A3D)
- **Typography:** Fraunces (headlines) + Inter (body) + JetBrains Mono (data)
- **Signature:** 60-Second Ring — circular progress indicator on every screen
- **Density:** Comfortable (default) + Compact (low-end devices)

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

## Environment Setup

Create a `.env` file in the project root:

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
FIREBASE_PROJECT_ID=your-firebase-project
```

## Documentation

- [BRD & Roadmap](docs/BRD-Roadmap-Source.md)
- [UI/UX Requirements](docs/UIUX-Requirements.md)
- [Project State](docs/PROJECT-STATE.md)
- [Business Plan](OneNewsApp_BusinessPlan.md)

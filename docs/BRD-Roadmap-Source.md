# OneNews App — Business Requirements Document & Project Roadmap

**Document Code:** ON-2026-BRD-001  
**Version:** v1.0  
**Status:** DRAFT  
**Date:** September 2026  
**Author:** OneNews Product Team  

---

## 1. Executive Summary

OneNews is a mobile-first AI news application that distills East African news into 60-second reads, designed for busy professionals who want to stay informed without spending hours scrolling. The app launches in Rwanda and expands across East Africa (Kenya, Uganda, Tanzania) within 24 months.

The product addresses a critical gap in the East African media landscape: there is no AI-powered news summarization app that delivers concise, personalized news in local languages (Kinyarwanda, Swahili, English) at a price point accessible to the mass market.

**Key Value Propositions:**
- 60-second AI summaries — consume a full news digest in under a minute
- Local language support — Kinyarwanda, English, and Swahili from launch
- Mobile money integration — subscribe for $0.20/month via MTN MoMo, Airtel Money, or M-Pesa
- Offline-first design — download digests and read during commutes, even with no signal
- Trust through transparency — every summary clearly shows its original source

**Target Launch:** Q1 2027 (Rwanda)  
**Target Markets:** Rwanda → Kenya → Uganda → Tanzania  
**Funding Sought:** $50K–$100K pre-seed

---

## 2. Business Context & Objectives

### 2.1 Current State (AS-IS)

The East African digital news landscape is characterized by:
- Information overload — too many sources, too much noise, too little time
- Low trust in digital news — only 9% of Rwandans are on social media; radio remains most trusted
- No concise format — full articles take 5–10 minutes to read; no 60-second summary format exists
- Language barriers — most apps are English-only; Kinyarwanda and Swahili are underserved
- Data costs — while improving, data is still a barrier for many users
- Payment friction — credit cards reach only 5% of Africans; mobile money reaches 60%+

### 2.2 Desired Future State (TO-BE)

OneNews transforms news consumption from a 30-minute daily chore into a 60-second routine. Users open the app, swipe through 10–15 AI-summarized stories, tap to read full articles if interested, and go about their day — informed, not overwhelmed.

### 2.3 Business Objectives

| ID | Objective | Target | Timeline |
|---|---|---|---|
| OBJ-001 | Launch OneNews in Rwanda with 100K downloads | 100,000 | Q2 2027 |
| OBJ-002 | Achieve 30K MAU in Rwanda | 30,000 | Q4 2027 |
| OBJ-003 | Expand to Kenya with 200K downloads | 200,000 | Q2 2028 |
| OBJ-004 | Reach $500K annual revenue | $500,000 | Q4 2028 |
| OBJ-005 | Expand to Uganda and Tanzania | 500K total downloads | Q4 2028 |

### 2.4 Success Metrics / KPIs

| Metric | Target (Year 1) | Target (Year 2) | Target (Year 3) |
|---|---|---|---|
| Downloads | 100K | 500K | 1.5M |
| Monthly Active Users | 30K | 150K | 500K |
| Premium Conversion Rate | 15% | 20% | 25% |
| Daily Active Users | 5K | 20K | 100K |
| Session Duration | 3 min | 4 min | 5 min |
| Day 7 Retention | 25% | 35% | 40% |
| Day 30 Retention | 10% | 15% | 20% |
| Revenue | $50K–$100K | $300K–$550K | $1M–$2M |

---

## 3. Scope

### 3.1 In-Scope
- AI-powered news summarization engine (extractive + abstractive)
- Mobile application (Android-first, iOS secondary) — Flutter framework
- Content ingestion pipeline (RSS, API, web scraping)
- Kinyarwanda and English language support at launch
- Swahili language support for East Africa expansion
- Category-based news feeds (Sports, Business, Tech, Politics, Entertainment, Health)
- Offline mode — download digests for offline reading
- Push notifications for breaking news
- Mobile money payment integration (MTN MoMo, Airtel Money, M-Pesa)
- Advertising integration (Google AdMob + direct brand deals)
- SMS/USSD news service for feature phone users
- Analytics and user behavior tracking
- Admin dashboard for content management

### 3.2 Out-of-Scope
- Original journalism / in-house reporting (we aggregate, we don't produce)
- Video production (audio summaries only at launch)
- Web application (mobile-only at launch; web version in Phase 2)
- Podcast production
- E-commerce / marketplace features
- Social network / user-generated content
- Print or physical distribution
- West or Central Africa expansion (future consideration)

---

## 4. Stakeholders & RACI

| Stakeholder | Role | RACI |
|---|---|---|
| Founder / CEO | Product vision, strategy, fundraising | A |
| CTO / Co-Founder | Technical architecture, AI/ML, engineering | R |
| Mobile Developer | Flutter app development | R |
| Backend / AI Engineer | API, AI pipeline, infrastructure | R |
| Content Editor | Quality control, source relationships | R |
| Marketing Lead | User acquisition, brand, partnerships | R |
| Sales / Partnerships | Advertiser and telecom partnerships | R |
| Media Partners | Content licensing, source feeds | C |
| Telecom Partners (MTN, Airtel) | Distribution, data bundles, payments | C |
| End Users | Consumers of the product | I |
| Advisors / Mentors | Strategic guidance | C |

---

## 5. Functional Requirements

### 5.1 Content Ingestion & AI Summarization

**FR-001: News Source Ingestion**
- **Priority:** Must
- **Description:** The system SHALL ingest news articles from approved sources via RSS feeds, APIs, and web scraping at configurable intervals (minimum every 30 minutes).
- **Business Rules:** BR-001, BR-002
- **Acceptance Criteria:**
  - Given a configured RSS feed is active, When new articles are published, Then the system ingests them within 30 minutes
  - Given a source feed is unavailable, When the system attempts ingestion, Then the error is logged and an alert is sent to the admin

**FR-002: AI Summarization Engine**
- **Priority:** Must
- **Description:** The system SHALL generate concise summaries of 40–80 words for each ingested article using a combination of extractive and abstractive AI models.
- **Business Rules:** BR-003, BR-004
- **Acceptance Criteria:**
  - Given an article is ingested, When the AI processes it, Then a 40–80 word summary is generated with source attribution
  - Given an article receives a confidence score below 0.7, When the summary is generated, Then it is queued for human editor review before publishing

**FR-003: Content Categorization**
- **Priority:** Must
- **Description:** The system SHALL automatically categorize each article into one or more of: Sports, Business, Technology, Politics, Entertainment, Health, or General.
- **Business Rules:** BR-005, BR-006
- **Acceptance Criteria:**
  - Given an article is ingested, When AI categorization runs, Then the article is assigned to at least one category
  - Given an article is miscategorized, When an editor corrects it, Then the correction is applied and the AI model is retrained

**FR-004: Content Deduplication**
- **Priority:** Must
- **Description:** The system SHALL detect and merge duplicate stories from multiple sources, presenting a single consolidated summary with all source attributions.
- **Business Rules:** BR-007, BR-008
- **Acceptance Criteria:**
  - Given the same story is reported by 3 sources, When deduplication runs, Then a single story card is displayed with all 3 sources listed
  - Given two stories are 85%+ similar, When deduplication runs, Then they are merged into one story card

**FR-005: Human Editor Review Queue**
- **Priority:** Should
- **Description:** The system SHALL provide a web-based dashboard for human editors to review, edit, approve, or reject AI-generated summaries before publication.
- **Business Rules:** BR-009, BR-010
- **Acceptance Criteria:**
  - Given an editor reviews a summary, When they approve it, Then the summary is published to the app within 5 minutes
  - Given an editor rejects a summary, When they provide a reason, Then the article is returned to the AI queue for regeneration

### 5.2 Mobile Application

**FR-006: Daily Digest Feed**
- **Priority:** Must
- **Description:** The app SHALL display a daily digest of 10–15 top stories, refreshed 3x per day (morning 6:00, afternoon 12:00, evening 18:00 CAT), presented as swipeable cards.
- **Business Rules:** BR-011, BR-012
- **Acceptance Criteria:**
  - Given the app is opened at 7:00 AM, When the morning digest is available, Then 10–15 story cards are displayed
  - Given a user swipes through all stories, When they reach the end, Then a "Load More" option appears

**FR-007: Category Feeds**
- **Priority:** Must
- **Description:** The app SHALL provide dedicated feeds for each news category (Sports, Business, Tech, Politics, Entertainment, Health).
- **Business Rules:** BR-013, BR-014
- **Acceptance Criteria:**
  - Given a user selects the Sports category, When the feed loads, Then the 20 most recent sports stories are displayed
  - Given a user follows Business and Tech, When their daily digest is generated, Then it prioritizes stories from those categories

**FR-008: Full Article View**
- **Priority:** Must
- **Description:** The app SHALL allow users to tap a story card to view the full original article via an in-app browser or external link.
- **Business Rules:** BR-015, BR-016
- **Acceptance Criteria:**
  - Given a user taps a story card, When the full article loads, Then the original article is displayed with source attribution
  - Given a user taps "Read Summary", When the article is open, Then the app returns to the digest view

**FR-009: Offline Mode**
- **Priority:** Must
- **Description:** The app SHALL allow users to download the latest digest for offline reading, with a maximum cache of 3 digests (30 stories).
- **Business Rules:** BR-017, BR-018
- **Acceptance Criteria:**
  - Given a user has downloaded the morning digest, When they open the app offline, Then the full digest is readable
  - Given cached content is older than 72 hours, When the user goes online, Then the app automatically refreshes the cache

**FR-010: Push Notifications**
- **Priority:** Should
- **Description:** The app SHALL send push notifications for breaking news stories, with user-configurable frequency (immediate, hourly digest, daily digest).
- **Business Rules:** BR-019, BR-020
- **Acceptance Criteria:**
  - Given a breaking story is published, When notifications are enabled, Then users receive a push notification within 5 minutes
  - Given a user sets notifications to "daily digest", When breaking stories occur, Then they receive a single summary at the next scheduled time

**FR-011: Language Switching**
- **Priority:** Must
- **Description:** The app SHALL support Kinyarwanda and English at launch, with Swahili added for East Africa expansion. Users can switch languages in settings.
- **Business Rules:** BR-021, BR-022
- **Acceptance Criteria:**
  - Given a user selects Kinyarwanda in settings, When they return to the app, Then all UI and content is displayed in Kinyarwanda
  - Given a user switches from English to Swahili, When the app reloads, Then all content is displayed in Swahili

**FR-012: Search**
- **Priority:** Should
- **Description:** The app SHALL provide a search function that allows users to search past digests by keyword, category, or date.
- **Business Rules:** BR-023, BR-024
- **Acceptance Criteria:**
  - Given a user searches "MTN", When the search runs, Then all stories mentioning MTN from the past 7 days are displayed
  - Given a user searches with no results, When the search completes, Then a "No results found" message is displayed with suggestions

### 5.3 Monetization

**FR-013: Mobile Money Subscriptions**
- **Priority:** Must
- **Description:** The app SHALL integrate with MTN MoMo and Airtel Money APIs to enable micro-subscriptions at Rwf 300/month (~$0.20) for premium features (ad-free, offline mode, audio summaries).
- **Business Rules:** BR-025, BR-026, BR-027
- **Acceptance Criteria:**
  - Given a user selects Premium, When they confirm payment via MoMo, Then their account is upgraded within 30 seconds
  - Given a payment fails, When the retry period expires, Then the user is notified and downgraded to Free tier

**FR-014: Advertising Integration**
- **Priority:** Must
- **Description:** The app SHALL display advertisements via Google AdMob (banner and interstitial) and support direct sponsored content placements.
- **Business Rules:** BR-028, BR-029, BR-030
- **Acceptance Criteria:**
  - Given a free user opens a digest, When the feed loads, Then a maximum of 5 ads are displayed throughout the session
  - Given a premium user opens a digest, When the feed loads, Then no ads are displayed

**FR-015: SMS/USSD News Service**
- **Priority:** Should
- **Description:** The system SHALL provide an SMS-based news digest service for feature phone users, accessible via shortcode, with carrier billing.
- **Business Rules:** BR-031, BR-032
- **Acceptance Criteria:**
  - Given a user sends "NEWS" to the shortcode, When the system receives it, Then a 5-story digest is sent via SMS within 2 minutes
  - Given a user sends "STOP" to the shortcode, When the system receives it, Then they are unsubscribed from the SMS service

### 5.4 Admin & Analytics

**FR-016: Admin Dashboard**
- **Priority:** Must
- **Description:** The system SHALL provide a web-based admin dashboard for content management, user management, and analytics.
- **Business Rules:** BR-033, BR-034
- **Acceptance Criteria:**
  - Given an admin logs in, When the dashboard loads, Then they can view content, users, and analytics
  - Given an admin edits a summary, When they save it, Then the change is reflected in the app within 5 minutes

**FR-017: Analytics & Reporting**
- **Priority:** Must
- **Description:** The system SHALL track and report key metrics including DAU, MAU, retention, session duration, stories read, and revenue.
- **Business Rules:** BR-035, BR-036
- **Acceptance Criteria:**
  - Given an admin requests a report, When the date range is selected, Then the report is generated and downloadable
  - Given a user opts out of analytics, When they use the app, Then their behavior is not tracked

---

## 6. Non-Functional Requirements

| ID | Category | Requirement | Priority |
|---|---|---|---|
| NFR-001 | Performance | App SHALL load the daily digest in ≤ 3 seconds on 4G networks | Must |
| NFR-002 | Performance | AI summarization SHALL process 100 articles in ≤ 5 minutes | Must |
| NFR-003 | Availability | System SHALL maintain 99.5% uptime during business hours (Mon–Sat 06:00–22:00 CAT) | Must |
| NFR-004 | Scalability | System SHALL support 500K concurrent users without degradation | Should |
| NFR-005 | Security | All API calls SHALL use TLS 1.2 or higher | Must |
| NFR-006 | Security | User payment data SHALL be encrypted at rest (AES-256) and never stored on device | Must |
| NFR-007 | Security | Admin dashboard SHALL require multi-factor authentication | Must |
| NFR-008 | Compatibility | App SHALL run on Android 8.0+ with 2GB RAM minimum | Must |
| NFR-009 | Compatibility | App SHALL support iOS 14.0+ (Phase 2) | Should |
| NFR-010 | Data Usage | A full digest load SHALL consume ≤ 500KB of data | Must |
| NFR-011 | Localization | All UI SHALL be localizable (Kinyarwanda, English, Swahili) | Must |
| NFR-012 | Auditability | All state changes SHALL be logged to an audit trail within 1 second | Must |
| NFR-013 | Backup | Database SHALL be backed up daily with 30-day retention | Must |
| NFR-014 | Monitoring | System SHALL alert on-call team for any downtime > 5 minutes | Must |
| NFR-015 | Compatibility | App SHALL support a "Compact" display mode (reduced spacing, smaller text) for low-end devices and user preference | Should |
| NFR-016 | Compatibility | App SHALL support a "Comfortable" display mode (default) with full spacing and readable text sizes | Must |
| NFR-017 | Localization | Swahili language support SHALL be implemented for East Africa expansion (Phase 4) | Must |
| NFR-018 | Payments | System SHALL support Flutterwave for pan-African payment processing (M-Pesa, card payments, multi-currency) | Must |

---

## 7. Business Rules

| ID | Rule | Source |
|---|---|---|
| BR-001 | Only pre-approved, credible news sources shall be ingested | Editorial Policy |
| BR-002 | All ingested content shall be timestamped with source attribution | Editorial Policy |
| BR-003 | Summaries shall be generated in the same language as the source | AI Policy |
| BR-004 | Articles with AI confidence < 0.7 shall be flagged for human review | Quality Policy |
| BR-005 | Articles may belong to multiple categories | Taxonomy |
| BR-006 | Category assignments shall be reviewable by human editors | Editorial Policy |
| BR-007 | Duplicate detection threshold: 85% semantic similarity | Technical Standard |
| BR-008 | Primary source (earliest published) listed first | Editorial Policy |
| BR-009 | Editors can edit summaries, change categories, add/remove sources | Editorial Policy |
| BR-010 | All editor actions logged with editor ID and timestamp | Audit Policy |
| BR-011 | Story cards display: summary, source, category, timestamp | Product Spec |
| BR-012 | Stories sorted by relevance score then recency | Product Spec |
| BR-013 | Category feeds show 20 most recent stories | Product Spec |
| BR-014 | Users can follow/unfollow categories | Product Spec |
| BR-015 | Full article view shows source name and URL | Product Spec |
| BR-016 | "Read Summary" button returns to digest | Product Spec |
| BR-017 | Offline cache: max 3 digests, 30 stories | Technical Spec |
| BR-018 | Cached content expires after 72 hours | Technical Spec |
| BR-019 | Users can opt out of push notifications | Product Spec |
| BR-020 | Breaking news notifications limited to 3 per day | Product Spec |
| BR-021 | Language preference persists across sessions | Product Spec |
| BR-022 | All UI elements translated, not just content | Localization Policy |
| BR-023 | Search covers past 7 days of digests | Product Spec |
| BR-024 | Search results ranked by relevance | Product Spec |
| BR-025 | Subscriptions auto-renew monthly unless cancelled | Payment Policy |
| BR-026 | Payment confirmation via SMS + in-app | Payment Policy |
| BR-027 | Failed payments: retry after 24h, cancel after 72h | Payment Policy |
| BR-028 | Free tier: max 5 ads per digest session | Ad Policy |
| BR-029 | Ads clearly labeled as "Sponsored" or "Advertisement" | Ad Policy |
| BR-030 | Premium users see zero ads | Ad Policy |
| BR-031 | SMS digests limited to 5 stories per message | SMS Policy |
| BR-032 | Users can opt in/out via SMS commands | SMS Policy |
| BR-033 | Only authorized admin users access dashboard | Security Policy |
| BR-034 | All admin actions logged to audit trail | Audit Policy |
| BR-035 | Analytics aggregated and anonymized | Privacy Policy |
| BR-036 | Reports exportable in CSV and PDF | Product Spec |

---

## 8. Integration Requirements

| System | Purpose | Type | Direction | Auth |
|---|---|---|---|---|
| MTN MoMo API | Mobile money payments (Rwanda) | REST API | Outbound | OAuth 2.0 |
| Airtel Money API | Mobile money payments (Rwanda) | REST API | Outbound | OAuth 2.0 |
| Flutterwave API | Pan-African payments (M-Pesa, cards, multi-currency) | REST API | Outbound | API Key |
| M-Pesa API | Mobile money payments (Kenya) | REST API | Outbound | OAuth 2.0 |
| Google AdMob | Advertising | SDK | Inbound | API Key |
| Firebase Cloud Messaging | Push notifications | REST API | Outbound | Server Key |
| News Source RSS Feeds | Content ingestion | RSS/Atom | Inbound | None |
| News Source APIs | Content ingestion | REST API | Inbound | API Key |
| AI/LLM API (GPT-4o/Claude) | Summarization | REST API | Outbound | API Key |
| Supabase | Database, auth, realtime, storage | REST API | Bidirectional | API Key |
| PostHog | Product analytics | REST API | Outbound | API Key |
| Carrier Billing (SMS) | SMS news service | SMS Gateway | Bidirectional | API Key |

---

## 9. Data Requirements

### 9.1 Key Entities

| Entity | Key Attributes | Description |
|---|---|---|
| Article | id, title, summary, source_id, category, published_at, language, confidence_score, status | A news article ingested from a source |
| Source | id, name, url, rss_feed_url, language, credibility_score, is_active | A news source (e.g., The New Times, Igihe) |
| Category | id, name, name_en, name_rw, name_sw, is_active | News category (Sports, Business, etc.) |
| User | id, phone, language, subscription_tier, created_at, last_active | App user |
| Subscription | id, user_id, tier, start_date, end_date, payment_status, provider | User subscription record |
| Digest | id, date, period (morning/afternoon/evening), story_ids, created_at | A daily digest collection |
| Ad | id, type, content, sponsor, placement, start_date, end_date, is_active | Advertisement record |
| EditorAction | id, editor_id, article_id, action, timestamp, notes | Audit trail for editor actions |

### 9.2 Data Retention
- Article content: 90 days in active storage, 1 year in archive
- User data: retained until account deletion request
- Analytics data: 2 years aggregated, 90 days raw
- Audit logs: 7 years (regulatory compliance)

### 9.3 Sensitive Data Classification

| Data | Classification | Handling |
|---|---|---|
| User phone number | PII | Encrypted at rest, masked in logs |
| Payment information | Financial | Tokenized, never stored on device |
| Reading history | Behavioral | Anonymized for analytics, retained 90 days |
| Admin credentials | Security | Hashed (bcrypt), MFA required |

---

## 10. Security & Compliance

### 10.1 Authentication & Authorization
- User authentication: Phone number + OTP (no passwords)
- Admin authentication: Email + password + MFA
- Role-based access control (RBAC): Admin, Editor, Viewer roles
- Session management: JWT tokens with 24-hour expiry

### 10.2 Encryption
- In transit: TLS 1.2+ for all API calls
- At rest: AES-256 for database, encrypted backups
- Payment data: Tokenized via mobile money provider APIs

### 10.3 Regulatory Compliance
- Rwanda Data Protection Law (2021) — user consent, data minimization, right to deletion
- BNR (National Bank of Rwanda) — mobile money regulations for payment processing
- RURA (Rwanda Utilities Regulatory Authority) — telecom and data regulations
- GDPR considerations for any EU users

### 10.4 Data Privacy
- Explicit opt-in for analytics tracking
- Explicit opt-in for push notifications
- Clear privacy policy in app and on website
- Data deletion request process (30-day response)

---

## 11. Acceptance Criteria Summary

| FR-ID | FR Title | Acceptance Criteria Summary |
|---|---|---|
| FR-001 | News Source Ingestion | Ingests within 30 min; logs errors |
| FR-002 | AI Summarization Engine | 40–80 word summaries; confidence scoring |
| FR-003 | Content Categorization | Auto-categorize; editor reviewable |
| FR-004 | Content Deduplication | 85% similarity threshold; merge sources |
| FR-005 | Human Editor Review Queue | Web dashboard; audit logged |
| FR-006 | Daily Digest Feed | 10–15 stories; 3x daily refresh |
| FR-007 | Category Feeds | 20 stories per category; follow/unfollow |
| FR-008 | Full Article View | In-app browser; source attribution |
| FR-009 | Offline Mode | 3 digests cached; 72-hour expiry |
| FR-010 | Push Notifications | Configurable; max 3/day breaking |
| FR-011 | Language Switching | Kinyarwanda, English, Swahili |
| FR-012 | Search | 7-day lookback; relevance ranked |
| FR-013 | Mobile Money Subscriptions | MoMo/Airtel; auto-renew; retry logic |
| FR-014 | Advertising Integration | AdMob + direct; 5 ads max free tier |
| FR-015 | SMS/USSD News Service | 5 stories per SMS; opt in/out |
| FR-016 | Admin Dashboard | Web-based; RBAC; audit logged |
| FR-017 | Analytics & Reporting | DAU/MAU/retention; exportable |
| FR-018 | Display Density Toggle | User can switch between Comfortable and Compact modes; preference persists |

---

## 12. Assumptions & Dependencies

### 12.1 Assumptions
- MTN MoMo and Airtel Money APIs will be available for integration within 3 months
- At least 5 Rwandan news sources will agree to content partnerships
- AI/LLM API costs will remain stable at ~$0.01–0.05 per article
- Rwanda regulatory environment will remain favorable for digital news apps
- Smartphone adoption in Rwanda will continue to grow at current rates
- Users will be willing to pay $0.20/month for ad-free news

### 12.2 Dependencies

| Dependency | Owner | Target Date | Risk |
|---|---|---|---|
| MTN MoMo API access | CTO | Month 2 | Medium |
| Airtel Money API access | CTO | Month 2 | Medium |
| Flutterwave API access | CTO | Month 3 | Low |
| Supabase project setup | CTO | Month 1 | Low |
| Content partnerships (5+ sources) | CEO | Month 3 | Low |
| AI/LLM API access | CTO | Month 1 | Low |
| Google Play Store listing | Mobile Dev | Month 4 | Low |
| Firebase project setup | CTO | Month 1 | Low |
| Brand identity design | Marketing | Month 2 | Low |
| Legal review (data protection) | CEO | Month 3 | Medium |

### 12.3 Constraints
- Budget: $50K–$100K pre-seed for first 6 months
- Timeline: MVP in 4 months, launch in Month 5
- Team: 5 founding members, no external hires in Phase 1
- Technology: Flutter for mobile, Python/FastAPI for backend, Supabase (PostgreSQL) for database
- Infrastructure: Supabase (backend/database) + Cloudflare (CDN), Africa-based edge preferred

---

## 13. Open Issues / Parking Lot

| # | Issue | Owner | Target Resolution |
|---|---|---|---|
| 1 | Which AI/LLM provider to use long-term (cost vs. quality tradeoff) | CTO | Month 3 |
| 2 | Whether to build custom AI model vs. use API | CTO | Month 6 |
| 3 | Telecom partnership terms (revenue share vs. flat fee) | CEO | Month 4 |
| 4 | Content licensing agreements with media partners | CEO | Month 3 |
| 5 | Rwanda data protection registration requirements | CEO | Month 3 |
| 6 | iOS app timeline (Phase 2 or later) | CTO | Month 6 |
| 7 | SMS shortcode acquisition process | CTO | Month 4 |
| 8 | Advertising sales strategy (in-house vs. partner) | CEO | Month 6 |
| 9 | Flutterwave API access for pan-African payments | CTO | Month 3 |
| 10 | Supabase project setup & schema design | CTO | Month 1 |

---

## 14. Glossary

| Term | Definition |
|---|---|
| AI | Artificial Intelligence |
| API | Application Programming Interface |
| BNR | Banque Nationale du Rwanda — National Bank of Rwanda |
| CAT | Central Africa Time (UTC+2) |
| CMS | Content Management System |
| DAU | Daily Active Users |
| EAC | East African Community |
| KPI | Key Performance Indicator |
| LLM | Large Language Model |
| MAU | Monthly Active Users |
| MFA | Multi-Factor Authentication |
| MoMo | MTN Mobile Money |
| MVP | Minimum Viable Product |
| NFR | Non-Functional Requirement |
| OTP | One-Time Password |
| PII | Personally Identifiable Information |
| RBAC | Role-Based Access Control |
| RURA | Rwanda Utilities Regulatory Authority |
| SMS | Short Message Service |
| USSD | Unstructured Supplementary Service Data |

---

## 15. Project Roadmap

### Phase 1: Foundation (Months 1–3)

| Deliverable | Owner | Timeline | Status |
|---|---|---|---|
| Company registration & legal setup | CEO | Month 1 | Not Started |
| Brand identity & app mockups | Marketing | Month 1–2 | Not Started |
| Cloud infrastructure setup (Supabase + Cloudflare) | CTO | Month 1 | Not Started |
| Firebase project & analytics setup | CTO | Month 1 | Not Started |
| Content partnership agreements (5+ sources) | CEO | Month 2–3 | Not Started |
| MTN MoMo API integration | CTO | Month 2 | Not Started |
| Airtel Money API integration | CTO | Month 2 | Not Started |
| Flutterwave API integration | CTO | Month 3 | Not Started |
| AI/LLM API integration & testing | CTO | Month 1–2 | Not Started |
| Content ingestion pipeline (RSS/scraping) | Backend | Month 2 | Not Started |
| AI summarization engine v1 | Backend | Month 2–3 | Not Started |
| Flutter app scaffold & navigation | Mobile Dev | Month 2 | Not Started |
| Admin dashboard v1 (web) | Backend | Month 3 | Not Started |
| Legal review (data protection compliance) | CEO | Month 3 | Not Started |

**Phase 1 Exit Criteria:**
- Working AI summarization pipeline processing 50+ articles/day
- Mobile app scaffold with basic navigation and digest view
- At least 3 content partnership agreements signed
- MTN MoMo payment integration tested in sandbox

### Phase 2: MVP Build (Months 4–6)

| Deliverable | Owner | Timeline | Status |
|---|---|---|---|
| Daily digest feed (10–15 stories, 3x daily) | Mobile Dev | Month 4 | Not Started |
| Category feeds (6 categories) | Mobile Dev | Month 4 | Not Started |
| Full article view (in-app browser) | Mobile Dev | Month 4 | Not Started |
| Offline mode (download & cache) | Mobile Dev | Month 5 | Not Started |
| Push notifications (Firebase) | Mobile Dev | Month 5 | Not Started |
| Language switching (Kinyarwanda + English) | Mobile Dev | Month 5 | Not Started |
| Search functionality | Mobile Dev | Month 5 | Not Started |
| Mobile money subscription flow | Mobile Dev | Month 5 | Not Started |
| AdMob integration (banner + interstitial) | Mobile Dev | Month 6 | Not Started |
| Admin dashboard v2 (content + user management) | Backend | Month 4–5 | Not Started |
| Analytics & reporting dashboard | Backend | Month 5 | Not Started |
| Beta testing with 100 users | CEO | Month 6 | Not Started |
| Bug fixes & performance optimization | All | Month 6 | Not Started |

**Phase 2 Exit Criteria:**
- MVP feature-complete with all Must-have FRs implemented
- Beta test with 100 users completed; feedback incorporated
- App performance: digest loads in ≤ 3 seconds on 4G
- AI summarization quality: 90%+ accuracy on human review

### Phase 3: Rwanda Launch (Months 7–9)

| Deliverable | Owner | Timeline | Status |
|---|---|---|---|
| Google Play Store listing & ASO | Mobile Dev | Month 7 | Not Started |
| Public launch in Rwanda | CEO | Month 7 | Not Started |
| Press & media outreach | Marketing | Month 7 | Not Started |
| Social media campaigns (Meta, TikTok) | Marketing | Month 7–8 | Not Started |
| Referral program launch | Marketing | Month 8 | Not Started |
| Direct advertiser outreach (5+ brands) | Sales | Month 7–8 | Not Started |
| Telecom partnership (MTN data bundles) | CEO | Month 8 | Not Started |
| SMS/USSD news service launch | CTO | Month 8 | Not Started |
| User feedback iteration (weekly sprints) | All | Month 7–9 | Not Started |
| Premium subscription optimization | CEO | Month 9 | Not Started |

**Phase 3 Exit Criteria:**
- 50K downloads, 15K MAU in Rwanda
- At least 3 active brand advertising deals
- Telecom partnership with MTN signed
- Monthly revenue of $5K–$10K

### Phase 4: Growth & Kenya Expansion (Months 10–18)

| Deliverable | Owner | Timeline | Status |
|---|---|---|---|
| Swahili language support | Mobile Dev | Month 10–11 | Not Started |
| M-Pesa API integration | CTO | Month 10 | Not Started |
| Kenyan content partnerships (10+ sources) | CEO | Month 10–11 | Not Started |
| iOS app launch | Mobile Dev | Month 11–12 | Not Started |
| Kenya market entry & launch | CEO | Month 12 | Not Started |
| Nairobi marketing campaign | Marketing | Month 12–13 | Not Started |
| B2B licensing pilot (media companies) | CEO | Month 14 | Not Started |
| Audio summaries (AI voice) | Mobile Dev | Month 14 | Not Started |
| Personalization engine v2 | Backend | Month 15 | Not Started |
| Uganda market preparation | CEO | Month 16–17 | Not Started |
| Uganda launch | CEO | Month 18 | Not Started |

**Phase 4 Exit Criteria:**
- 200K downloads across Rwanda and Kenya
- 100K MAU across both markets
- Monthly revenue of $30K–$50K
- At least 2 B2B licensing deals signed

### Phase 5: Scale (Months 19–36)

| Deliverable | Owner | Timeline | Status |
|---|---|---|---|
| Tanzania market launch | CEO | Month 20–22 | Not Started |
| Pan-African expansion planning | CEO | Month 24 | Not Started |
| Series A fundraising | CEO | Month 24–30 | Not Started |
| Team expansion (15+ people) | CEO | Month 24–30 | Not Started |
| AI model fine-tuning (custom model) | CTO | Month 20–24 | Not Started |
| Web application launch | CTO | Month 22 | Not Started |
| Events & community building | Marketing | Ongoing | Not Started |
| B2B platform launch (white-label) | CTO | Month 26 | Not Started |

**Phase 5 Exit Criteria:**
- 1.5M downloads across 4+ countries
- 500K MAU
- $1M–$2M annual revenue
- Series A raised ($1M–$3M)

### 15.9 Timeline Summary

| Phase | Period | Key Milestone | Revenue Target |
|---|---|---|---|
| Phase 1: Foundation | Months 1–3 | AI pipeline + partnerships | $0 |
| Phase 2: MVP Build | Months 4–6 | Feature-complete MVP | $0 |
| Phase 3: Rwanda Launch | Months 7–9 | 50K downloads, 15K MAU | $5K–$10K/mo |
| Phase 4: Growth & Kenya | Months 10–18 | 200K downloads, 100K MAU | $30K–$50K/mo |
| Phase 5: Scale | Months 19–36 | 1.5M downloads, 500K MAU | $100K–$150K/mo |

---

## 16. Budget Summary

| Category | Phase 1 | Phase 2 | Phase 3 | Total |
|---|---|---|---|---|
| Team salaries | $15,000 | $25,000 | $35,000 | $75,000 |
| Infrastructure (Supabase + Cloudflare) | $500 | $2,000 | $4,000 | $6,500 |
| AI/LLM API costs | $500 | $2,000 | $5,000 | $7,500 |
| Marketing | $500 | $2,000 | $10,000 | $12,500 |
| Legal & admin | $2,000 | $1,000 | $2,000 | $5,000 |
| Contingency | $1,500 | $4,000 | $8,000 | $13,500 |
| **Total** | **$20,000** | **$36,000** | **$64,000** | **$120,000** |

---

*Document generated: September 2026*  
*Next review: October 2026*

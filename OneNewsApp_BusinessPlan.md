# OneNews App — Business Plan & Go-to-Market Strategy

**AI-Powered News Summarization for East Africa**
**Launch Market: Rwanda | Expansion: Kenya, Uganda, Tanzania**

---

## 1. Executive Summary

OneNews is a mobile-first AI news app that distills headlines into 60-second reads, designed for busy professionals who want to stay informed without spending hours scrolling. Starting in Rwanda, we leverage the country's 90% mobile money penetration to power a micro-subscription model unavailable in most African markets, then scale across East Africa where digital ad spend is growing 15%+ annually.

**Vision:** Become the most trusted source of quick, concise news for East Africans.

**Launch:** Rwanda (Kigali-first, national within 6 months)
**Expansion:** Kenya (Month 12–18), Uganda & Tanzania (Month 18–24)
**Year 1 Target:** 100K downloads, 30K MAU, $50K–$100K revenue
**Year 2 Target:** 500K downloads, 150K MAU, $300K–$500K revenue
**Year 3 Target:** 1.5M downloads, 500K MAU, $1M–$2M revenue

---

## 2. Problem Statement

### The Core Problem
East Africans are **information-rich but time-poor.** The average urban professional:
- Has 30–60 minutes of daily commute time
- Spends 6+ hours daily on their phone
- Feels overwhelmed by the volume of news available
- Doesn't trust most online news sources (only 9% of Rwandans are on social media)
- Can't afford or doesn't want to pay $10/month for Western news subscriptions

### The Gap
- **Full articles:** Too long, too slow, data-heavy
- **Social media news:** Too untrustworthy, too scattered, too noisy
- **Radio:** Can't consume on-demand, no personalization
- **Western apps (Inshorts, SmartNews):** Don't cover local African news, not in local languages, not designed for low-end Android devices

### The Opportunity
An AI app that reads the news for you, tells you what matters in 60 seconds, in your language, on your phone, for less than the price of a coffee.

---

## 3. Product Definition

### Core Features (MVP)

| Feature | Description | Priority |
|---|---|---|
| **AI Headline Digest** | 10–15 top stories summarized into 60-word reads, refreshed 3x daily | P0 |
| **Category Feeds** | Sports, Business, Tech, Politics, Entertainment, Health | P0 |
| **Kinyarwanda + English** | Bilingual summaries from launch | P0 |
| **Read Full Story** | Link to original source for deep readers | P0 |
| **Offline Mode** | Download digest for offline reading (commute-friendly) | P1 |
| **Personalization** | "For You" feed based on reading habits | P1 |
| **Push Notifications** | Breaking news alerts (opt-in) | P1 |
| **Ad-Free Premium** | Rwf 300/month via MTN MoMo / Airtel Money | P1 |
| **Swahili Support** | For East Africa expansion | P2 |
| **Audio Digest** | AI voice reads summaries aloud (hands-free) | P2 |
| **WhatsApp Sharing** | Share summaries as formatted cards | P2 |

### User Experience Flow

```
[Open App] → [60-Second Digest Loads] → [Swipe Through 10-15 Stories]
     ↓                                          ↓
[Breaking News Push]                    [Tap to Read Full Article]
     ↓                                          ↓
[Personalized "For You"]                 [Share to WhatsApp]
```

### Design Principles
- **Thumb-first:** All interaction within thumb reach
- **Low-data:** <500KB per full digest load
- **Low-end Android:** Runs smoothly on 2GB RAM devices
- **Dark mode:** For battery saving and night reading
- **Card-based:** Swipeable cards, not scroll-heavy feeds

---

## 4. Technical Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────┐
│                    MOBILE CLIENT                        │
│         (Android-first, React Native / Flutter)        │
│  ┌─────────┐  ┌──────────┐  ┌───────────┐  ┌────────┐ │
│  │ Digest  │  │ Category │  │  Offline   │  │  Auth  │ │
│  │  Feed   │  │   Feeds  │  │   Cache    │  │(MoMo)  │ │
│  └─────────┘  └──────────┘  └───────────┘  └────────┘ │
└──────────────────────┬──────────────────────────────────┘
                       │ REST API / GraphQL
┌──────────────────────▼──────────────────────────────────┐
│                   API GATEWAY (AWS/GCP)                 │
│              Rate Limiting, Auth, SSL Termination       │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│              BACKEND SERVICES (Microservices)           │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Content    │  │     AI       │  │  Subscription │  │
│  │  Ingestion   │  │ Summarization│  │   & Billing   │  │
│  │   Service    │  │   Service    │  │   Service     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Personaliz. │  │ Notification │  │   Analytics   │  │
│  │   Engine     │  │   Service    │  │   Service     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│                   DATA LAYER                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐ │
│  │PostgreSQL│  │  Redis   │  │Elasticsearch│  │  S3   │ │
│  │(Content) │  │ (Cache)  │  │  (Search)  │  │(Media)│ │
│  └──────────┘  └──────────┘  └──────────┘  └────────┘ │
└─────────────────────────────────────────────────────────┘
```

### AI Summarization Pipeline

```
[News Sources] → [RSS/API Scraping] → [Deduplication] → [Categorization]
                                                              ↓
[Quality Score] ← [AI Summarization] ← [Translation (EN↔KR)] ←┘
       ↓
[Human Editor Review] → [Publish to App]
```

**AI Model Strategy:**
- **Launch:** Use GPT-4o or Claude API for summarization (cost: ~$0.01–0.05 per article)
- **Scale:** Fine-tune open-source model (Llama 3 8B or similar) on East African news corpus
- **Cost optimization:** Batch processing, caching, and model distillation to reduce per-article cost to <$0.01 at scale

**Content Sources (Rwanda Launch):**
- The New Times, Igihe, KT Press, Rwanda Today, Express News Rwanda
- Rwanda News Agency (RNA)
- BBC Great Lakes, VOA Great Lakes
- Sports: Rwanda FA, local sports blogs
- Business: Rwanda Development Bank, local business publications

### Technology Stack

| Layer | Technology | Rationale |
|---|---|---|
| Mobile | Flutter (Dart) | Single codebase Android/iOS, great performance on low-end devices |
| Backend | Node.js (NestJS) or Python (FastAPI) | Fast development, good AI/ML ecosystem |
| AI/ML | Python (Hugging Face, LangChain) | Best NLP/LLM tooling |
| Database | PostgreSQL + Redis | Relational data + fast caching |
| Search | Elasticsearch | Full-text search across articles |
| Cloud | AWS (eu-west-1) or GCP | Reliable, scalable |
| CDN | Cloudflare | Fast content delivery in Africa |
| Push Notifications | Firebase Cloud Messaging | Free, reliable, works on low-end Android |
| Payments | MTN MoMo API + Airtel Money API | Direct carrier billing |
| Analytics | Mixpanel + Firebase Analytics | User behavior tracking |
| Monitoring | Sentry + Datadog | Error tracking and performance |

### Infrastructure Cost Estimates

| Stage | Monthly Cost | Users |
|---|---|---|
| MVP (Month 1–6) | $200–500/month | 0–50K |
| Growth (Month 6–18) | $500–2,000/month | 50K–500K |
| Scale (Month 18+) | $2,000–10,000/month | 500K+ |

---

## 5. Monetization Strategy

### Revenue Model: Hybrid (Ads + Micro-Subscriptions)

```
┌─────────────────────────────────────────────────────────┐
│                    REVENUE MODEL                        │
│                                                         │
│   FREE TIER (80% of users)    PREMIUM TIER (20%)       │
│   ┌─────────────────┐        ┌─────────────────┐       │
│   │ Ad-supported    │        │ Rwf 300/month   │       │
│   │ 5 ads per digest│        │ (~$0.20)        │       │
│   │ Banner + native │        │ Ad-free         │       │
│   │                 │        │ Offline mode    │       │
│   │                 │        │ Audio digest    │       │
│   │                 │        │ Priority support│       │
│   └────────┬────────┘        └────────┬────────┘       │
│            │                          │                 │
│            ▼                          ▼                 │
│   ┌─────────────────┐        ┌─────────────────┐       │
│   │ Ad Networks:    │        │ MTN MoMo API    │       │
│   │ - Google AdMob  │        │ Airtel Money    │       │
│   │ - Meta Audience │        │                 │       │
│   │ - Local sponsors│        │                 │       │
│   └─────────────────┘        └─────────────────┘       │
└─────────────────────────────────────────────────────────┘
```

### Revenue Streams

#### Stream 1: Micro-Subscriptions (Primary — 60% of revenue)

| Tier | Price | Features | Target |
|---|---|---|---|
| Free | $0 | 10 stories/day, ads, English only | 80% of users |
| Premium | Rwf 300/mo (~$0.20) | Unlimited stories, ad-free, offline, Kinyarwanda, audio | 15% of users |
| Premium+ | Rwf 500/mo (~$0.35) | Everything in Premium + WhatsApp digest + exclusive content | 5% of users |

**Projections (Rwanda, Year 1):**
- 30,000 MAU × 20% premium conversion = 6,000 subscribers
- 6,000 × Rwf 300 = Rwf 1.8M/month = **~$1,500/month = $18,000/year**

**Projections (East Africa, Year 2):**
- 150,000 MAU × 20% premium = 30,000 subscribers
- 30,000 × $0.20 = **$6,000/month = $72,000/year**

#### Stream 2: Advertising (Secondary — 30% of revenue)

| Ad Format | Placement | CPM Estimate | Monthly Revenue |
|---|---|---|---|
| Banner | Bottom of digest | $0.50–1.00 | $500–1,000 |
| Native/Sponsored | Within feed | $2.00–5.00 | $1,000–3,000 |
| Interstitial | Between categories | $1.00–2.00 | $500–1,500 |
| **Total Ad Revenue** | | | **$2,000–5,500/month** |

**Key Advertiser Targets:**
- Telecoms (MTN, Airtel) — already spending heavily on digital
- Banks (BK, KCB, GTBank) — growing digital ad spend
- FMCG (Unilever, Bralirwa) — targeting young consumers
- Betting/Gaming — high ad budgets, but regulatory risk
- Government agencies — digital transformation campaigns

#### Stream 3: B2B Licensing (Future — 10% of revenue)

- License AI summarization engine to media companies
- White-label version for corporate internal communications
- API access for researchers and NGOs
- **Target: $50K–$100K/year by Year 3**

### Revenue Projections Summary

| Year | Rwanda | East Africa | Total | Cumulative |
|---|---|---|---|---|
| Year 1 | $50K–$100K | — | $50K–$100K | $50K–$100K |
| Year 2 | $100K–$150K | $200K–$400K | $300K–$550K | $350K–$650K |
| Year 3 | $150K–$200K | $800K–$1.5M | $1M–$2M | $1.35M–$2.65M |

---

## 6. Go-to-Market Strategy

### Phase 1: Rwanda Launch (Months 1–6)

#### Pre-Launch (Months 1–3)
- [ ] Build MVP with core AI summarization
- [ ] Establish content partnerships with 5–10 Rwandan outlets
- [ ] Set up MTN MoMo and Airtel Money payment integration
- [ ] Recruit 3–5 beta testers from Kigali professional networks
- [ ] Build social media presence (Twitter/X, Instagram, LinkedIn)
- [ ] Create brand identity and app store listings

#### Launch (Month 4)
- [ ] Soft launch in Kigali with 1,000 beta users
- [ ] Iterate on feedback for 4–6 weeks
- [ ] Public launch on Google Play Store
- [ ] Press coverage in The New Times, Igihe, KT Press
- [ ] Launch social media campaign: "60 Seconds to Stay Informed"

#### Growth (Months 5–6)
- [ ] Expand to all Rwandan provinces
- [ ] Launch referral program: "Invite a friend, get 1 week Premium free"
- [ ] Partner with MTN for app preloading or data bundle promotion
- [ ] Begin advertising on Facebook and Instagram (Kigali-targeted)
- [ ] Target: 50K downloads, 15K MAU

### Phase 2: East Africa Expansion (Months 7–18)

#### Kenya Entry (Months 7–12)
- [ ] Add Swahili language support
- [ ] Partner with Kenyan media: The Standard, Nation, The Star
- [ ] Integrate M-Pesa for payments
- [ ] Leverage Kenya's 63% internet penetration and 43M internet users
- [ ] Target Nairobi, Mombasa, Kisumu
- [ ] **Kenya is 10x the opportunity of Rwanda**

#### Uganda & Tanzania (Months 12–18)
- [ ] Expand to Kampala and Dar es Salaam
- [ ] Partner with local media in each country
- [ ] Integrate Airtel Money and Tigo Pesa
- [ ] Target: 200K downloads across the region

### Phase 3: Scale (Months 18–36)
- [ ] Pan-African expansion (Nigeria, Ghana, Senegal)
- [ ] B2B licensing of AI engine
- [ ] Raise Series A funding
- [ ] Target: 1M+ downloads, $1M+ revenue

---

## 7. Marketing Strategy

### Brand Positioning

**"OneNews: 60 Seconds to Stay Informed"**

- **Tone:** Trustworthy, concise, non-partisan
- **Visual:** Clean, modern, mobile-first
- **Voice:** Professional but accessible

### Marketing Channels

| Channel | Budget Allocation | Expected ROI |
|---|---|---|
| Social Media (Meta, TikTok) | 40% | High reach, low cost |
| Influencer Partnerships | 20% | Trusted voices |
| App Store Optimization (ASO) | 15% | Organic discovery |
| PR & Media Coverage | 10% | Credibility |
| Referral Program | 10% | Viral growth |
| Partnerships (MTN, Airtel) | 5% | Distribution |

### Key Marketing Campaigns

1. **"60-Second Challenge"** — Social media campaign showing how much you can learn in 60 seconds with OneNews vs. scrolling for 30 minutes
2. **"News in Your Language"** — Highlight Kinyarwanda support as a differentiator
3. **"Commuter's Companion"** — Target matatu/bus commuters with offline mode
4. **"Trusted Sources"** — Transparency about where news comes from

### User Acquisition Cost (UAC) Estimates

| Channel | Cost per Install | Target CAC |
|---|---|---|
| Organic/ASO | $0 | — |
| Social media ads | $0.50–2.00 | <$1.00 |
| Influencer | $1.00–3.00 | <$2.00 |
| Referral | $0.30–0.50 | <$0.50 |
| **Blended CAC** | | **<$1.00** |

---

## 8. Competitive Landscape

### Direct Competitors

| App | Market | Strengths | Weaknesses | Our Advantage |
|---|---|---|---|---|
| **Inshorts** | India | Proven model, 10M+ users | No Africa presence, no local languages | Local content, local languages, mobile money |
| **SmartNews** | Japan/US | AI-powered, $2B valuation | No Africa focus, no local content | Africa-first, affordable |
| **Google News** | Global | Free, personalized | Too much content, not concise, data-heavy | 60-second reads, offline mode |
| **Apple News** | Global | Premium experience | iOS only, $9.99/month | Android-first, $0.20/month |
| **Local news sites** | Rwanda | Local content | Not summarized, not personalized | AI summaries, mobile-first |

### Indirect Competitors

- **WhatsApp news groups** — untrusted, unstructured
- **Facebook/Meta** — noisy, algorithm-driven, low trust
- **Radio** — trusted but not on-demand, no personalization
- **Word of mouth** — slow, unreliable

### Our Moat

1. **AI summarization quality** — purpose-built for African news context
2. **Local language support** — Kinyarwanda, Swahili, English
3. **Mobile money integration** — seamless $0.20/month subscriptions
4. **Offline-first design** — works in low-connectivity areas
5. **Trust through transparency** — clear source attribution

---

## 9. Team & Hiring Plan

### Founding Team (Month 1)

| Role | Headcount | Cost/Month | Responsibility |
|---|---|---|---|
| CEO/Founder | 1 | — | Strategy, fundraising, partnerships |
| CTO/Co-Founder | 1 | — | Technical architecture, AI/ML |
| Mobile Developer | 1 | $1,500–2,500 | Flutter app development |
| Backend/AI Engineer | 1 | $1,500–2,500 | API, AI pipeline, infrastructure |
| Content Editor | 1 | $800–1,200 | Quality control, source relationships |
| **Total** | **5** | **$3,800–6,200** | |

### Growth Hires (Months 6–18)

| Role | Headcount | Cost/Month | When |
|---|---|---|---|
| Marketing Manager | 1 | $1,000–1,500 | Month 6 |
| Sales/Partnerships | 1 | $1,000–1,500 | Month 9 |
| Additional Developers | 2 | $3,000–5,000 | Month 9–12 |
| Customer Support | 1 | $500–800 | Month 12 |
| **Total** | **10** | **$9,300–15,000** | |

### Organizational Structure

```
                    CEO/Founder
                        │
            ┌───────────┼───────────┐
            │           │           │
         CTO/Co-    Content     Marketing
         Founder    Lead        Lead
            │           │           │
     ┌──────┴──────┐    │     ┌─────┴─────┐
     │             │    │     │           │
  Mobile      Backend/  Editor  Sales    Marketing
  Devs (2)     AI (2)          (1)      Specialist
```

---

## 10. Financial Plan

### Funding Requirements

| Round | Amount | Timing | Use of Funds |
|---|---|---|---|
| **Pre-Seed** | $50K–$100K | Month 0 | MVP build, initial team |
| **Seed** | $250K–$500K | Month 6–9 | Launch, growth, Kenya expansion |
| **Series A** | $1M–$3M | Month 18–24 | Scale, pan-African expansion |

### Pre-Seed Budget (First 6 Months)

| Category | Amount | Notes |
|---|---|---|
| Product Development | $15,000–25,000 | MVP build, AI integration |
| Team (5 people) | $25,000–35,000 | Salaries for 6 months |
| Infrastructure | $2,000–5,000 | Cloud hosting, APIs |
| Marketing | $3,000–5,000 | Launch campaign, ASO |
| Legal & Admin | $2,000–3,000 | Company registration, contracts |
| Contingency | $3,000–7,000 | Unexpected costs |
| **Total** | **$50,000–80,000** | |

### Key Financial Metrics

| Metric | Year 1 | Year 2 | Year 3 |
|---|---|---|---|
| Downloads | 100K | 500K | 1.5M |
| MAU | 30K | 150K | 500K |
| Premium Conversion | 15% | 20% | 25% |
| Revenue | $50K–$100K | $300K–$550K | $1M–$2M |
| Gross Margin | 40% | 55% | 65% |
| Burn Rate | $8K/mo | $15K/mo | $30K/mo |
| Runway | 12 months | 18 months | 24 months |

### Path to Profitability

| Milestone | Target Date | Revenue Required |
|---|---|---|
| Break-even (Rwanda only) | Month 18–24 | $15K/month |
| Break-even (East Africa) | Month 24–30 | $50K/month |
| Profitable | Month 30–36 | $80K/month |

---

## 11. Risk Analysis & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Low user adoption in Rwanda | Medium | High | Invest heavily in marketing; partner with MTN for distribution |
| AI summarization quality issues | Medium | High | Human-in-the-loop at launch; continuous model improvement |
| Government regulatory changes | Low | Medium | Focus on non-political content; maintain good relationships |
| Competition from global players | Medium | Medium | Local content, local languages, local partnerships |
| Payment integration failures | Low | High | Test thoroughly; have fallback payment options |
| Key person dependency | Medium | Medium | Document everything; build redundant systems |
| Funding shortfall | Medium | High | Maintain lean operations; have revenue from Month 1 |

---

## 12. Success Metrics & KPIs

### Product Metrics

| Metric | Target (Month 6) | Target (Month 12) | Target (Month 24) |
|---|---|---|---|
| Daily Active Users (DAU) | 5,000 | 20,000 | 100,000 |
| Monthly Active Users (MAU) | 15,000 | 60,000 | 300,000 |
| DAU/MAU Ratio | 30% | 33% | 33% |
| Session Duration | 3 minutes | 4 minutes | 5 minutes |
| Stories Read per Session | 5 | 7 | 10 |
| Retention (Day 7) | 25% | 35% | 40% |
| Retention (Day 30) | 10% | 15% | 20% |

### Business Metrics

| Metric | Target (Month 6) | Target (Month 12) | Target (Month 24) |
|---|---|---|---|
| Revenue | $5K/month | $15K/month | $80K/month |
| Premium Conversion | 10% | 15% | 25% |
| Customer Acquisition Cost | <$1.50 | <$1.00 | <$0.75 |
| Lifetime Value | $3 | $5 | $8 |
| LTV:CAC Ratio | 2:1 | 5:1 | 10:1 |
| Churn Rate (Monthly) | 15% | 10% | 5% |

---

## 13. 90-Day Action Plan

### Days 1–30: Foundation
- [ ] Finalize co-founder agreement and equity split
- [ ] Register company in Rwanda (or Kenya for holding)
- [ ] Open business bank account
- [ ] Set up cloud infrastructure (AWS/GCP)
- [ ] Begin MVP development (Flutter + FastAPI)
- [ ] Establish 3 content partnerships
- [ ] Design brand identity and app mockups

### Days 31–60: Build
- [ ] Complete MVP with core AI summarization
- [ ] Integrate MTN MoMo payment API
- [ ] Build content ingestion pipeline
- [ ] Recruit 50 beta testers
- [ ] Set up analytics and tracking
- [ ] Begin ASO optimization

### Days 61–90: Launch
- [ ] Closed beta with 50 users
- [ ] Iterate on feedback
- [ ] Public launch on Google Play Store
- [ ] Press outreach and media coverage
- [ ] Launch social media campaigns
- [ ] Begin referral program

---

## 14. Long-Term Vision

### Year 1: Prove the Concept
- Launch in Rwanda, build loyal user base
- Prove AI summarization quality
- Establish mobile money payment flow
- Build brand awareness in Kigali

### Year 2: Regional Expansion
- Launch in Kenya (the big market)
- Expand to Uganda and Tanzania
- Build B2B licensing pipeline
- Raise Series A

### Year 3: Scale & Lead
- Pan-African expansion
- Become the #1 news app in East Africa
- Build AI engine as a platform
- Explore acquisitions of local news apps

### Year 5: Market Leader
- 5M+ users across Africa
- $10M+ annual revenue
- The most trusted news brand in Africa
- Potential exit to major media company or telecom

---

## 15. Conclusion

OneNews sits at the intersection of three powerful trends:

1. **AI democratizing information access** — making news consumption faster and more efficient
2. **Mobile money enabling micro-transactions** — making $0.20/month subscriptions viable for the first time in Africa
3. **East Africa's digital explosion** — internet penetration growing 15%+ annually, smartphone adoption accelerating

The market is real, the technology is proven, and the monetization infrastructure is uniquely strong in Rwanda. The key is to start small, prove the model, and scale fast.

**The question isn't whether this can make money. The question is whether we can execute fast enough to win the market before global players notice the opportunity.**

---

*Prepared: September 2026*
*Version: 1.0*
*Status: Draft for Review*

# OneNews App — Phase 2 Plan (MVP Build)

**Phase:** MVP Build (Months 4–6)  
**Goal:** Feature-complete MVP with live data  
**Target Exit:** MVP ready for beta testing with 100 users

---

## 1. Objectives

| Objective | Target | Success Metric |
|---|---|---|
| Live data integration | Real news from 5+ sources | 50+ articles/day ingested |
| Payment integration | MoMo + Airtel live | 95%+ success rate |
| Performance | Digest loads in ≤ 3s | Tested on low-end Android |
| Beta readiness | 100 users | Recruit and onboard |

---

## 2. Sprint Plan

### Sprint 1 (Month 4, Weeks 1–2): Live Data
| Task | Owner | Deliverable |
|---|---|---|
| Connect to 5+ RSS feeds | Backend | Live article ingestion |
| Test AI summarization with real data | Backend | 50+ articles/day processed |
| Implement content deduplication | Backend | 85% similarity threshold working |
| Add editor review workflow | Backend | Review queue functional |
| Performance test digest feed | Mobile Dev | ≤ 3s load on 4G |

### Sprint 2 (Month 4, Weeks 3–4): Payments
| Task | Owner | Deliverable |
|---|---|---|
| MTN MoMo sandbox integration | CHTO | Payment flow tested |
| Airtel Money sandbox integration | CTO | Payment flow tested |
| Subscription management | Backend | Active/cancelled states working |
| Payment failure handling | Backend | Retry logic implemented |
| Premium feature gating | Mobile Dev | Premium-only features restricted |

### Sprint 3 (Month 5, Weeks 1–2): Polish
| Task | Owner | Deliverable |
|---|---|---|
| UI/UX polish based on feedback | All | Refined screens |
| Offline mode testing | Mobile Dev | 3 digests cached, 72h expiry |
| Push notification testing | Mobile Dev | FCM working |
| Search optimization | Mobile Dev | < 2s response time |
| Admin dashboard v2 | Backend | Content + user management |

### Sprint 4 (Month 5, Weeks 3–4): Beta Prep
| Task | Owner | Deliverable |
|---|---|---|
| Security audit | CTO | All critical issues resolved |
| Performance optimization | All | 60 fps, < 3s load |
| Beta user recruitment | CEO | 100 users signed up |
| Beta testing infrastructure | CTO | Feedback collection ready |
| Bug fixes | All | 0 critical bugs |

### Sprint 5 (Month 6, Weeks 1–2): Beta Testing
| Task | Owner | Deliverable |
|---|---|---|
| Closed beta launch | All | 50 users active |
| Feedback collection | All | Daily feedback reports |
| Bug fixes | All | < 5 open bugs |
| Performance monitoring | CTO | Crash-free rate 99%+ |
| Iteration | All | Weekly updates |

### Sprint 6 (Month 6, Weeks 3–4): Launch Prep
| Task | Owner | Deliverable |
|---|---|---|
| Google Play Store listing | Mobile Dev | Store page live |
| Marketing materials | Marketing | Screenshots, videos, descriptions |
| Press outreach | CEO | 5+ media contacts |
| Launch plan | All | Day-by-day launch schedule |
| Post-launch support | All | On-call rotation |

---

## 3. Technical Requirements

### 3.1 Performance Targets
| Metric | Target |
|---|---|
| Digest load time | ≤ 3 seconds on 4G |
| App cold start | ≤ 2 seconds |
| AI summarization | ≤ 5 min for 100 articles |
| Data per digest | ≤ 500 KB |
| Frame rate | 60 fps |
| Crash-free rate | 99%+ |

### 3.2 Security Requirements
| Requirement | Status |
|---|---|
| TLS 1.2+ for all API calls | Must |
| AES-256 encryption at rest | Must |
| MFA for admin dashboard | Must |
| Rate limiting on Edge Functions | Must |
| Input validation on all endpoints | Must |

---

## 4. Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| MTN MoMo API delays | High | Start integration in Sprint 1 |
| AI quality issues | Medium | Human editor review queue |
| Beta recruitment shortfall | Medium | Start recruitment early |
| Performance issues | Medium | Test on low-end devices early |
| Security vulnerabilities | High | Complete audit before beta |

---

## 5. Success Criteria for Phase 2 Exit

| Criterion | Threshold | Measurement |
|---|---|---|
| Live data integration | 5+ sources, 50+ articles/day | Backend logs |
| Payment success rate | 95%+ | Supabase payment logs |
| Digest load time | ≤ 3 seconds | Performance monitoring |
| AI summary accuracy | 90%+ | Human editor review |
| Beta users | 100 recruited | User database |
| Crash-free rate | 99%+ | Firebase Crashlytics |
| Test coverage | 80%+ | Test suite |

---

## 6. Budget

| Category | Phase 2 Budget |
|---|---|
| Team salaries | $25,000 |
| Infrastructure | $2,000 |
| AI/LLM API costs | $2,000 |
| Marketing | $2,000 |
| Legal & admin | $1,000 |
| Contingency | $4,000 |
| **Total** | **$36,000** |

---

*Next review: End of Sprint 2*

# OneNews App — Beta Testing Strategy

**Version:** 1.0  
**Date:** September 2026  
**Target:** 100 beta users in Rwanda  
**Duration:** 4 weeks (Month 6)

---

## 1. Goals

| Goal | Success Metric |
|---|---|
| Validate core user experience | 80%+ task completion rate |
| Test AI summarization quality | 90%+ accuracy on human review |
| Verify payment flow | 95%+ successful MoMo transactions |
| Measure engagement | 3+ min average session duration |
| Identify critical bugs | 0 crash-on-launch issues |

---

## 2. Beta User Recruitment

### Target Demographics
- **Location:** Kigali, Rwanda
- **Age:** 25–45 (working professionals)
- **Tech comfort:** Medium to high
- **Language:** English or Kinyarwanda speakers
- **Device:** Android 8.0+, 2GB+ RAM

### Recruitment Channels
| Channel | Target | Method |
|---|---|---|
| Personal network | 30 users | Direct invite via WhatsApp |
| University groups | 20 students | Partner with UR, RP campuses |
| Tech communities | 20 users | Kigali Tech Slack, DevFest groups |
| Social media | 20 users | Twitter/X, LinkedIn posts |
| Referrals | 10 users | Early users invite friends |

### Screening Criteria
- Owns an Android smartphone
- Uses mobile money (MoMo/Airtel) regularly
- Reads news at least 3x per week
- Willing to provide feedback via WhatsApp or in-app

---

## 3. Beta Phases

### Phase 1: Internal Alpha (Week 1)
- **Participants:** 5 team members + 5 friends
- **Focus:** Critical bugs, crash testing, basic flow validation
- **Deliverable:** Bug list, stability report

### Phase 2: Closed Beta (Weeks 2–3)
- **Participants:** 50 users
- **Focus:** Core features, payment flow, AI quality
- **Deliverable:** Feature feedback, payment success rate, NPS score

### Phase 3: Open Beta (Week 4)
- **Participants:** 100 users (50 new + 50 from Phase 2)
- **Focus:** Scale testing, retention, engagement metrics
- **Deliverable:** Retention data, engagement metrics, final report

---

## 4. Test Scenarios

### Core Flows to Test
| Flow | Steps | Expected Outcome |
|---|---|---|
| Onboarding | Open app → Phone auth → OTP → Home | Complete in < 2 min |
| Digest browsing | Open app → View stories → Tap article | Smooth scrolling, < 3s load |
| Search | Explore → Search "MTN" → View results | Relevant results in < 2s |
| Save story | Tap bookmark → Check Saved tab | Story appears in Saved |
| Offline mode | Download digest → Go offline → Read | Full digest readable |
| Payment | Upgrade → MoMo → Confirm → Premium | Premium active in < 30s |
| Language switch | Settings → Kinyarwanda → App reloads | All UI in Kinyarwanda |
| Notifications | Enable → Trigger test push | Notification received |

### Edge Cases to Test
- Poor network (2G/3G)
- No network (offline)
- Payment failure
- OTP timeout
- App backgrounded during payment
- Low storage device

---

## 5. Feedback Collection

### In-App Feedback
- Shake-to-report bug button
- "Was this summary helpful?" thumbs up/down on each story
- NPS survey after Day 7

### External Feedback
- WhatsApp group for beta testers
- Weekly feedback form (Google Forms)
- Optional 15-min phone call with power users

### Metrics to Track (via PostHog)
| Metric | Target |
|---|---|
| Daily Active Users (DAU) | 50+ by Week 4 |
| Session duration | 3+ minutes |
| Stories read per session | 5+ |
| Day 7 retention | 25%+ |
| Day 30 retention | 10%+ |
| Crash-free rate | 99%+ |
| Payment success rate | 95%+ |

---

## 6. Success Criteria for Phase 2 Exit

| Criterion | Threshold | Measurement |
|---|---|---|
| Crash-free sessions | 99%+ | Firebase Crashlytics |
| Digest load time | ≤ 3 seconds | Performance monitoring |
| AI summary accuracy | 90%+ | Human editor review |
| Payment success | 95%+ | Supabase payment logs |
| User satisfaction | 7+/10 | NPS survey |
| Critical bugs | 0 open | Bug tracker |

---

## 7. Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Low beta sign-ups | High | Start recruitment early; leverage personal networks |
| Payment failures | High | Test thoroughly in sandbox; have manual fallback |
| AI quality issues | Medium | Human editor review queue; quick iteration |
| Negative feedback | Medium | Respond quickly; show users their feedback matters |
| Scope creep | Medium | Stick to MVP features; park nice-to-haves for Phase 3 |

---

## 8. Timeline

| Week | Activity |
|---|---|
| Week 1 | Internal alpha testing |
| Week 2 | Closed beta launch (50 users) |
| Week 3 | Feedback collection & iteration |
| Week 4 | Open beta (100 users) & final report |

---

*Next review: End of Week 2*

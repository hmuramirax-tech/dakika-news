# OneNews App — Beta Testing Playbook

**Date:** September 2026  
**Phase:** Sprint 5 (Beta Testing)  
**Duration:** 2 weeks  
**Goal:** Collect feedback, fix bugs, and iterate before launch

---

## 1. Beta Schedule

### Week 1: Closed Beta (50 users)
| Day | Activity |
|---|---|
| Day 1 | Onboard first 25 users |
| Day 2 | Onboard next 25 users |
| Day 3 | First feedback review |
| Day 4 | Bug fix sprint |
| Day 5 | Mid-week check-in |
| Day 6 | Bug fix sprint |
| Day 7 | Week 1 review |

### Week 2: Open Beta (100 users)
| Day | Activity |
|---|---|
| Day 8 | Onboard remaining 50 users |
| Day 9 | Feedback review |
| Day 10 | Bug fix sprint |
| Day 11 | Feature requests review |
| Day 12 | Performance optimization |
| Day 13 | Final bug fixes |
| Day 14 | Beta review + launch prep |

---

## 2. Daily Feedback Review

### Morning (9:00 AM)
1. Check overnight feedback submissions
2. Categorize: Bug / Feature / General
3. Assign severity: Critical / High / Medium / Low
4. Update bug tracking spreadsheet

### Afternoon (2:00 PM)
1. Check WhatsApp group for issues
2. Respond to critical bugs
3. Assign owners for new bugs

### Evening (5:00 PM)
1. Update daily feedback report
2. Share progress with team

---

## 3. Bug Fix Priority

### Critical (Fix within 4 hours)
- App crashes
- Payment failures
- Data loss
- Security issues

### High (Fix within 24 hours)
- Digest feed not loading
- Search not working
- Offline mode broken
- Push notifications not received

### Medium (Fix within 3 days)
- UI alignment issues
- Slow performance
- Incomplete data display

### Low (Fix in next sprint)
- Typos
- Minor cosmetic issues

---

## 4. Performance Monitoring

### Daily Checks
| Metric | Target | Action if Below |
|---|---|---|
| DAU | 50+ | Investigate retention |
| Session duration | 3+ min | Check engagement |
| Stories read | 5+ per session | Check content quality |
| Crash-free rate | 99%+ | Fix crashes immediately |
| Digest load time | < 3 seconds | Optimize performance |

### Tools
| Tool | Purpose |
|---|---|
| Firebase Crashlytics | Crash reporting |
| Supabase Analytics | User analytics |
| WhatsApp Group | Real-time feedback |

---

## 5. Iteration Process

### Weekly Sprint Cycle
| Day | Activity |
|---|---|
| Monday | Review feedback, plan week |
| Tuesday–Thursday | Fix bugs, implement features |
| Friday | Test fixes, prepare release |
| Weekend | Monitor, respond to issues |

### Release Process
1. Merge bug fixes to main branch
2. Run `flutter analyze` — must be clean
3. Run `flutter test` — all tests must pass
4. Build release APK
5. Distribute to beta users via WhatsApp
6. Monitor for 24 hours

---

## 6. Beta User Communication

### Welcome Message
```
Welcome to the OneNews beta! 🎉

Here's how to get started:
1. Open the app and sign up with your phone number
2. Explore the digest feed
3. Try search, categories, and offline mode
4. Send feedback via the in-app form

Your feedback shapes the app. Thank you for helping us build something great!
```

### Weekly Update Message
```
OneNews Beta — Week [X] Update

🎯 This week's focus: [Feature/bug fixes]
✅ Fixed: [List of fixes]
🚀 New: [List of new features]
📊 Your feedback: [Summary]

Keep the feedback coming!
```

---

## 7. Beta Exit Criteria

| Criterion | Threshold | Measurement |
|---|---|---|
| DAU | 50+ | Supabase analytics |
| Session duration | 3+ minutes | Supabase analytics |
| Day 7 retention | 25%+ | Supabase analytics |
| Crash-free rate | 99%+ | Firebase Crashlytics |
| Critical bugs | 0 | Bug tracker |
| High bugs | < 5 | Bug tracker |
| User satisfaction | 7+/10 | Weekly survey |

---

*Next review: End of Sprint 5*

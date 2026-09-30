# OneNews App — Beta Testing Infrastructure

**Date:** September 2026  
**Phase:** Sprint 4 (Beta Prep)  
**Goal:** Set up systems to collect, track, and act on beta feedback

---

## 1. Feedback Collection Channels

| Channel | Purpose | Tool |
|---|---|---|
| In-app feedback | Bug reports, feature requests | Supabase `beta_feedback` table |
| WhatsApp group | Real-time discussion | WhatsApp Business |
| Weekly survey | Structured feedback | Google Forms |
| Optional call | Deep-dive feedback | Phone/WhatsApp call |

---

## 2. In-App Feedback Form

### Fields
| Field | Type | Required |
|---|---|---|
| Type | Bug / Feature / General | Yes |
| Rating | 1–5 stars | Yes |
| Message | Text (max 500 chars) | Yes |
| Screen | Auto-detected | Auto |
| Screenshot | Image (optional) | No |

### Submission Flow
1. User opens feedback form
2. Selects type (Bug/Feature/General)
3. Rates experience (1–5 stars)
4. Writes message
5. Submits → Saved to Supabase `beta_feedback` table

---

## 3. Beta WhatsApp Group

### Group Rules
- Be respectful and constructive
- No spam or off-topic messages
- Report bugs with screenshots
- Suggest features clearly

### Group Schedule
| Day | Activity |
|---|---|
| Monday | Weekly feedback summary |
| Wednesday | Feature spotlight |
| Friday | Bug fix update |

---

## 4. Weekly Feedback Survey

### Questions
1. How often did you use OneNews this week? (Daily / Few times / Once / Not at all)
2. How would you rate the app overall? (1–5)
3. What did you like most?
4. What did you like least?
5. Any bugs encountered?
6. What features would you like to see?
7. Would you recommend OneNews to a friend? (Yes/No)

---

## 5. Feedback Response SLA

| Feedback Type | Response Time | Action |
|---|---|---|
| Critical bug | 2 hours | Acknowledge + fix plan |
| High bug | 24 hours | Acknowledge + assign owner |
| Feature request | 3 days | Acknowledge + add to backlog |
| General | 1 week | Thank + consider |

---

## 6. Beta Metrics Dashboard

### Key Metrics
| Metric | Target | Measurement |
|---|---|---|
| Daily Active Users (DAU) | 50+ | Supabase analytics |
| Session duration | 3+ minutes | Supabase analytics |
| Stories read per session | 5+ | Supabase analytics |
| Day 7 retention | 25%+ | Supabase analytics |
| Crash-free rate | 99%+ | Firebase Crashlytics |
| Feedback submissions | 10+ per week | Supabase `beta_feedback` |

### Weekly Report Template
```
OneNews Beta — Week [X] Report

📊 Metrics:
- DAU: [X]
- Session duration: [X] minutes
- Stories read: [X] per session
- Retention: [X]%
- Crash-free: [X]%

🐛 Bugs:
- New: [X]
- Fixed: [X]
- Open: [X]

💡 Feedback:
- Most requested feature: [X]
- Most common complaint: [X]

📋 Actions for next week:
1. [X]
2. [X]
3. [X]
```

---

## 7. Beta Exit Criteria

| Criterion | Threshold | Status |
|---|---|---|
| DAU | 50+ | Pending |
| Session duration | 3+ minutes | Pending |
| Day 7 retention | 25%+ | Pending |
| Crash-free rate | 99%+ | Pending |
| Critical bugs | 0 | Pending |
| High bugs | < 5 | Pending |
| User satisfaction | 7+/10 | Pending |

---

*Next review: End of Sprint 4*

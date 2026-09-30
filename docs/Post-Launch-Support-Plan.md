# OneNews App — Post-Launch Support Plan

**Date:** September 2026  
**Phase:** Sprint 6 (Launch Prep)  
**Goal:** Ensure smooth operations after public launch

---

## 1. On-Call Rotation

### Week 1 (Launch Week)
| Day | Primary | Backup |
|---|---|---|
| Monday | CTO | Mobile Dev |
| Tuesday | Mobile Dev | Backend |
| Wednesday | Backend | CTO |
| Thursday | CTO | Mobile Dev |
| Friday | Mobile Dev | Backend |
| Saturday | Backend | CTO |
| Sunday | CTO | Mobile Dev |

### Week 2–4
| Day | Primary | Backup |
|---|---|---|
| Monday–Friday | Mobile Dev | CTO |
| Saturday–Sunday | CTO | Backend |

---

## 2. Incident Response

### Severity Levels
| Level | Description | Response Time | Resolution Time |
|---|---|---|---|
| **P1 — Critical** | App down, data loss, security breach | 15 minutes | 4 hours |
| **P2 — High** | Major feature broken | 1 hour | 24 hours |
| **P3 — Medium** | Feature partially broken | 4 hours | 72 hours |
| **P4 — Low** | Minor UI issue | 1 week | Next release |

### Incident Response Process
1. **Detect** — Monitoring alert or user report
2. **Triage** — Assess severity and impact
3. **Assign** — Identify owner
4. **Fix** — Implement solution
5. **Verify** — Test fix in production
6. **Communicate** — Update users if needed
7. **Post-mortem** — Document lessons learned

---

## 3. Monitoring Setup

### Tools
| Tool | Purpose | URL |
|---|---|---|
| Firebase Crashlytics | Crash reporting | console.firebase.google.com |
| Supabase Dashboard | Database + Auth | supabase.com/dashboard |
| Cloudflare Analytics | CDN + Traffic | dash.cloudflare.com |
| Google Play Console | Downloads + Reviews | play.google.com/console |

### Alerts
| Metric | Threshold | Alert Channel |
|---|---|---|
| Crash rate | > 1% | Slack + Email |
| API error rate | > 5% | Slack |
| Server response time | > 2s | Slack |
| Database connections | > 80% | Email |

---

## 4. User Support Channels

| Channel | Purpose | Response Time |
|---|---|---|
| In-app feedback | Bug reports, feature requests | 24 hours |
| WhatsApp | Quick questions | 2 hours |
| Email | Detailed support | 24 hours |
| Social media | Public inquiries | 4 hours |

### Support Message Templates

**Bug Report Acknowledgment**
```
Thanks for reporting this issue! We're investigating and will update you within 24 hours.

Reference: #[ID]
```

**Feature Request Acknowledgment**
```
Thanks for the suggestion! We've added it to our product backlog for review.

Reference: #[ID]
```

**General Inquiry Response**
```
Thanks for reaching out! We'll get back to you within 24 hours.

For urgent issues, please contact us via WhatsApp at +250 7XX XXX XXX.
```

---

## 5. Release Process

### Hotfix Release (Critical Bugs)
1. Identify bug
2. Fix in feature branch
3. Run `flutter analyze` + `flutter test`
4. Build release APK
5. Upload to Play Store (staged rollout)
6. Monitor for 24 hours
7. Full rollout

### Regular Release (Weekly)
1. Merge approved features
2. Run full test suite
3. Build release APK
4. Upload to Play Store (staged rollout 10%)
5. Monitor for 48 hours
6. Increase rollout to 50%
7. Monitor for 24 hours
8. Full rollout to 100%

---

## 6. Weekly Operations Checklist

### Monday
- [ ] Review weekend metrics
- [ ] Check crash reports
- [ ] Review user feedback
- [ ] Plan week's priorities

### Friday
- [ ] Weekly metrics report
- [ ] Bug fix summary
- [ ] Plan next week
- [ ] Team retrospective

---

## 7. Escalation Matrix

| Issue | First Contact | Escalate To | Final Escalation |
|---|---|---|---|
| Bug report | Mobile Dev | CTO | CEO |
| Payment issue | Backend | CTO | CEO |
| Press inquiry | Marketing | CEO | — |
| Legal issue | CEO | Legal counsel | — |
| Security issue | CTO | CEO | External security firm |

---

*Next review: End of Week 1 post-launch*

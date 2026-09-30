# OneNews App — Bug Tracking Process

**Date:** September 2026  
**Phase:** Sprint 4 (Beta Prep)  
**Goal:** Track, prioritize, and resolve bugs before and during beta

---

## 1. Bug Severity Levels

| Level | Description | Response Time | Example |
|---|---|---|---|
| **Critical** | App crash, data loss, security breach | Immediate | App won't start, payment fails |
| **High** | Major feature broken, no workaround | 24 hours | Digest feed won't load |
| **Medium** | Feature partially broken, workaround exists | 3 days | Search returns incomplete results |
| **Low** | Minor UI issue, cosmetic | Next release | Typo, alignment issue |

---

## 2. Bug Lifecycle

```
New → Triaged → In Progress → Fixed → Verified → Closed
```

| Stage | Description |
|---|---|
| **New** | Bug reported, not yet reviewed |
| **Triaged** | Severity assigned, owner identified |
| **In Progress** | Fix being implemented |
| **Fixed** | Code fix merged, pending verification |
| **Verified** | Fix confirmed in test environment |
| **Closed** | Fix deployed to production |

---

## 3. Bug Report Template

```markdown
## Bug Report

**Title:** [Short description]
**Severity:** [Critical/High/Medium/Low]
**Reporter:** [Name]
**Date:** [Date]
**Device:** [Android version, device model]
**App Version:** [Version]

### Steps to Reproduce
1. 
2. 
3. 

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Screenshots
[Attach screenshots if applicable]

### Additional Context
[Any other relevant information]
```

---

## 4. Bug Tracking Spreadsheet

| ID | Title | Severity | Status | Owner | Date Reported | Date Fixed |
|---|---|---|---|---|---|---|
| BUG-001 | Example bug | High | New | CTO | 2026-09-30 | — |

---

## 5. Pre-Beta Bug Checklist

### Critical (Must be 0)
- [ ] App crashes on launch
- [ ] Payment processing fails
- [ ] User data loss
- [ ] Security vulnerability

### High (Must be < 5)
- [ ] Digest feed fails to load
- [ ] Search not working
- [ ] Offline mode broken
- [ ] Push notifications not received
- [ ] Language switching broken

### Medium (Must be < 10)
- [ ] UI alignment issues
- [ ] Slow performance
- [ ] Incomplete data display
- [ ] Error messages unclear

---

## 6. Daily Bug Triage

| Time | Activity |
|---|---|
| 9:00 AM | Review new bug reports |
| 10:00 AM | Assign severity and owner |
| 2:00 PM | Check progress on critical bugs |
| 5:00 PM | Update bug tracking spreadsheet |

---

## 7. Bug Resolution SLA

| Severity | Target Resolution | Escalation |
|---|---|---|
| Critical | 4 hours | CEO + CTO |
| High | 24 hours | CTO |
| Medium | 3 days | Mobile Dev |
| Low | Next sprint | Mobile Dev |

---

*Next review: End of Sprint 4*

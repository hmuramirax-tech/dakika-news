# OneNews App — Security Audit Resolution Plan

**Date:** September 2026  
**Phase:** Sprint 4 (Beta Prep)  
**Goal:** Resolve all critical security issues before beta launch

---

## 1. Critical Issues (Must Fix Before Beta)

| # | Issue | Status | Resolution | Owner |
|---|---|---|---|---|
| 1 | Admin dashboard MFA not implemented | **Open** | Implement MFA via Supabase Auth | CTO |
| 2 | Rate limiting on Edge Functions not configured | **Open** | Add rate limiting middleware | CTO |
| 3 | API keys hardcoded in config.dart | **Open** | Move to environment variables | CTO |
| 4 | RLS policies not tested | **Open** | Write RLS policy tests | CTO |
| 5 | Payment webhook signature verification missing | **Open** | Add HMAC signature verification | CTO |

---

## 2. High Priority (Fix During Beta)

| # | Issue | Status | Resolution | Owner |
|---|---|---|---|---|
| 6 | Analytics opt-in not implemented | **Open** | Add opt-in toggle in settings | Mobile Dev |
| 7 | Push notification opt-in not implemented | **Open** | Add opt-in toggle in settings | Mobile Dev |
| 8 | Error messages may leak internals | **Open** | Sanitize error responses | Backend |
| 9 | Data retention policies not implemented | **Open** | Add retention job to scheduled tasks | Backend |
| 10 | Incident response plan not documented | **Open** | Write incident response plan | CEO |

---

## 3. Medium Priority (Fix After Beta)

| # | Issue | Status | Resolution | Owner |
|---|---|---|---|---|
| 11 | Root/jailbreak detection not implemented | **Open** | Add flutter_jailbreak_detection | Mobile Dev |
| 12 | Certificate pinning not implemented | **Open** | Add certificate pinning | Mobile Dev |
| 13 | Screenshot prevention not implemented | **Open** | Add FLAG_SECURE for sensitive screens | Mobile Dev |
| 14 | Biometric auth for payments not implemented | **Open** | Add local_auth for payment confirmation | Mobile Dev |
| 15 | App integrity verification not implemented | **Open** | Add integrity check on startup | Mobile Dev |

---

## 4. Resolved Issues

| # | Issue | Resolution Date | Notes |
|---|---|---|---|
| — | None yet | — | — |

---

## 5. Security Checklist for Beta Launch

### Authentication
- [ ] Phone + OTP auth working
- [ ] OTP expires after 10 minutes
- [ ] Max OTP attempts limited
- [ ] JWT tokens expire after 24 hours
- [ ] Admin MFA implemented

### Data Protection
- [ ] TLS 1.2+ for all API calls
- [ ] Database encrypted at rest
- [ ] Phone numbers encrypted
- [ ] Payment data tokenized
- [ ] No sensitive data in logs

### API Security
- [ ] Rate limiting configured
- [ ] Input validation on all endpoints
- [ ] SQL injection prevention verified
- [ ] XSS prevention verified
- [ ] CORS properly configured

### Payment Security
- [ ] MoMo API uses OAuth 2.0
- [ ] Airtel Money API uses OAuth 2.0
- [ ] Payment callbacks verified
- [ ] No payment data stored on device
- [ ] Payment retry logic safe

---

## 6. Sign-Off

| Role | Name | Date | Signature |
|---|---|---|---|
| CTO | ___________ | ___________ | ___________ |
| CEO | ___________ | ___________ | ___________ |

---

*Next review: End of Sprint 4*

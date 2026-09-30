# OneNews App — Security Audit Checklist

**Version:** 1.0  
**Date:** September 2026  
**Scope:** Flutter app + Supabase backend + Edge Functions

---

## 1. Authentication & Authorization

| # | Check | Status | Notes |
|---|---|---|---|
| 1.1 | Phone + OTP auth implemented | [ ] | Supabase Auth |
| 1.2 | OTP expires after 10 minutes | [ ] | Verify in Supabase settings |
| 1.3 | Max OTP attempts limited (5) | [ ] | Verify in Supabase settings |
| 1.4 | JWT tokens expire after 24 hours | [ ] | Verify in Supabase settings |
| 1.5 | Admin dashboard requires MFA | [ ] | Not yet implemented |
| 1.6 | RBAC: Admin, Editor, Viewer roles | [ ] | Partially implemented |
| 1.7 | Users can only access their own data | [ ] | RLS policies |
| 1.8 | Admin routes protected | [ ] | Route guards |

---

## 2. Data Protection

| # | Check | Status | Notes |
|---|---|---|---|
| 2.1 | All API calls use TLS 1.2+ | [ ] | Supabase default |
| 2.2 | Database encrypted at rest (AES-256) | [ ] | Supabase default |
| 2.3 | User phone numbers encrypted | [ ] | Verify in schema |
| 2.4 | Payment data tokenized | [ ] | Via MoMo/Airtel APIs |
| 2.5 | No sensitive data in logs | [ ] | Review logging |
| 2.6 | No sensitive data in app bundle | [ ] | Review config.dart |
| 2.7 | API keys not hardcoded in app | [ ] | Use env vars |
| 2.8 | Supabase anon key is safe for client | [ ] | RLS protects data |

---

## 3. API Security

| # | Check | Status | Notes |
|---|---|---|---|
| 3.1 | Rate limiting on Edge Functions | [ ] | Implement in functions |
| 3.2 | Input validation on all endpoints | [ ] | SQL injection prevention |
| 3.3 | SQL injection prevention | [ ] | Supabase parameterized queries |
| 3.4 | XSS prevention | [ ] | Flutter default + sanitization |
| 3.5 | CORS properly configured | [ ] | Supabase default |
| 3.6 | Error messages don't leak internals | [ ] | Review error handling |
| 3.7 | Payment webhooks verified | [ ] | Signature verification |

---

## 4. Infrastructure

| # | Check | Status | Notes |
|---|---|---|---|
| 4.1 | Supabase project not in public mode | [ ] | Verify settings |
| 4.2 | Database backups enabled | [ ] | Supabase default |
| 4.3 | Backup retention: 30 days | [ ] | Verify in Supabase |
| 4.4 | Monitoring/alerting configured | [ ] | Not yet implemented |
| 4.5 | DDoS protection | [ ] | Cloudflare |
| 4.6 | Secrets stored in env vars | [ ] | Supabase secrets |
| 4.7 | Edge Functions timeout configured | [ ] | 60s default |

---

## 5. Mobile App Security

| # | Check | Status | Notes |
|---|---|---|---|
| 5.1 | Root/jailbreak detection | [ ] | Not implemented |
| 5.2 | Certificate pinning | [ ] | Not implemented |
| 5.3 | Obfuscate app code | [ ] | `--obfuscate --split-debug-info` |
| 5.4 | Disable screenshots in sensitive screens | [ ] | Not implemented |
| 5.5 | Secure local storage | [ ] | shared_preferences for non-sensitive |
| 5.6 | Biometric auth for payments | [ ] | Not implemented |
| 5.7 | App integrity verification | [ ] | Not implemented |

---

## 6. Privacy & Compliance

| # | Check | Status | Notes |
|---|---|---|---|
| 6.1 | Privacy policy published | [ ] | terms_screen.dart |
| 6.2 | Terms of service published | [ ] | terms_screen.dart |
| 6.3 | Analytics opt-in required | [ ] | Not implemented |
| 6.4 | Push notification opt-in required | [ ] | Not implemented |
| 6.5 | Data deletion process documented | [ ] | terms_screen.dart |
| 6.6 | Rwanda Data Protection Law compliance | [ ] | Legal review pending |
| 6.7 | GDPR considerations addressed | [ ] | Privacy policy |
| 6.8 | Data retention policy implemented | [ ] | Not implemented |

---

## 7. Payment Security

| # | Check | Status | Notes |
|---|---|---|---|
| 7.1 | MoMo API uses OAuth 2.0 | [ ] | Verify integration |
| 7.2 | Airtel Money API uses OAuth 2.0 | [ ] | Verify integration |
| 7.3 | Payment callbacks verified | [ ] | Signature check |
| 7.4 | No payment data stored on device | [ ] | Tokenized |
| 7.5 | Payment retry logic safe | [ ] | Max 3 retries |
| 7.6 | Failed payment handling | [ ] | Downgrade to free |
| 7.7 | PCI DSS considerations | [ ] | Via payment providers |

---

## 8. Incident Response

| # | Check | Status | Notes |
|---|---|---|---|
| 8.1 | Incident response plan documented | [ ] | Not created |
| 8.2 | On-call rotation defined | [ ] | Not created |
| 8.3 | Breach notification process | [ ] | Not created |
| 8.4 | Rollback procedure documented | [ ] | Not created |
| 8.5 | Communication templates ready | [ ] | Not created |

---

## 9. Action Items

| Priority | Item | Owner | Target |
|---|---|---|---|
| **Critical** | Enable MFA for admin dashboard | CTO | Week 10 |
| **Critical** | Implement rate limiting on Edge Functions | CTO | Week 10 |
| **Critical** | Verify RLS policies on all tables | CTO | Week 10 |
| **Critical** | Move API keys to environment variables | CTO | Week 10 |
| **High** | Implement analytics opt-in | Mobile Dev | Week 11 |
| **High** | Implement push notification opt-in | Mobile Dev | Week 11 |
| **High** | Add error message sanitization | Backend | Week 11 |
| **Medium** | Implement data retention policies | Backend | Week 12 |
| **Medium** | Create incident response plan | CEO | Week 12 |
| **Low** | Implement root/jailbreak detection | Mobile Dev | Phase 2 |
| **Low** | Implement certificate pinning | Mobile Dev | Phase 2 |

---

*Next review: End of Month 3*

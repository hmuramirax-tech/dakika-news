# OneNews App — Lessons Learned

**Date:** September 2026  
**Phase:** Foundation (Months 1–3)

---

## 1. Technical Lessons

### 1.1 Flutter & Dart
| Lesson | Impact | Recommendation |
|---|---|---|
| `const` constructors with field formal parameters don't compile | Medium | Use regular constructors for classes with `this.` parameters |
| `EmptyState` component API mismatch | Low | Always check component constructors before using |
| Supabase client requires initialization before use | High | Always check `SupabaseClientService.isInitialized` before accessing |
| `shared_preferences` plugin unavailable in tests | Medium | Mock Supabase in tests, don't call `Supabase.initialize()` |
| `google_mobile_ads` 5.x API changes | Low | Check `BannerAd` constructor — `listener` is set in constructor, not as setter |

### 1.2 Supabase
| Lesson | Impact | Recommendation |
|---|---|---|
| `.eq()` and `.in_()` methods vary by builder type | Medium | Use `.filter()` for complex queries |
| Edge Functions need explicit error handling | Medium | Always wrap in try-catch |
| RLS policies must be tested explicitly | High | Write tests for each RLS policy |

### 1.3 Testing
| Lesson | Impact | Recommendation |
|---|---|---|
| Widget tests need Supabase mocking | High | Create test helpers for Supabase initialization |
| `pumpAndSettle` can hang with timers | Medium | Use `pump(Duration)` for screens with timers |
| `const` widgets with non-const children fail | Low | Remove `const` when children are dynamic |

---

## 2. Process Lessons

### 2.1 Development
| Lesson | Impact | Recommendation |
|---|---|---|
| Building too many screens before testing | Medium | Test each screen immediately after building |
| Not using feature flags | Low | Add feature flags for incomplete features |
| Documentation lagging behind code | Medium | Write docs immediately after features |

### 2.2 Planning
| Lesson | Impact | Recommendation |
|---|---|---|
| Underestimated localization effort | Medium | Start localization early, it touches every screen |
| Overestimated backend complexity | Low | Supabase simplified backend significantly |
| Underestimated testing effort | Medium | Allocate 30% of time to testing |

---

## 3. Business Lessons

| Lesson | Impact | Recommendation |
|---|---|---|
| Content partnerships need early outreach | High | Start outreach in Month 1, not Month 3 |
| Payment integration takes longer than expected | High | Start MoMo integration in Month 1 |
| Legal review can block launch | Medium | Start legal review early, don't wait |
| Beta recruitment needs lead time | Medium | Start recruitment 4 weeks before beta |

---

## 4. What Went Well

| Aspect | Why |
|---|---|
| Design system | Clean tokens, consistent UI |
| Test coverage | 82 tests, all passing |
| Documentation | Comprehensive, up-to-date |
| Code quality | 0 analyzer issues |
| Architecture | Clean separation of concerns |

---

## 5. What Could Be Improved

| Aspect | Issue | Fix |
|---|---|---|
| Payment integration | Not tested with live API | Prioritize in Phase 2 |
| Content ingestion | Not tested with live RSS | Prioritize in Phase 2 |
| Performance testing | Not done on low-end devices | Add to Phase 2 plan |
| Security audit | Not completed | Complete before launch |

---

## 6. Recommendations for Future Phases

1. **Start integrations early** — Don't wait until the last month
2. **Test with real data** — Mock data only goes so far
3. **Write tests immediately** — Don't batch testing at the end
4. **Document as you go** — Don't leave documentation for later
5. **Get user feedback early** — Start beta testing as soon as possible

---

*Next review: End of Phase 2*

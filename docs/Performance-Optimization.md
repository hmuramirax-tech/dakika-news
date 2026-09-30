# OneNews App — Performance Optimization Guide

**Version:** 1.0  
**Date:** September 2026  
**Target:** Digest load ≤ 3s on 4G, AI summarization ≤ 5 min for 100 articles

---

## 1. Performance Targets

| Metric | Target | Current | Status |
|---|---|---|---|
| Digest load time (4G) | ≤ 3 seconds | TBD | Pending |
| App cold start | ≤ 2 seconds | TBD | Pending |
| AI summarization (100 articles) | ≤ 5 minutes | TBD | Pending |
| Data per digest load | ≤ 500KB | TBD | Pending |
| Frame rate | 60 fps | TBD | Pending |
| Crash-free rate | 99%+ | TBD | Pending |

---

## 2. Flutter App Optimization

### 2.1 Rendering Performance
- [ ] Use `const` constructors wherever possible
- [ ] Implement `ListView.builder` for long lists (already done)
- [ ] Use `RepaintBoundary` for complex animations
- [ ] Avoid `setState` in large widgets — use Riverpod selectors
- [ ] Use `Image` with `cacheWidth`/`cacheHeight` for network images
- [ ] Implement skeleton loading (already done)

### 2.2 State Management
- [ ] Use Riverpod `select` to minimize rebuilds
- [ ] Dispose controllers and streams properly
- [ ] Use `ConsumerWidget` instead of `Consumer` where possible
- [ ] Avoid unnecessary `ref.watch` in build methods

### 2.3 Network Optimization
- [ ] Implement request deduplication
- [ ] Use `cached_network_image` for article images (already in pubspec)
- [ ] Implement request caching with TTL
- [ ] Compress API responses (gzip)
- [ ] Use pagination for article lists (already implemented)

### 2.4 Bundle Size
- [ ] Run `flutter build apk --split-per-abi`
- [ ] Use `--obfuscate --split-debug-info` for release builds
- [ ] Remove unused dependencies
- [ ] Compress images in `assets/`
- [ ] Use `flutter analyze` to find unused code

---

## 3. Backend Optimization

### 3.1 Database (Supabase/PostgreSQL)
- [ ] Add indexes on frequently queried columns (already done)
- [ ] Use `select()` to fetch only needed columns
- [ ] Implement full-text search (already done)
- [ ] Use database views for complex queries
- [ ] Implement connection pooling

### 3.2 Edge Functions
- [ ] Minimize cold start time
- [ ] Use `Promise.all` for parallel operations
- [ ] Implement request validation at the edge
- [ ] Add appropriate timeouts (60s)
- [ ] Log performance metrics

### 3.3 AI Summarization Pipeline
- [ ] Batch process articles (10–20 at a time)
- [ ] Implement queue-based processing
- [ ] Cache summarization results
- [ ] Use confidence scoring to prioritize review
- [ ] Implement fallback for API failures

---

## 4. Caching Strategy

| Layer | Tool | TTL | Use Case |
|---|---|---|---|
| App memory | Riverpod | Session | User preferences, auth state |
| Local storage | shared_preferences | Persistent | Language, settings |
| Offline cache | SQLite/Hive | 72 hours | Digests, articles |
| CDN | Cloudflare | 1 hour | Static assets, images |
| Supabase | Built-in | Real-time | Database queries |

---

## 5. Monitoring

### 5.1 Tools
| Tool | Purpose |
|---|---|
| Firebase Crashlytics | Crash reporting |
| Firebase Performance | App performance |
| PostHog | User analytics |
| Supabase Logs | Backend logs |
| Cloudflare Analytics | CDN performance |

### 5.2 Key Metrics to Track
- App launch time
- Screen load times
- API response times
- Error rates
- AI summarization success rate
- Payment success rate

---

## 6. Optimization Checklist

### Pre-Launch
- [ ] Run `flutter analyze` — 0 issues
- [ ] Run `flutter test` — all tests pass
- [ ] Test on low-end Android device (2GB RAM)
- [ ] Test on 2G/3G network
- [ ] Test offline mode
- [ ] Verify all images load correctly
- [ ] Check memory usage (no leaks)
- [ ] Verify 60 fps scrolling

### Post-Launch
- [ ] Monitor crash-free rate (target: 99%+)
- [ ] Monitor API response times (target: < 500ms)
- [ ] Monitor AI summarization queue (target: < 5 min for 100 articles)
- [ ] Monitor payment success rate (target: 95%+)
- [ ] Weekly performance review

---

## 7. Performance Budget

| Resource | Budget | Current |
|---|---|---|
| App bundle size | ≤ 20 MB | TBD |
| Digest load | ≤ 500 KB | TBD |
| API response | ≤ 100 KB | TBD |
| Image (article) | ≤ 200 KB | TBD |
| Cold start | ≤ 2 seconds | TBD |
| Warm start | ≤ 1 second | TBD |

---

*Next review: End of Month 3*

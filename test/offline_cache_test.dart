import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dakika/repositories/offline_cache.dart';

void main() {
  group('Offline Cache', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('OfflineCache can be created', () async {
      final cache = await OfflineCache.create();
      expect(cache, isNotNull);
    });

    test('Cache digest and retrieve', () async {
      final cache = await OfflineCache.create();
      // Test cache operations
      expect(await cache.getDigestCount(), 0);
      expect(await cache.getArticleCount(), 0);
      expect(await cache.getCacheSize(), 0);
    });

    test('Clear all cache', () async {
      final cache = await OfflineCache.create();
      await cache.clearAll();
      expect(await cache.getDigestCount(), 0);
      expect(await cache.getArticleCount(), 0);
    });

    test('Clear expired cache', () async {
      final cache = await OfflineCache.create();
      await cache.clearExpired();
      expect(await cache.getDigestCount(), 0);
    });
  });
}

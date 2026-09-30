import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dakika/repositories/offline_cache.dart';
import 'package:dakika/models/models.dart';

/// Provides connectivity status.
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Provides offline cache instance.
final offlineCacheProvider = Provider<OfflineCache>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

/// Provides cached articles for offline reading.
final cachedArticlesProvider = FutureProvider<List<Article>>((ref) async {
  final cache = ref.watch(offlineCacheProvider);
  final digests = await cache.getAllCachedDigests();

  final articles = <Article>[];
  for (final d in digests) {
    articles.addAll(d.articles);
  }

  return articles;
});

/// Provides offline status.
final isOfflineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) => result == ConnectivityResult.none,
    loading: () => false,
    error: (_, __) => true,
  );
});

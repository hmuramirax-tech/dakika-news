import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dakika/models/models.dart';

/// Typedef for cached digest with articles.
typedef CachedDigest = ({Digest digest, List<Article> articles});

/// Offline cache for digests and articles.
/// Stores data locally for offline reading.
/// Max 3 digests, 30 stories (per BR-017).
/// Cache expires after 72 hours (per BR-018).
class OfflineCache {
  static const _prefix = 'cache_';
  static const _digestPrefix = '${_prefix}digest_';
  static const _articlePrefix = '${_prefix}article_';
  static const _metadataKey = '${_prefix}metadata';
  static const _maxDigests = 3;
  static const _maxArticles = 30;
  static const _cacheExpiryHours = 72;

  final SharedPreferences _prefs;

  OfflineCache(this._prefs);

  static Future<OfflineCache> create() async {
    final prefs = await SharedPreferences.getInstance();
    return OfflineCache(prefs);
  }

  // ============================================
  // DIGEST CACHING
  // ============================================

  /// Cache a digest with its articles.
  /// Enforces max 3 digests limit.
  Future<void> cacheDigest(Digest digest, List<Article> articles) async {
    // Enforce max articles limit
    final limitedArticles = articles.take(_maxArticles).toList();

    final key = '$_digestPrefix${digest.date.toIso8601String()}_${digest.period}';
    final data = {
      'digest': {
        'id': digest.id,
        'date': digest.date.toIso8601String(),
        'period': digest.period,
        'title': digest.title,
        'story_ids': digest.storyIds,
        'created_at': digest.createdAt.toIso8601String(),
      },
      'articles': limitedArticles.map((a) => _articleToJson(a)).toList(),
      'cached_at': DateTime.now().toIso8601String(),
    };

    await _prefs.setString(key, jsonEncode(data));

    // Enforce max digests limit
    await _enforceDigestLimit();

    // Update metadata
    final metadata = await getMetadata();
    metadata['last_digest_date'] = digest.date.toIso8601String();
    metadata['last_digest_period'] = digest.period;
    metadata['digest_count'] = await getDigestCount();
    await _saveMetadata(metadata);
  }

  /// Get cached digest.
  Future<CachedDigest?> getCachedDigest(
    DateTime date,
    String period,
  ) async {
    final key = '$_digestPrefix${date.toIso8601String()}_$period';
    final data = _prefs.getString(key);

    if (data == null) return null;

    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final digestJson = json['digest'] as Map<String, dynamic>;
      final articlesJson = json['articles'] as List<dynamic>;

      final digest = Digest(
        id: digestJson['id'],
        date: DateTime.parse(digestJson['date']),
        period: digestJson['period'],
        title: digestJson['title'],
        storyIds: List<String>.from(digestJson['story_ids']),
        createdAt: DateTime.parse(digestJson['created_at']),
      );

      final articles = articlesJson
          .map((a) => _articleFromJson(a as Map<String, dynamic>))
          .toList();

      return (digest: digest, articles: articles);
    } catch (e) {
      debugPrint('Error reading cached digest: $e');
      return null;
    }
  }

  /// Get all cached digests.
  Future<List<CachedDigest>> getAllCachedDigests() async {
    final results = <({Digest digest, List<Article> articles})>[];

    for (final key in _prefs.getKeys()) {
      if (key.startsWith(_digestPrefix)) {
        final data = _prefs.getString(key);
        if (data == null) continue;

        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          final digestJson = json['digest'] as Map<String, dynamic>;
          final articlesJson = json['articles'] as List<dynamic>;

          final digest = Digest(
            id: digestJson['id'],
            date: DateTime.parse(digestJson['date']),
            period: digestJson['period'],
            title: digestJson['title'],
            storyIds: List<String>.from(digestJson['story_ids']),
            createdAt: DateTime.parse(digestJson['created_at']),
          );

          final articles = articlesJson
              .map((a) => _articleFromJson(a as Map<String, dynamic>))
              .toList();

          results.add((digest: digest, articles: articles));
        } catch (e) {
          debugPrint('Error reading cached digest: $e');
        }
      }
    }

    return results;
  }

  /// Get the most recent cached digest.
  Future<CachedDigest?> getMostRecentDigest() async {
    final digests = await getAllCachedDigests();
    if (digests.isEmpty) return null;

    digests.sort((a, b) => b.digest.date.compareTo(a.digest.date));
    return digests.first;
  }

  /// Check if a digest is cached and not expired.
  Future<bool> isDigestAvailable(DateTime date, String period) async {
    final cached = await getCachedDigest(date, period);
    if (cached == null) return false;

    // Check expiry
    final key = '$_digestPrefix${date.toIso8601String()}_$period';
    final data = _prefs.getString(key);
    if (data == null) return false;

    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(json['cached_at'] as String);
      return DateTime.now().difference(cachedAt).inHours < _cacheExpiryHours;
    } catch (e) {
      return false;
    }
  }

  // ============================================
  // ARTICLE CACHING
  // ============================================

  /// Cache a single article.
  Future<void> cacheArticle(Article article) async {
    final key = '$_articlePrefix${article.id}';
    await _prefs.setString(key, jsonEncode(_articleToJson(article)));
  }

  /// Get cached article.
  Future<Article?> getCachedArticle(String id) async {
    final key = '$_articlePrefix$id';
    final data = _prefs.getString(key);

    if (data == null) return null;

    try {
      return _articleFromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error reading cached article: $e');
      return null;
    }
  }

  // ============================================
  // METADATA
  // ============================================

  Future<Map<String, dynamic>> getMetadata() async {
    final data = _prefs.getString(_metadataKey);
    if (data == null) return {};
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> _saveMetadata(Map<String, dynamic> metadata) async {
    await _prefs.setString(_metadataKey, jsonEncode(metadata));
  }

  // ============================================
  // CACHE MANAGEMENT
  // ============================================

  /// Clear all cached data.
  Future<void> clearAll() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  /// Clear cached digests older than 72 hours.
  Future<void> clearExpired() async {
    final now = DateTime.now();
    final keys = _prefs.getKeys().where((k) => k.startsWith(_digestPrefix));

    for (final key in keys) {
      final data = _prefs.getString(key);
      if (data == null) continue;

      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        final cachedAt = DateTime.parse(json['cached_at'] as String);

        if (now.difference(cachedAt).inHours > _cacheExpiryHours) {
          await _prefs.remove(key);
        }
      } catch (e) {
        await _prefs.remove(key);
      }
    }
  }

  /// Get cache size in bytes.
  Future<int> getCacheSize() async {
    int size = 0;
    for (final key in _prefs.getKeys()) {
      if (key.startsWith(_prefix)) {
        final value = _prefs.getString(key);
        if (value != null) size += value.length;
      }
    }
    return size;
  }

  /// Get the number of cached digests.
  Future<int> getDigestCount() async {
    return _prefs.getKeys().where((k) => k.startsWith(_digestPrefix)).length;
  }

  /// Get the number of cached articles.
  Future<int> getArticleCount() async {
    return _prefs.getKeys().where((k) => k.startsWith(_articlePrefix)).length;
  }

  // ============================================
  // PRIVATE HELPERS
  // ============================================

  /// Enforce max 3 digests limit — remove oldest if exceeded.
  Future<void> _enforceDigestLimit() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(_digestPrefix)).toList();
    if (keys.length <= _maxDigests) return;

    // Sort by cached date and remove oldest
    final keyDates = <MapEntry<String, DateTime>>[];
    for (final key in keys) {
      final data = _prefs.getString(key);
      if (data == null) continue;
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        final cachedAt = DateTime.parse(json['cached_at'] as String);
        keyDates.add(MapEntry(key, cachedAt));
      } catch (e) {
        // Remove corrupted entries
        await _prefs.remove(key);
      }
    }

    keyDates.sort((a, b) => a.value.compareTo(b.value));

    // Remove oldest digests until we're at the limit
    while (keyDates.length > _maxDigests) {
      final oldest = keyDates.removeAt(0);
      await _prefs.remove(oldest.key);
    }
  }

  // ============================================
  // SERIALIZATION HELPERS
  // ============================================

  Map<String, dynamic> _articleToJson(Article article) => {
        'id': article.id,
        'source_id': article.sourceId,
        'title': article.title,
        'summary': article.summary,
        'content': article.content,
        'url': article.url,
        'image_url': article.imageUrl,
        'category_id': article.categoryId,
        'language': article.language,
        'confidence_score': article.confidenceScore,
        'status': article.status,
        'published_at': article.publishedAt?.toIso8601String(),
        'ingested_at': article.ingestedAt.toIso8601String(),
        'source_name': article.sourceName,
        'category_name': article.categoryName,
      };

  Article _articleFromJson(Map<String, dynamic> json) => Article(
        id: json['id'],
        sourceId: json['source_id'],
        title: json['title'],
        summary: json['summary'],
        content: json['content'],
        url: json['url'],
        imageUrl: json['image_url'],
        categoryId: json['category_id'],
        language: json['language'],
        confidenceScore: json['confidence_score'] != null
            ? (json['confidence_score'] as num).toDouble()
            : null,
        status: json['status'],
        publishedAt: json['published_at'] != null
            ? DateTime.parse(json['published_at'])
            : null,
        ingestedAt: DateTime.parse(json['ingested_at']),
        sourceName: json['source_name'],
        categoryName: json['category_name'],
      );
}

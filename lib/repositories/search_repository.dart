import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/models/models.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Repository for search operations.
/// Provides keyword search, category filtering, and recent searches.
class SearchRepository {
  SupabaseClient? _client;

  SupabaseClient get _db {
    _client ??= SupabaseClientService.client;
    return _client!;
  }

  /// Search articles by keyword with optional filters.
  Future<List<Article>> search({
    required String query,
    String? category,
    String? language,
    int limit = 20,
    int offset = 0,
  }) async {
    // Use the database full-text search function
    final response = await _db.rpc('search_articles', params: {
      'search_query': query,
      'max_results': limit,
    });

    var articles = (response as List)
        .map((json) => Article.fromJson({
              ...json,
              'source_name': json['source_name'],
              'category_name': json['category_name'],
            }))
        .toList();

    // Apply additional filters
    if (category != null && category != 'All') {
      articles = articles.where((a) => a.categoryName == category).toList();
    }

    if (language != null) {
      articles = articles.where((a) => a.language == language).toList();
    }

    return articles;
  }

  /// Get trending searches (most common keywords).
  Future<List<String>> getTrendingSearches({int limit = 8}) async {
    // In production, this would query analytics_events
    // For now, return static trending topics
    return [
      '#RwandaGDP',
      '#5GExpansion',
      '#KigaliTech',
      '#AFCON2027',
      '#CoffeeExports',
      '#DigitalHealth',
      '#EACTrade',
      '#ClimateSummit',
    ];
  }

  /// Get recent searches for the current user.
  Future<List<String>> getRecentSearches({int limit = 5}) async {
    final userId = _db.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _db
          .from('analytics_events')
          .select('event_data')
          .eq('user_id', userId)
          .eq('event_name', 'search')
          .order('created_at', ascending: false)
          .limit(limit);

      return response
          .map((e) => (e['event_data'] as Map<String, dynamic>)['query'] as String?)
          .where((q) => q != null)
          .cast<String>()
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save a search query to analytics.
  Future<void> saveSearch(String query) async {
    final userId = _db.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _db.from('analytics_events').insert({
        'user_id': userId,
        'event_name': 'search',
        'event_data': {'query': query},
      });
    } catch (e) {
      // Silently fail — analytics should not break search
    }
  }

  /// Get search suggestions based on partial input.
  Future<List<String>> getSuggestions(String partial, {int limit = 5}) async {
    if (partial.length < 2) return [];

    // In production, this would query a suggestions table
    // For now, return filtered trending topics
    final trending = await getTrendingSearches(limit: 20);
    return trending
        .where((t) => t.toLowerCase().contains(partial.toLowerCase()))
        .take(limit)
        .toList();
  }
}

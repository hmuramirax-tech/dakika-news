import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/models/models.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Repository for article-related database operations.
class ArticleRepository {
  final SupabaseClient _client = SupabaseClientService.client;

  /// Get published articles, optionally filtered by category.
  Future<List<Article>> getArticles({
    String? category,
    int limit = 20,
    int offset = 0,
  }) async {
    final query = _client
        .from('articles')
        .select('*, sources(name), categories(name)')
        .eq('status', 'published')
        .order('published_at', ascending: false)
        .range(offset, offset + limit - 1);

    final response = await query;
    return (response as List)
        .map((json) => Article.fromJson({
              ...json,
              'source_name': json['sources']?['name'],
              'category_name': json['categories']?['name'],
            }))
        .toList();
  }

  /// Get a single article by ID.
  Future<Article?> getArticleById(String id) async {
    final response = await _client
        .from('articles')
        .select('*, sources(name), categories(name)')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    return Article.fromJson({
      ...response,
      'source_name': response['sources']?['name'],
      'category_name': response['categories']?['name'],
    });
  }

  /// Search articles by keyword.
  Future<List<Article>> searchArticles(String query, {int limit = 20}) async {
    final response = await _client
        .rpc('search_articles', params: {
          'search_query': query,
          'max_results': limit,
        });

    return (response as List)
        .map((json) => Article.fromJson({
              ...json,
              'source_name': json['source_name'],
              'category_name': json['category_name'],
            }))
        .toList();
  }

  /// Get articles for a specific digest.
  Future<List<Article>> getDigestArticles(String digestId) async {
    final digest = await _client
        .from('digests')
        .select('story_ids')
        .eq('id', digestId)
        .maybeSingle();

    if (digest == null || (digest['story_ids'] as List).isEmpty) {
      return [];
    }

    final storyIds = List<String>.from(digest['story_ids']);
    final response = await _client
        .from('articles')
        .select('*, sources(name), categories(name)')
        .filter('id', 'in', storyIds)
        .eq('status', 'published');

    return (response as List)
        .map((json) => Article.fromJson({
              ...json,
              'source_name': json['sources']?['name'],
              'category_name': json['categories']?['name'],
            }))
        .toList();
  }

  /// Save a story for the current user.
  Future<void> saveStory(String articleId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client.from('saved_stories').insert({
      'user_id': userId,
      'article_id': articleId,
    });
  }

  /// Remove a saved story.
  Future<void> removeSavedStory(String articleId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('saved_stories')
        .delete()
        .eq('user_id', userId)
        .eq('article_id', articleId);
  }

  /// Get saved stories for the current user.
  Future<List<Article>> getSavedStories() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('saved_stories')
        .select('articles(*, sources(name), categories(name))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Article.fromJson({
              ...json['articles'],
              'source_name': json['articles']['sources']?['name'],
              'category_name': json['articles']['categories']?['name'],
            }))
        .toList();
  }

  /// Track reading history.
  Future<void> trackReading(String articleId, {int? dwellTimeSeconds, bool completed = false}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from('reading_history').insert({
      'user_id': userId,
      'article_id': articleId,
      'dwell_time_seconds': dwellTimeSeconds,
      'completed': completed,
    });
  }
}

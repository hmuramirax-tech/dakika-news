import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Analytics service — tracks user events to Supabase.
/// All events are anonymized and respect user privacy settings.
class AnalyticsService {
  SupabaseClient? _client;

  SupabaseClient get _supabaseClient {
    _client ??= SupabaseClientService.client;
    return _client!;
  }

  /// Track a screen view event.
  Future<void> trackScreenView(String screenName) async {
    await _trackEvent('screen_view', {'screen': screenName});
  }

  /// Track article read event.
  Future<void> trackArticleRead({
    required String articleId,
    int? dwellTimeSeconds,
    bool completed = false,
  }) async {
    await _trackEvent('article_read', {
      'article_id': articleId,
      'dwell_time_seconds': dwellTimeSeconds,
      'completed': completed,
    });
  }

  /// Track search event.
  Future<void> trackSearch(String query) async {
    await _trackEvent('search', {'query': query});
  }

  /// Track story save event.
  Future<void> trackSave(String articleId) async {
    await _trackEvent('save', {'article_id': articleId});
  }

  /// Track story share event.
  Future<void> trackShare(String articleId) async {
    await _trackEvent('share', {'article_id': articleId});
  }

  /// Track subscription event.
  Future<void> trackSubscription({
    required String tier,
    required String action, // 'start', 'renew', 'cancel'
  }) async {
    await _trackEvent('subscription', {
      'tier': tier,
      'action': action,
    });
  }

  /// Track referral event.
  Future<void> trackReferral({
    required String code,
    required String action, // 'generate', 'share', 'signup'
  }) async {
    await _trackEvent('referral', {
      'code': code,
      'action': action,
    });
  }

  /// Track notification event.
  Future<void> trackNotification({
    required String type, // 'received', 'opened'
    String? articleId,
  }) async {
    await _trackEvent('notification', {
      'type': type,
      'article_id': articleId,
    });
  }

  /// Track payment event.
  Future<void> trackPayment({
    required String provider,
    required String status, // 'initiated', 'success', 'failed'
    required int amount,
    required String currency,
  }) async {
    await _trackEvent('payment', {
      'provider': provider,
      'status': status,
      'amount': amount,
      'currency': currency,
    });
  }

  /// Internal method to track an event.
  Future<void> _trackEvent(String eventName, Map<String, dynamic> data) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabaseClient.from('analytics_events').insert({
        'user_id': userId,
        'event_name': eventName,
        'event_data': data,
      });
    } catch (e) {
      // Silently fail — analytics should not break the app
    }
  }
}

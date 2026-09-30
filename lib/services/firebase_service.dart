import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dakika/repositories/supabase_client.dart';

/// Firebase Cloud Messaging service for push notifications.
/// Handles both remote (FCM) and local notifications.
class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _initialized = false;

  /// Initialize FCM and local notifications.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Request permission (iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(initSettings);

    // Create Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'breaking_news',
      'Breaking News',
      description: 'Urgent news alerts',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Get FCM token and send to Supabase
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveTokenToSupabase(token);
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background/terminated message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
  }

  /// Save FCM token to Supabase for targeted notifications.
  Future<void> _saveTokenToSupabase(String token) async {
    try {
      final userId = SupabaseClientService.client.auth.currentUser?.id;
      if (userId == null) return;

      await SupabaseClientService.client.from('fcm_tokens').upsert({
        'user_id': userId,
        'token': token,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  /// Handle foreground messages — show local notification.
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _showLocalNotification(
      id: message.messageId?.hashCode ?? 0,
      title: notification.title ?? 'DAKIKA',
      body: notification.body ?? '',
      payload: message.data['article_id'],
    );
  }

  /// Handle message tap — navigate to article.
  void _handleMessageTap(RemoteMessage message) {
    final articleId = message.data['article_id'];
    if (articleId != null) {
      // TODO: Navigate to article via router
      debugPrint('Navigate to article: $articleId');
    }
  }

  /// Show a local notification.
  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'breaking_news',
      'Breaking News',
      channelDescription: 'Urgent news alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Show a local notification for testing.
  Future<void> showTestNotification() async {
    await _showLocalNotification(
      id: 9999,
      title: 'DAKIKA Test',
      body: 'Push notifications are working!',
      payload: null,
    );
  }

  /// Subscribe to breaking news topic.
  Future<void> subscribeToBreakingNews() async {
    await _messaging.subscribeToTopic('breaking_news');
  }

  /// Unsubscribe from breaking news topic.
  Future<void> unsubscribeFromBreakingNews() async {
    await _messaging.unsubscribeToTopic('breaking_news');
  }

  /// Subscribe to daily digest topic.
  Future<void> subscribeToDailyDigest() async {
    await _messaging.subscribeToTopic('daily_digest');
  }

  /// Unsubscribe from daily digest topic.
  Future<void> unsubscribeFromDailyDigest() async {
    await _messaging.unsubscribeToTopic('daily_digest');
  }

  /// Get the current FCM token.
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Delete the current FCM token.
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
  }
}

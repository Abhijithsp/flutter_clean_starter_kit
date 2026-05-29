import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._(); // Private constructor

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  /// Initialize notification settings and request permission
  static Future<void> init() async {
    if (_isInitialized) return;

    // Android Settings (uses the app launcher icon)
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/Darwin Settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Request permissions dynamically for Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _isInitialized = true;
  }

  /// Handle tap on notification
  static void _onNotificationResponse(NotificationResponse response) {
    // Can handle routing or deep links based on payload if needed.
  }

  /// Display an immediate notification
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'shop_channel_id',
      'E-Commerce Notifications',
      channelDescription: 'Notifications for order updates, shipping updates, and deal alerts.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Generate a unique ID for each notification based on timestamp
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  /// Helper to trigger a notification after a given delay
  /// (Useful for simulating background API events / shipping updates)
  static void showDelayedNotification({
    required String title,
    required String body,
    required Duration delay,
    String? payload,
  }) {
    Timer(delay, () {
      showNotification(
        title: title,
        body: body,
        payload: payload,
      );
    });
  }
}

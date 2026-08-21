import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('[FCM] Background message: ${message.messageId}');
    print('[FCM] Data: ${message.data}');
  }
}

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (kDebugMode) {
      print('[FCM] Permission: ${settings.authorizationStatus}');
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('[FCM] Foreground message:');
        print('[FCM] Title: ${message.notification?.title}');
        print('[FCM] Body: ${message.notification?.body}');
        print('[FCM] Data: ${message.data}');
      }
    });

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    _messaging.onTokenRefresh.listen((newToken) async {
      if (ApiService.token != null && ApiService.token!.isNotEmpty) {
        try {
          await ApiService.post('/donor/push-token', {'pushToken': newToken});
          if (kDebugMode) print('[FCM] Token refreshed and registered');
        } catch (e) {
          if (kDebugMode) print('[FCM] Token refresh failed: $e');
        }
      }
    });
  }

  static Future<void> registerDeviceToken() async {
    try {
      if (ApiService.token == null || ApiService.token!.isEmpty) {
        if (kDebugMode) print('[FCM] No auth token, skipping registration');
        return;
      }

      String? token = await _messaging.getToken();
      if (token != null) {
        if (kDebugMode) print('[FCM] Token: $token');
        await ApiService.post('/donor/push-token', {'pushToken': token});
        if (kDebugMode) print('[FCM] Token registered with backend');
      }
    } catch (e) {
      if (kDebugMode) print('[FCM] Registration failed: $e');
    }
  }

  static void _handleMessageTap(RemoteMessage message) {
    if (kDebugMode) {
      print('[FCM] Notification tapped: ${message.data}');
    }
  }
}

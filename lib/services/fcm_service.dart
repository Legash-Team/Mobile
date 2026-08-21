import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('FCM background init error: $e');
  }
}

class FCMService {
  static FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'emergency_blood_requests',
    'Emergency Blood Requests',
    description: 'High priority alerts for urgent blood donation needs',
    importance: Importance.max,
    playSound: true,
  );

  static Future<void> initialize() async {
    try {
      // 1. Request Permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        debugPrint('User declined notification permission');
        return;
      }

      // 2. Register Background Handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 3. Local Notifications Setup
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Fixed: passed as named parameter `settings:`
      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            try {
              final data = jsonDecode(response.payload!) as Map<String, dynamic>;
              _handleNotificationClick(data);
            } catch (e) {
              debugPrint('Payload parse error: $e');
            }
          }
        },
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      // 4. Foreground listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        final notification = message.notification;

        if (notification != null) {
          // Fixed: passed as named parameters (id:, title:, body:, notificationDetails:, payload:)
          await _localNotifications.show(
            id: notification.hashCode,
            title: notification.title ?? 'Emergency Blood Alert',
            body: notification.body ?? 'A hospital needs blood in your area.',
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                icon: '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      });

      // 5. Background tap listener
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationClick(message.data);
      });

      // 6. Terminated launch check
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage.data);
      }

      // 7. Token setup
      final token = await _messaging.getToken();
      if (token != null) {
        await _sendTokenToServer(token);
      }

      _messaging.onTokenRefresh.listen((newToken) async {
        await _sendTokenToServer(newToken);
      });
    } catch (e) {
      debugPrint('FCM init error: $e');
    }
  }

  static Future<void> _sendTokenToServer(String token) async {
    try {
      if (ApiService.token != null && ApiService.token!.isNotEmpty) {
        await ApiService.post('/v1/donor/fcm-token', {'fcm_token': token});
      }
    } catch (e) {
      debugPrint('Failed to sync token: $e');
    }
  }

  static void _handleNotificationClick(Map<String, dynamic> data) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/dashboard',
        (route) => false,
      );
    }
  }
}
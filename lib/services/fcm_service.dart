import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app_navigator.dart';
import '../screens/donor_home_shell.dart';
import 'api_service.dart';

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _bloodRequestsChannel = AndroidNotificationChannel(
  'legash_blood_requests',
  'Blood Requests',
  description: 'Alerts for nearby blood donation requests',
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
);

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
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      
      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          if (kDebugMode) {
            print('[FCM] Local notification tapped: ${details.payload}');
          }
          _navigateToRequests(details.payload);
        },
      );

      // Create Android Notification Channel for High Importance Alerts
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(_bloodRequestsChannel);
        await androidPlugin.requestNotificationsPermission();
      }

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (kDebugMode) print('[FCM] Permission: ${settings.authorizationStatus}');

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('[FCM] Foreground message received:');
          print('[FCM] Title: ${message.notification?.title}');
          print('[FCM] Body: ${message.notification?.body}');
          print('[FCM] Data: ${message.data}');
        }
        _showForegroundNotification(message);
      });

      _messaging.onTokenRefresh.listen((newToken) async {
        if (ApiService.token != null && ApiService.token!.isNotEmpty) {
          try {
            await ApiService.post('/api/donor/push-token', {'pushToken': newToken});
            if (kDebugMode) print('[FCM] Token refreshed and registered: $newToken');
          } catch (e) {
            if (kDebugMode) print('[FCM] Token refresh failed: $e');
          }
        }
      });
    } catch (e) {
      if (kDebugMode) print('[FCM] Initialization error (non-fatal): $e');
    }
  }

  static Future<void> initializeNavigation() async {
    try {
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }
    } catch (e) {
      if (kDebugMode) print('[FCM] Navigation init skipped: $e');
    }
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final title = notification?.title ?? 
        (data['hospitalName'] != null 
            ? 'Urgent: ${data['bloodType'] ?? 'Blood'} Needed' 
            : 'Legash Blood Alert');
            
    final body = notification?.body ?? 
        (data['hospitalName'] != null 
            ? '${data['hospitalName']} requires ${data['quantityNeeded'] ?? 'units of'} ${data['bloodType'] ?? ''} blood.'
            : 'A new emergency blood request has been posted near you.');

    const androidDetails = AndroidNotificationDetails(
      'legash_blood_requests',
      'Blood Requests',
      channelDescription: 'Alerts for nearby blood donation requests',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
      ticker: 'Blood request',
    );
    const details = NotificationDetails(android: androidDetails);

    final requestId = (data['requestId'] ?? data['id'] ?? message.messageId)?.toString();

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: details,
      payload: requestId,
    );
  }

  static Future<void> registerDeviceToken() async {
    try {
      if (ApiService.token == null || ApiService.token!.isEmpty) {
        if (kDebugMode) print('[FCM] No auth token, skipping registration');
        return;
      }

      final token = await _messaging.getToken();
      if (token != null) {
        if (kDebugMode) print('[FCM] Token: $token');
        await ApiService.post('/api/donor/push-token', {'pushToken': token});
        if (kDebugMode) print('[FCM] Token registered with backend');
      }

      await _messaging.subscribeToTopic('blood_donors');
      if (kDebugMode) print('[FCM] Subscribed to blood_donors topic');
    } catch (e) {
      if (kDebugMode) print('[FCM] Registration failed: $e');
    }
  }

  static void _handleMessageTap(RemoteMessage message) {
    if (kDebugMode) print('[FCM] Notification tapped: ${message.data}');
    final requestId = message.data['requestId'] as String?;
    _navigateToRequests(requestId);
  }

  static void _navigateToRequests(String? requestId) {
    final nav = navigatorKey.currentState;
    if (nav == null) {
      if (kDebugMode) print('[FCM] Navigator not ready, queuing');
      return;
    }

    nav.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => DonorHomeShell(initialTab: 1, requestId: requestId),
      ),
      (route) => false,
    );
  }
}

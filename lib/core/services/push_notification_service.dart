import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/network/api_service.dart' as dermalyze_api;
import 'package:dermalyze/core/storage/token_storage.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background operations if necessary.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class PushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static GlobalKey<NavigatorState>? navigatorKey;

  static Future<void> initialize(GlobalKey<NavigatorState> navKey) async {
    navigatorKey = navKey;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permissions (especially for iOS)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Local notifications initialization for foreground messages
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!) as Map<String, dynamic>;
            _handleDeepLink(data);
          } catch (e) {
            print("Error decoding notification payload: $e");
          }
        }
      },
    );

    // Create a channel for Android foreground notifications
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Prevent showing notification to ourselves if we are testing multiple accounts on the same device
        final senderId = message.data['senderId'];
        
        final user = await TokenStorage().getUser();
        final currentUserId = user?['_id']?.toString() ?? '';
        final currentUserName = user?['name']?.toString() ?? user?['firstName']?.toString() ?? '';
        
        bool isFromMe = false;
        if (senderId != null && senderId == currentUserId) {
          isFromMe = true;
        } else if (notification.title != null && notification.title!.contains(currentUserName) && currentUserName.isNotEmpty) {
          // Fallback check by name if backend doesn't send senderId in data
          isFromMe = true;
        }

        if (isFromMe) {
          return; // Ignore echo notifications from ourselves
        }

        _localNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    // Handle app opened from background state via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleDeepLink(message.data);
    });

    // Handle app opened from terminated state via notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Need a slight delay to allow navigator to initialize in some cases
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleDeepLink(initialMessage.data);
      });
    }

    // Fetch FCM Token (Usually you'd send this to the backend)
    try {
      String? token = await _fcm.getToken();
      print("FCM Token: $token");
      if (token != null) {
        await registerFcmToken(token);
      }
    } catch (e) {
      print("Failed to get FCM token: $e");
    }
  }

  static Future<void> registerFcmToken([String? token]) async {
    try {
      if (Firebase.apps.isEmpty) {
        print("ℹ️ Firebase is not initialized. Skipping FCM token registration.");
        return;
      }
      
      final fcmToken = token ?? await _fcm.getToken();
      if (fcmToken == null) return;

      final apiService = dermalyze_api.ApiService(); // need to import
      await apiService.put(
        'user/fcm-token',
        {'fcmToken': fcmToken},
      );
      print("✅ FCM Token registered with backend");
    } catch (e) {
      print("❌ Failed to register FCM token with backend: $e");
    }
  }

  static void _handleDeepLink(Map<String, dynamic> data) {
    if (navigatorKey?.currentState == null) return;

    if (data['type'] == 'followup') {
      navigatorKey!.currentState!.pushNamed(
        AppRoutes.uploadAnalyze,
        arguments: {
          'patientId': data['patientId'] ?? '',
          'patientName': data['patientName'],
          'diagnosis': data['diagnosis'],
        },
      );
    }
  }
}

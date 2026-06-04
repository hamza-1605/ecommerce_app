import 'package:ekart/app/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final _fcm = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {

    // 1. Request permission
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Setup local notifications (for foreground)
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // 👈 fired when user taps foreground notification
        Get.toNamed(AppRoutes.notifications);
      }
    );


    // 3. Create notification channel (Android 8+)
    const channel = AndroidNotificationChannel(
      'ekart_channel',         // id
      'E-Kart Notifications',  // name
      description: 'Order and delivery notifications',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'ekart_channel',
              'E-Kart Notifications',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // 5. Handle background/terminated notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // 👈 fired when user taps background notification
      Get.toNamed(AppRoutes.notifications);
    });

    // 6. Handle terminated state tap
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      // 👈 app was opened from a notification while terminated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(AppRoutes.notifications);
      });
    }
  }

  // Call this after login to get the token
  static Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}
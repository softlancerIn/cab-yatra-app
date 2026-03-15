import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'notification_service.dart';
import 'secure_storage_service.dart';
class NotificationService {

  static Future<void> initialize() async {

    await AwesomeNotifications().initialize(

      null,

      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ],
    );

  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {

    await AwesomeNotifications().createNotification(

      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),

    );

  }

}



class FCMService {

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {

    // Permission
    await _messaging.requestPermission();

    // Get token
    String? token = await _messaging.getToken();

    debugPrint("FCM TOKEN => $token");

    if (token != null) {
      await SecureStorageService.saveFcmToken(token);
    }

    // Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      debugPrint("Notification Title: ${message.notification?.title}");
      debugPrint("Notification Body: ${message.notification?.body}");

      NotificationService.showNotification(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
      );

    });

  }
}
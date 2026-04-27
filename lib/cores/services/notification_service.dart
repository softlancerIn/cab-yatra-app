import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'secure_storage_service.dart';
import '../../app/router/app_router.dart';
import '../../app/router/navigation/routes.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🌙 Handling a background message: ${message.messageId}");
  debugPrint("🌙 Background Message Data: ${message.data}");
}

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

    // Set listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    final payload = action.payload;
    final String? bookingId = payload?['bookingId'] ?? payload?['booking_id'];
    
    if (bookingId != null) {
      AppRouter.router.push(
        Routes.chatScreen,
        extra: {
          'bookingId': bookingId,
          'userName': payload?['userName'] ?? payload?['senderName'] ?? "User",
          'receiverId': payload?['receiverId'] ?? payload?['senderId'] ?? "0",
          'creatorName': payload?['creatorName'] ?? "Guddu",
          'isFromDetails': false,
        },
      );
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: payload,
        notificationLayout: body.contains("\n") 
            ? NotificationLayout.BigText 
            : NotificationLayout.Default,
        // Added styling to match the premium look
        backgroundColor: const Color(0xFFFFB300),
        displayOnForeground: true,
        displayOnBackground: true,
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
      debugPrint("🔔 Notification Received in Foreground!");
      debugPrint("🔔 Title: ${message.notification?.title}");
      debugPrint("🔔 Body: ${message.notification?.body}");
      debugPrint("🔔 Data Payload: ${message.data}");
      
      // Map values to strings for AwesomeNotifications payload
      final Map<String, String> payloadMap = {};
      message.data.forEach((key, value) {
        payloadMap[key] = value.toString();
      });

      String title = message.notification?.title ?? "New Notification";
      String body = message.notification?.body ?? "";

      // Construct detailed body if it's a booking notification
      // Based on common keys or if specific booking keys are present
      if (message.data.containsKey('booking_id') || 
          message.data.containsKey('bookingId') || 
          message.data.containsKey('pickup_location')) {
          
          final String type = message.data['sub_type'] ?? message.data['type'] ?? "New";
          final String pickup = message.data['pickup_location'] ?? message.data['pickup'] ?? "";
          final String drop = message.data['drop_location'] ?? message.data['drop'] ?? "";
          final String vehicle = message.data['vehicle_type'] ?? message.data['vehicle'] ?? "";
          final String date = message.data['pickup_date'] ?? message.data['date'] ?? "";
          final String time = message.data['pickup_time'] ?? message.data['time'] ?? "";
          final String days = message.data['no_of_days'] ?? message.data['days'] ?? "";

          title = "$type Booking";
          
          // Build multi-line body like the reference image
          List<String> lines = [];
          if (pickup.isNotEmpty) lines.add("Pickup - $pickup");
          if (drop.isNotEmpty) lines.add("Drop - $drop");
          if (vehicle.isNotEmpty) lines.add("Vehicle - $vehicle");
          if (date.isNotEmpty) {
            String dated = "Dated - $date";
            if (time.isNotEmpty) dated += " @$time";
            lines.add(dated);
          }
          if (days.isNotEmpty && days != "0") lines.add("No. Of Days - $days");
          
          if (lines.isNotEmpty) {
            body = lines.join("\n");
          }
      }

      NotificationService.showNotification(
        title: title,
        body: body,
        payload: payloadMap,
      );
    });

    // Handle background click (App in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification Clicked (Background): ${message.notification?.title}");
      handleNotificationClick(message);
    });

    // Handle terminated click (App was terminated)
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("Notification Clicked (Terminated): ${initialMessage.notification?.title}");
      handleNotificationClick(initialMessage);
    }
  }

  static void handleNotificationClick(RemoteMessage message) {
    debugPrint("Handling notification click: ${message.data}");
    
    // Check if it's a chat notification
    // Usually notifications have a 'type' or we can check for 'booking_id'
    final String? bookingId = message.data['bookingId'] ?? message.data['booking_id'];
    
    if (bookingId != null) {
      // Navigate to Chat Screen
      // Based on AppRouter, extra should be Map<String, dynamic>
      // We might need to fetch more info or use defaults
      AppRouter.router.push(
        Routes.chatScreen,
        extra: {
          'bookingId': bookingId,
          'userName': message.data['userName'] ?? message.data['senderName'] ?? "User",
          'receiverId': message.data['receiverId'] ?? message.data['senderId'] ?? "0",
          'creatorName': message.data['creatorName'] ?? "Guddu",
          'isFromDetails': false,
        },
      );
    }
  }
}

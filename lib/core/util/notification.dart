import "dart:convert";
import "dart:developer";
import "dart:io";
import "dart:typed_data";

import "package:coinhub/core/constants/api_client.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/rendering.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:http/http.dart" as http;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._privateConstructor();

  static final NotificationService _instance =
      NotificationService._privateConstructor();

  static NotificationService get instance => _instance;

  Function(RemoteMessage)? onForegroundMessage;

  Future<void> initialize() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log("firebase :: User granted permission: ${settings.authorizationStatus}");

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("mylogo");

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("firebase :: Received a foreground message: ${message.messageId}");
      _showNotification(message);

      if (onForegroundMessage != null) {
        onForegroundMessage!(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(
        "firebase :: Notification clicked! Message: ${message.notification?.title}",
      );
      _handleNotificationClick(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    String? imgUrl = message.notification?.android?.imageUrl;
    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imgUrl != null) {
      try {
        final response = await http.get(Uri.parse(imgUrl));
        if (response.statusCode == 200) {
          Uint8List imageBytes = response.bodyBytes;
          String base64Image = base64Encode(imageBytes);

          bigPictureStyleInformation = BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(base64Image),
            contentTitle: message.notification?.title,
            summaryText: message.notification?.body,
          );
        } else {
          debugPrint("Image fetch failed: ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("Error fetching image: $e");
      }
    }

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
        );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      platformChannelSpecifics,
    );
  }

  Future<void> _handleNotificationClick(RemoteMessage message) async {
    log(
      "firebase :: User tapped on notification: ${message.notification?.title}",
    );
    // Handle navigation here if needed
  }

  Future<void> _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      log("firebase :: Notification payload: $payload");
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log("firebase :: Handling a background message: ${message.messageId}");
  }

  Future<String?> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    debugPrint("Device Token: $token");
    return token;
  }

  Future<void> registerDeviceToken({
    required String userId,
    required String accessToken,
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        debugPrint("❌ Failed to get FCM token.");
        return;
      }

      debugPrint("🔥 Got FCM token: $fcmToken");

      final body = {
        "fcmToken": fcmToken,
        "deviceId":
            Platform.isIOS
                ? (await DeviceInfoPlugin().iosInfo).identifierForVendor
                : (await DeviceInfoPlugin().androidInfo).id,
      };
      debugPrint(body.toString());

      final response = await ApiClient.client.post(
        Uri.parse("${ApiClient.userEndpoint}/$userId/devices"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Device token registered successfully.");
      } else {
        debugPrint("❌ Failed to register token: ${response.statusCode}");
        debugPrint("💬 Response: ${response.body}");
      }
    } catch (e) {
      debugPrint("🔥 Error registering device token: $e");
    }
  }
}

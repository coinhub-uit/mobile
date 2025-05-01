import "dart:convert";
import "package:coinhub/core/util/env.dart";
import "package:http/http.dart" as http;
import "package:firebase_messaging/firebase_messaging.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/foundation.dart";

class DeviceRegistrationService {
  static var baseUrl = Env.apiServerUrl;
  static Future<void> registerDevice(
    String supabaseUserId,
    String jwtToken,
  ) async {
    try {
      // Get FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        throw Exception("FCM token is null");
      }

      // Get unique device ID (or fallback)
      String deviceId = await _getDeviceId();

      // Construct URL
      final url = Uri.parse("$baseUrl/users/$supabaseUserId/devices");

      // Send POST request
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwtToken",
        },
        body: jsonEncode({"fcmToken": fcmToken, "deviceId": deviceId}),
      );

      // Check response
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Device registered successfully");
      } else {
        debugPrint("Failed to register device: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (e) {
      debugPrint("🔥 Error registering device: $e");
    }
  }

  static Future<String> _getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor ?? "unknown_ios";
    } else {
      return "unsupported_platform";
    }
  }
}
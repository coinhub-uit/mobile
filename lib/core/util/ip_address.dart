import "dart:convert";
import "package:flutter/cupertino.dart";
import "package:http/http.dart" as http;

Future<String?> getIpAddress() async {
  try {
    final response = await http.get(Uri.parse("https://api.ipify.org?format=json"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["ip"];
    } else {
      debugPrint("Failed to get IP. Status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    debugPrint("Error getting IP: $e");
    return null;
  }
}
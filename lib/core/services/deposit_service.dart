import "dart:convert";

import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/models/deposit_model.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class DepositService {
  static final supabaseClient = Supabase.instance.client;

  static Future<DepositTopUpResponse> createTopUp({
    required String provider,
    required String returnUrl,
    required double amount,
    required String sourceDestinationId,
    required String ipAddress,
  }) async {
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.post(
      Uri.parse("${ApiClient.baseUrl}/payment/top-up"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "provider": provider,
        "returnUrl": returnUrl,
        "amount": amount,
        "sourceDestinationId": sourceDestinationId,
        "ipAddress": ipAddress,
      }),
    );

    print("Top-up response status code: ${response.statusCode}");
    print("Top-up response body: ${response.body}");

    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return DepositTopUpResponse.fromJson(decoded);
    } else {
      throw Exception("Failed to create top-up: ${response.statusCode}");
    }
  }

  static Future<DepositStatusResponse> checkTopUpStatus(String topUpId) async {
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.get(
      Uri.parse("${ApiClient.baseUrl}/payment/top-up/$topUpId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("Status check response status code: ${response.statusCode}");
    print("Status check response body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return DepositStatusResponse.fromJson(decoded);
    } else {
      throw Exception("Failed to check top-up status: ${response.statusCode}");
    }
  }
}

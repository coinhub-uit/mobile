import "dart:convert";

import "package:coinhub/core/constants/api_client.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class TransferService {
  static final supabaseClient = Supabase.instance.client;

  static Future<bool> transferFunds({
    required String fromSourceId,
    required String toSourceId,
    required int money,
  }) async {
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.post(
      ApiClient.transferEndpoint,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
        "accept": "*/*",
      },
      body: jsonEncode({
        "fromSourceId": fromSourceId,
        "toSourceId": toSourceId,
        "money": money,
      }),
    );

    print("Transfer response status code: ${response.statusCode}");
    print("Transfer response body: ${response.body}");

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 404) {
      throw Exception("Account not found");
    } else {
      throw Exception("Transfer failed: ${response.statusCode}");
    }
  }
}

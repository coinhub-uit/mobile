import "dart:convert";

import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/core/services/user_service.dart";
import "package:coinhub/models/source_model.dart";
import "package:http/http.dart" as http;
import "package:supabase_flutter/supabase_flutter.dart";

class SourceService {
  static final supabaseClient = Supabase.instance.client;
  // static Future<List<SourceModel>> fetchSources(String userId) async {
  //   final session = supabaseClient.auth.currentSession;
  //   final accessToken = session?.accessToken;
  //   if (accessToken == null) {
  //     throw Exception("Session not found");
  //   }
  //   print("Access token: $accessToken");

  //   final response = await ApiClient.client.get(
  //     Uri.parse("${ApiClient.sourceEndpoint}/${userId}"),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $accessToken",
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> decoded = jsonDecode(response.body);
  //     print("Decoded plans: $decoded");
  //     print("Decoded plans length: ${decoded.length}");
  //     return decoded.map((plan) => SourceModel.fromJson(plan)).toList();
  //   } else if (response.contentLength == 0) {
  //     print("No sources found for user $userId");
  //     return [];
  //   } else {
  //     throw Exception("Failed to fetch sources: ${response.statusCode}");
  //   }
  // }
  static Future<SourceModel> fetchSource(String sourceId) async {
    // Use Supabase's current session instead of manual storage
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.get(
      Uri.parse("${ApiClient.sourceEndpoint}/$sourceId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    print("response status code: ${response.statusCode}");
    print("response body: ${response.body}");
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return SourceModel.fromJson(decoded);
    } else {
      throw Exception("Failed to fetch sources: ${response.statusCode}");
    }
  }

  static Future<http.Response> createSource(String sourceId) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception("User not found");
    }
    final List<SourceModel> sources = await UserService.fetchSources(user.id);
    if (sources.any((source) => source.id == sourceId)) {
      throw Exception("You already have source with ID $sourceId!");
    }
    // Use Supabase's current session instead of manual storage
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    try {
      final response = await ApiClient.client.post(
        Uri.parse("${ApiClient.sourceEndpoint}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({"id": sourceId}),
      );
      print("response status code: ${response.statusCode}");
      print("response body: ${response.body}");

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to create source: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during POST: $e");
      rethrow;
    }
  }

  static Future<http.Response> deleteSource(String sourceId) async {
    final source = await fetchSource(sourceId);
    if (int.parse(source.balance!) != 0) {
      throw Exception(
        "Please make sure the source is empty before deleting it.",
      );
    }

    // Use Supabase's current session instead of manual storage
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.delete(
      Uri.parse("${ApiClient.sourceEndpoint}/$sourceId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 409) {
      return response;
    } else {
      throw Exception("Failed to delete source: ${response.statusCode}");
    }
  }

  static Future<bool> checkAllSourcesIsEmpty(String userId) async {
    final sources = await UserService.fetchSources(userId);
    if (sources.isEmpty) {
      return true;
    } else {
      for (final source in sources) {
        if (int.parse(source.balance!) != 0) {
          return false;
        }
      }
      return true;
    }
  }
}

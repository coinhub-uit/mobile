import "dart:convert";

import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/core/services/local_storage.dart";
import "package:http/http.dart" as http;

class SourceService {
  // static Future<List<SourceModel>> fetchSources(String userId) async {
  //   final accessToken = await LocalStorageService().read("JWT");
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

  static Future<http.Response> createSource(String sourceId) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.post(
      Uri.parse("${ApiClient.sourceEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({"id": sourceId}),
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Failed to create source: ${response.statusCode}");
    }
  }

  static Future<http.Response> deleteSource(String sourceId) async {
    final accessToken = await LocalStorageService().read("JWT");
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
}

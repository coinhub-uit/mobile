import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/core/services/local_storage.dart";
import "package:coinhub/models/ticket_model.dart";
import "package:http/http.dart" as http;

class TicketService {
  static Future<http.Response> createTicket(TicketModel ticketModel) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }
    print("send to json: ${ticketModel.toJson()}");
    final response = await ApiClient.client.post(
      Uri.parse("${ApiClient.ticketEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: ticketModel.toJson(),
    );
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Failed to create source: ${response.statusCode}");
    }
  }

  static Future<http.Response> fetchTicket(String ticketId) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    return ApiClient.client.get(
      Uri.parse("${ApiClient.ticketEndpoint}/$ticketId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  static Future<http.Response> withdrawTicket(int ticketId) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    try {
      final response = await ApiClient.client.get(
        Uri.parse("${ApiClient.ticketEndpoint}/$ticketId/withdraw"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Failed to withdraw ticket: ${response.statusCode}");
      }
    } catch (e) {
      print("Error withdrawing ticket: $e");
      return Future.error("Failed to withdraw ticket: $e");
    }
  }

  static Future<http.Response> getSourceId(int ticketId) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    try {
      final response = await ApiClient.client.post(
        Uri.parse("${ApiClient.ticketEndpoint}/$ticketId/sources"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Failed to fetch source ID: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching source ID: $e");
      return Future.error("Failed to fetch source ID: $e");
    }
  }
}

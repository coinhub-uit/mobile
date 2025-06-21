import "dart:convert";
import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/core/services/auth_service.dart";

class ChatMessage {
  final String role;
  final String message;

  ChatMessage({required this.role, required this.message});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(role: json["role"], message: json["message"]);
  }

  Map<String, dynamic> toJson() {
    return {"role": role, "message": message};
  }
}

class ChatService {
  static final Uri _chatEndpoint = Uri.parse("${ApiClient.baseUrl}/ai-chat");

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getCurrentAccessToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<List<ChatMessage>> getChatSession() async {
    try {
      final headers = await _getHeaders();
      final response = await ApiClient.client.get(
        _chatEndpoint,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load chat session: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error getting chat session: $e");
    }
  }

  static Future<ChatMessage> sendMessage(String message) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode({"message": message});

      final response = await ApiClient.client.post(
        _chatEndpoint,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatMessage.fromJson(data);
      } else {
        throw Exception("Failed to send message: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error sending message: $e");
    }
  }

  static Future<void> deleteSession() async {
    try {
      final headers = await _getHeaders();
      final response = await ApiClient.client.delete(
        _chatEndpoint,
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete session: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error deleting session: $e");
    }
  }
}

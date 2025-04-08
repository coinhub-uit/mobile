import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/core/services/local_storage.dart";
import "package:coinhub/models/user_model.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:supabase_flutter/supabase_flutter.dart";

class UserService {
  static final supabaseClient = Supabase.instance.client;

  static Future<String> getAccessToken(
    String userEmail,
    String userPassword,
  ) async {
    final authResponse = await supabaseClient.auth.signInWithPassword(
      email: userEmail,
      password: userPassword,
    );
    final session = authResponse.session;
    if (session == null) {
      throw Exception("Session not found");
    }
    final accessToken = session.accessToken;
    if (accessToken.isEmpty) {
      throw Exception("Access token not found");
    }
    return accessToken;
  }

  static Future<AuthResponse> getAuthResponse(
    String userEmail,
    String userPassword,
  ) async {
    final authResponse = await supabaseClient.auth.signInWithPassword(
      email: userEmail,
      password: userPassword,
    );
    return authResponse;
  }

  // ignore: non_constant_identifier_names
  static Future<http.Response> signUpDetails(
    UserModel userModel,
    String userEmail,
    String userPassword,
  ) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }
    final supabaseResponse = await supabaseClient.auth.signInWithPassword(
      email: userEmail,
      password: userPassword,
    );
    final user = supabaseResponse.user; // gotta get the id
    if (user == null) {
      throw Exception("User not found");
    }
    final userId = user.id;
    print(user.id);
    UserModel newUser = UserModel(
      id: userId,
      fullname: userModel.fullname,
      birthDate: userModel.birthDate,
      avatar: userModel.avatar,
      citizenId: userModel.citizenId,
      address: userModel.address,
    );
    print("newUser as json: ${newUser.toJsonForRequest()}");
    final response = await ApiClient.client.post(
      Uri.parse("${ApiClient.userEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: newUser.toJsonForRequest(),
    );

    print("reponse: ${response.body}");

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Failed to create user: ${response.statusCode}");
    }
  }

  static Future<UserModel> getUser(String id) async {
    final user = supabaseClient.auth.currentUser;
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }
    print("access token: $accessToken");
    print("user id: ${user?.id}");
    if (user == null) {
      throw Exception("User not found");
    }
    final response = await ApiClient.client.get(
      Uri.parse("${ApiClient.userEndpoint}/${user.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    print("response: ${response.body}");
    print("response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      debugPrint("User data: ${UserModel.fromJson(response.body)}");
      return UserModel.fromJson(response.body);
    } else {
      throw Exception("Failed to get user: ${response.statusCode}");
    }
  }
}

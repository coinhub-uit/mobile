import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/models/user_model.dart";
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
    final supabaseResponse = await getAuthResponse(userEmail, userPassword);
    final accessToken = await getAccessToken(userEmail, userPassword);

    final user = supabaseResponse.user;
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
      phoneNumber: userModel.phoneNumber,
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

    print(response.body);

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Failed to create user: ${response.statusCode}");
    }
  }

  static Future<UserModel> getUser(
    UserModel userModel,
    String userEmail,
    String userPassword,
  ) async {
    final user = supabaseClient.auth.currentUser;
    final accessToken = await getAccessToken(userEmail, userPassword);
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
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else {
      throw Exception("Failed to get user: ${response.statusCode}");
    }
  }
}

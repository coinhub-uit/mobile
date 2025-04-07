import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/models/user_model.dart";
import "package:http/http.dart" as http;
import "package:supabase_flutter/supabase_flutter.dart";

class UserService {
  static final supabaseClient = Supabase.instance.client;

  // ignore: non_constant_identifier_names
  static Future<http.Response> signUpDetails(
    UserModel userModel,
    String userEmail,
    String userPassword,
  ) async {
    final supabaseResponse = await supabaseClient.auth.signInWithPassword(
      password: userPassword,
      email: userEmail,
    );
    final session = supabaseResponse.session;
    if (session == null) {
      throw Exception("Session not found");
    }
    final accessToken = session.accessToken;
    if (accessToken.isEmpty) {
      throw Exception("Access token not found");
    }

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
}

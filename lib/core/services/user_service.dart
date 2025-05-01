import "dart:convert";
import "dart:io";

import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/core/services/local_storage.dart";
import "package:coinhub/models/user_model.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:image_picker/image_picker.dart";
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
    final supabaseResponse = await supabaseClient.auth.signInWithPassword(
      email: userEmail,
      password: userPassword,
    );
    final accessToken = supabaseResponse.session?.accessToken;
    if (accessToken == null) {
      throw Exception("Access token not found");
    }
    final user = supabaseResponse.user; // gotta get the id
    if (user == null) {
      throw Exception("User not found");
    }
    final userId = user.id;
    UserModel newUser = UserModel(
      id: userId,
      fullname: userModel.fullname,
      birthDate: userModel.birthDate,
      avatar: userModel.avatar,
      citizenId: userModel.citizenId,
      address: userModel.address,
    );
    final response = await ApiClient.client.post(
      Uri.parse("${ApiClient.userEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: newUser.toJsonForRequest(),
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Failed to create user: ${response.statusCode}");
    }
  }

  static Future<UserModel?> getUser(String id) async {
    final user = supabaseClient.auth.currentUser;
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }
    if (user == null) {
      return null;
    }
    final response = await ApiClient.client.get(
      Uri.parse("${ApiClient.userEndpoint}/${user.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200) {
      debugPrint("User data: ${UserModel.fromJson(response.body)}");
      return UserModel.fromJson(response.body);
    } else {
      throw Exception("Failed to get user: ${response.statusCode}");
    }
  }

  static Future<http.Response> updateUserDetails(UserModel userModel) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }
    final response = await ApiClient.client.put(
      Uri.parse("${ApiClient.userEndpoint}/${userModel.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: userModel.toJsonForRequest(),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to update user: ${response.statusCode}");
    }
  }

  static Future<String> uploadAvatar(String userId, File imageFile) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception("Not signed in");

    final storageRef = Supabase.instance.client.storage.from("avatars");
    final path = "user_$userId.jpg";

    // delete the old avatar if it exists
    try {
      await storageRef.remove([path]);
    } catch (error) {
      debugPrint("Error deleting old avatar: $error");
    }

    try {
      // Upload and overwrite if it already exists
      await storageRef.upload(
        path,
        imageFile,
        fileOptions: const FileOptions(upsert: true),
      );
    } catch (error) {
      rethrow;
    }
    // get the public url of the image
    final publicUrl = storageRef.getPublicUrl(path);
    return publicUrl;
  }

  static Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }
    final response = await ApiClient.client.patch(
      Uri.parse("${ApiClient.userEndpoint}/$userId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({"avatar": avatarUrl}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update avatar url: ${response.statusCode}");
    }
  }

  static Future<String> pickAndUploadAvatar(String userId) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (image != null) {
        final File file = File(image.path);
        final String avatarUrl = await uploadAvatar(userId, file);
        await updateAvatarUrl(userId, avatarUrl);
        return avatarUrl;
      }
    } catch (e) {
      return "No avatar was found";
    }
    return "No avatar was found"; // Return an empty string if no image was picked
  }

  static Future<http.Response> deleteUserAccount(String userId) async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }
    final response = await ApiClient.client.delete(
      Uri.parse("${ApiClient.userEndpoint}/$userId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200) {
      // Delete the user from Supabase auth => need backend :(
      // try {
      //   await supabaseClient.auth.admin.deleteUser(userId);
      // } catch (e) {
      //   print("Error deleting user from Supabase auth: $e");
      // }
      // Clear the local storage5
      await LocalStorageService().delete("JWT");

      return response;
    } else {
      throw Exception("Failed to delete user: ${response.statusCode}");
    }
  }
}

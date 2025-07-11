import "dart:convert";
import "dart:io";

import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/core/services/source_service.dart";
import "package:coinhub/core/services/ticket_service.dart";
import "package:coinhub/models/notification_model.dart";
import "package:coinhub/models/source_model.dart";
import "package:coinhub/models/ticket_model.dart";
import "package:coinhub/models/user_model.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:image_picker/image_picker.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:mime/mime.dart"; // to detect content-type
import "package:http_parser/http_parser.dart"; // to support media type

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
    print("Access token: $accessToken");

    final user = supabaseResponse.user; // gotta get the id
    if (user == null) {
      throw Exception("User not found");
    }
    final userId = user.id;
    UserModel newUser = UserModel(
      id: userId,
      fullName: userModel.fullName,
      birthDate: userModel.birthDate,
      avatar: userModel.avatar,
      citizenId: userModel.citizenId,
      address: userModel.address,
    );
    print(jsonEncode(newUser.toJsonForRequest()));

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
      throw Exception("Failed to create user: ${response.body}");
    }
  }

  static Future<UserModel?> getUser(String id) async {
    final user = supabaseClient.auth.currentUser;
    // Use Supabase's current session and refresh if needed
    final session = await _getValidSession();
    final accessToken = session?.accessToken;
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
    // Use Supabase's current session instead of manual storage
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
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

  // static Future<String> uploadAvatar(String userId, File imageFile) async {
  //   final user = Supabase.instance.client.auth.currentUser;
  //   if (user == null) throw Exception("Not signed in");

  //   final storageRef = Supabase.instance.client.storage.from("avatars");
  //   final path = "user_$userId.jpg";

  //   // delete the old avatar if it exists
  //   try {
  //     await storageRef.remove([path]);
  //   } catch (error) {
  //     debugPrint("Error deleting old avatar: $error");
  //   }

  //   try {
  //     // Upload and overwrite if it already exists
  //     await storageRef.upload(
  //       path,
  //       imageFile,
  //       fileOptions: const FileOptions(upsert: true),
  //     );
  //   } catch (error) {
  //     rethrow;
  //   }
  //   // get the public url of the image
  //   final publicUrl = storageRef.getPublicUrl(path);
  //   return publicUrl;
  // }

  // static Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
  //   // Use Supabase's current session instead of manual storage
  //   final session = supabaseClient.auth.currentSession;
  //   final accessToken = session?.accessToken;
  //   if (accessToken == null) {
  //     throw Exception("Session not found");
  //   }
  //   final response = await ApiClient.client.patch(
  //     Uri.parse("${ApiClient.userEndpoint}/$userId"),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $accessToken",
  //     },
  //     body: jsonEncode({"avatar": avatarUrl}),
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception("Failed to update avatar url: ${response.statusCode}");
  //   }
  // }

  // static Future<String> pickAndUploadAvatar(String userId) async {
  //   try {
  //     final ImagePicker imagePicker = ImagePicker();
  //     final XFile? image = await imagePicker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 50,
  //     );
  //     if (image != null) {
  //       final File file = File(image.path);
  //       final String avatarUrl = await uploadAvatar(userId, file);
  //       await updateAvatarUrl(userId, avatarUrl);
  //       return avatarUrl;
  //     }
  //   } catch (e) {
  //     return "No avatar was found";
  //   }
  //   return "No avatar was found"; // Return an empty string if no image was picked
  // }

  static Future<String> pickAndUploadAvatar(String userId) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (image == null) {
        return "No image selected";
      }

      final File file = File(image.path);

      final mimeType = lookupMimeType(file.path); // <-- get the MIME type
      if (mimeType == null) {
        return "Unsupported file type";
      }
      final mimeSplit = mimeType.split("/");

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${ApiClient.userEndpoint}/$userId/avatar"),
      );

      final session = supabaseClient.auth.currentSession;
      final accessToken = session?.accessToken;
      request.headers["Authorization"] = "Bearer $accessToken";

      request.files.add(
        await http.MultipartFile.fromPath(
          "file", // Make sure this matches your backend's @File('file')
          file.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response status: ${response.statusCode}, body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final avatarUrl = data["avatarUrl"];
        return avatarUrl;
      } else {
        throw Exception("Failed to upload avatar: ${response.body}");
      }
    } catch (e) {
      return "Upload failed: $e";
    }
  }

  static Future<http.Response> getAvatarUrl(String userId) async {
    // Use Supabase's current session instead of manual storage
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }
    final response = await ApiClient.client.get(
      Uri.parse("${ApiClient.userEndpoint}/$userId/avatar"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to get avatar url: ${response.statusCode}");
    }
  }

  static Future<http.Response> deleteUserAccount(String userId) async {
    final isAllSourcesEmpty = await SourceService.checkAllSourcesIsEmpty(
      userId,
    );
    if (!isAllSourcesEmpty) {
      throw Exception(
        "Please empty or delete all sources before deleting your account.",
      );
    }

    // Use Supabase's current session instead of manual storage
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
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
      // Remove manual JWT clearing - Supabase handles session cleanup automatically
      // await LocalStorageService().delete("JWT");

      return response;
    } else {
      throw Exception("Failed to delete user: ${response.statusCode}");
    }
  }

  // source

  static Future<List<SourceModel>> fetchSources(String userId) async {
    // Use Supabase's current session and refresh if needed
    final session = await _getValidSession();
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final url = Uri.parse("${ApiClient.userEndpoint}/$userId/sources");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    final response = await ApiClient.client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((plan) => SourceModel.fromJson(plan)).toList();
    } else if (response.contentLength == 0) {
      return [];
    } else {
      throw Exception("Failed to fetch sources: ${response.body}");
    }
  }

  // Helper method to get valid session with refresh
  static Future<Session?> _getValidSession() async {
    try {
      final currentSession = supabaseClient.auth.currentSession;

      if (currentSession == null) {
        throw Exception("No session found");
      }

      // Check if token is expired or about to expire (within 5 minutes)
      final now = DateTime.now();
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        currentSession.expiresAt! * 1000,
      );
      final timeUntilExpiry = expiresAt.difference(now);

      // If token expires in less than 5 minutes, refresh it
      if (timeUntilExpiry.inMinutes < 5) {
        final refreshResponse = await supabaseClient.auth.refreshSession();
        if (refreshResponse.session != null) {
          return refreshResponse.session;
        } else {
          throw Exception("Failed to refresh session");
        }
      }

      return currentSession;
    } catch (e) {
      // Try to refresh session as fallback
      try {
        final refreshResponse = await supabaseClient.auth.refreshSession();
        if (refreshResponse.session != null) {
          return refreshResponse.session;
        } else {
          throw Exception("Session invalid and refresh failed");
        }
      } catch (refreshError) {
        throw Exception("Session invalid and refresh failed");
      }
    }
  }

  // static Future<List<TicketModel>> fetchTickets(String userId) async {
  //   // Use Supabase's current session and refresh if needed
  //   final session = await _getValidSession();
  //   final accessToken = session?.accessToken;
  //   if (accessToken == null) {
  //     throw Exception("Session not found");
  //   }

  //   final response = await ApiClient.client.get(
  //     Uri.parse("${ApiClient.userEndpoint}/$userId/tickets"),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $accessToken",
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> decoded = jsonDecode(response.body);
  //     final ticketsList =
  //         decoded.map((ticket) => TicketModel.fromMap(ticket)).toList();
  //     for (final ticket in ticketsList) {
  //       final fetchedSourceId = await TicketService.getSourceId(ticket.id!);
  //       ticket.sourceId = fetchedSourceId.body;
  //     }
  //     return ticketsList;
  //   } else if (response.contentLength == 0) {
  //     return [];
  //   } else {
  //     throw Exception("Failed to fetch tickets: ${response.statusCode}");
  //   }
  // }
  static Future<List<TicketModel>> fetchTickets(String userId) async {
    //print("[fetchTickets] Start fetching tickets for user: $userId");

    // Get a valid session with access token
    final session = await _getValidSession();
    final accessToken = session?.accessToken;

    if (accessToken == null) {
      throw Exception("[fetchTickets] Session not found");
    }

    final url = Uri.parse(
      "${ApiClient.userEndpoint}/$userId/tickets?activeTicketOnly=false",
    );

    try {
      final response = await ApiClient.client.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      print("[fetchTickets] Response Status: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        final ticketsList =
            decoded.map((ticket) {
              //print("🧾 [fetchTickets] Decoding ticket: $ticket");
              return TicketModel.fromMap(ticket);
            }).toList();

        //print("[fetchTickets] Decoded ${ticketsList.length} tickets");

        await Future.wait(
          ticketsList.map((ticket) async {
            //print("[fetchTickets] Fetching sourceId for ticket ${ticket.id}");
            try {
              final fetchedSourceId = await TicketService.getSourceId(
                ticket.id!,
              ).timeout(const Duration(seconds: 5));
              ticket.source = SourceModel.fromMap(
                json.decode(fetchedSourceId.body),
              );

              // print(
              //   "[fetchTickets] Got sourceId for ticket ${ticket.id}: ${ticket.sourceId}",
              // );
            } catch (e) {
              print(
                "[fetchTickets] Failed to get sourceId for ticket ${ticket.id}: $e",
              );
              ticket.sourceId = "";
            }
          }),
        );

        return ticketsList;
      } else if (response.contentLength == 0) {
        print("[fetchTickets] No content in response");
        return [];
      } else {
        throw Exception(
          "[fetchTickets] Failed with status: ${response.statusCode}",
        );
      }
    } catch (e, s) {
      print("[fetchTickets] Exception: $e\n Stack: $s");
      rethrow;
    }
  }

  static Future<List<NotificationModel>> fetchNotifications(
    String userId,
  ) async {
    // Use Supabase's current session and refresh if needed
    final session = await _getValidSession();
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.get(
      Uri.parse("${ApiClient.userEndpoint}/$userId/notifications"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();
    } else if (response.contentLength == 0) {
      return [];
    } else {
      throw Exception("Failed to fetch notifications: ${response.statusCode}");
    }
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    // Use Supabase's current session and refresh if needed
    final session = await _getValidSession();
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.get(
      Uri.parse("${ApiClient.notificationEndpoint}/$notificationId/read"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to mark notification as read: ${response.statusCode}",
      );
    }
  }
}

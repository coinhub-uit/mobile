import "package:coinhub/core/services/user_service.dart";
import "package:coinhub/core/util/device_register.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:coinhub/core/util/env.dart";

class AuthResult {
  final User? user;
  final Session? session;
  final bool success;

  AuthResult({
    required this.user,
    required this.session,
    required this.success,
  });
}

class AuthService {
  static final supabaseClient = Supabase.instance.client;

  /// Initialize session on app startup
  /// This method checks for existing session and returns it if valid
  static Future<Session?> initializeSession() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session != null) {
        // Optionally verify if the user exists in your app database
        try {
          await UserService.getUser(session.user.id);
        } catch (e) {
          // User not found in app database, but session is valid
          // You can decide how to handle this case
          return session;
        }
        return session;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<AuthResponse> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: Env.oauthGoogleIosClientId,
      serverClientId: Env.oauthGoogleWebClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;

    final accessToken = googleAuth?.accessToken;
    final idToken = googleAuth?.idToken;

    if (accessToken == null) {
      throw "No Access Token found.";
    }
    if (idToken == null) {
      throw "No ID Token found.";
    }

    final response = await supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    // Remove manual JWT storage - Supabase handles this automatically
    // await LocalStorageService().write("JWT", response.session!.accessToken);

    if (response.user?.id == null) {
      throw "Something went wrong. User not found";
    }
    if (response.session?.accessToken == null) {
      throw "Something went wrong. session not found";
    }
    DeviceRegistrationService.registerDevice(
      response.user!.id,
      response.session!.accessToken,
    );

    return response;
  }

  static Future<AuthResult> signInWithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userId = response.user?.id;
      if (userId == null) {
        return AuthResult(user: null, session: null, success: false);
      }

      // Try to get user from app database
      bool foundInDb = true;
      try {
        final dbResult = await UserService.getUser(userId);
        if (dbResult == null) {
          foundInDb = false;
        }
      } catch (e) {
        // User doesn't exist in app database but Supabase auth succeeded
        foundInDb = false;
      }

      // Return success if Supabase authentication succeeded, regardless of app database
      return AuthResult(
        user: response.user,
        session: response.session,
        success: foundInDb,
      );
    } catch (e) {
      return AuthResult(user: null, session: null, success: false);
    }
  }

  static Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  static Future<void> signUpWithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      await supabaseClient.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      if (e.message == "User already registered") {
        throw "User already registered";
      } else if (e.message == "Email not verified") {
        throw "Email not verified";
      } else {
        rethrow;
      }
    } catch (e) {
      if (e is AuthException) {
        throw e.message;
      } else {
        throw "$e";
      }
    }
  }

  static Future<void> forgotPassword(String email) async {
    await supabaseClient.auth.resetPasswordForEmail(
      email,
      redirectTo: "coinhub://auth/reset-password",
    );
  }

  static Future<UserResponse> updatePassword(String password) async {
    final response = await supabaseClient.auth.updateUser(
      UserAttributes(password: password),
    );
    return response;
  }

  static Stream<AuthState> get authStateChanges =>
      supabaseClient.auth.onAuthStateChange;

  static Future<bool> isUserLoggedIn() async {
    final session = supabaseClient.auth.currentSession;
    return session != null;
  }

  static Future<Session?> getCurrentSession() async {
    return supabaseClient.auth.currentSession;
  }

  static Future<String?> getCurrentAccessToken() async {
    final session = supabaseClient.auth.currentSession;
    return session?.accessToken;
  }

  static Future<bool> isUserVerified(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final session = response.session;
      if (session == null) {
        return false;
      }

      final user = response.user;
      if (user == null) {
        return false;
      }
      if (user.emailConfirmedAt != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateNewPassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      supabaseClient.auth.signOut(); // Sign out the user first
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: oldPassword,
      );
      final session = response.session;
      if (session == null) {
        return false;
      }

      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> resendVerificationCode(String email) async {
    await supabaseClient.auth.resend(type: OtpType.signup, email: email);
  }

  static Future<void> deleteUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw "User not found";
    }
    final userId = user.id;
    try {
      final response = await UserService.deleteUserAccount(userId);
      if (response.statusCode != 204) {
        throw "Failed to delete user account";
      }
    } catch (e) {
      throw Exception("Error deleting user: $e");
    }
    await supabaseClient.auth.signOut();

    // Remove manual JWT clearing - Supabase handles session cleanup automatically
    // await LocalStorageService().delete("JWT");
  }

  static User? get currentUser => supabaseClient.auth.currentUser;
}

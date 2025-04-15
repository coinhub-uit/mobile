import "package:coinhub/core/services/local_storage.dart";
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

  static Future<User?> signInWithGoogle() async {
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
    LocalStorageService().write("JWT", response.session!.accessToken);
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

    return response.user;
  }

  static Future<AuthResult> signInWithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      bool foundInDb = true;
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final userId = response.user?.id;
      if (userId == null) {
        foundInDb = false;
      }
      final dbResult = await UserService.getUser(userId!);
      if (dbResult == null) {
        foundInDb = false;
      } else {
        await LocalStorageService().write("JWT", response.session!.accessToken);
      }
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
      //await LocalStorageService().write("JWT", response.session!.accessToken);
      // print("${response.session?.accessToken} token is here");

      // final user = response.user;
      // if (user == null) {
      //   throw "User not found";
      // }
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
    final session = await LocalStorageService().read("JWT");
    return session != null;
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
      await LocalStorageService().write("JWT", session.accessToken);

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
      await LocalStorageService().write("JWT", session.accessToken);

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

  static User? get currentUser => supabaseClient.auth.currentUser;
}

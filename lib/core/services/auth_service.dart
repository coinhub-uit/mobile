import "package:coinhub/core/services/local_storage.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:coinhub/core/util/env.dart";

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

    return response.user;
  }

  static Future<AuthResponse> signInWithEmailandPassword(
    String email,
    String password,
  ) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    LocalStorageService().write("JWT", response.session!.accessToken);
    return response;
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
        throw "An unknown error occurred";
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

  static Future<bool> isUserVerified() async {
    try {
      final userResponse = await supabaseClient.auth.getUser().timeout(
        const Duration(seconds: 5),
      );
      print("User response: $userResponse");
      final user = userResponse.user;
      print("User: $user");
      return user?.emailConfirmedAt != null;
    } catch (e) {
      print("getUser() failed: $e");
      return false;
    }
  }

  static Future<void> resendVerificationCode(String email) async {
    await supabaseClient.auth.resend(type: OtpType.signup, email: email);
  }

  static User? get currentUser => supabaseClient.auth.currentUser;
}

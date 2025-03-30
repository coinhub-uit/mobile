import "package:coinhub/core/services/local_storage.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:coinhub/core/util/env.dart";

class AuthService {
  static final supabaseClient = Supabase.instance.client;

  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Env.oauthGoogleIosClientId,
        serverClientId: Env.oauthGoogleWebClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final accessToken = googleAuth?.accessToken;
      final idToken = googleAuth?.idToken;

      if (accessToken == null) throw "No Access Token found.";
      if (idToken == null) throw "No ID Token found.";

      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      await _saveJwt(response.session);
      return response.user;
    } catch (e, stackTrace) {
      print("Google Sign-In Error: $e");
      print(stackTrace);
      return null;
    }
  }

  static Future<AuthResponse?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      await _saveJwt(response.session);
      return response;
    } catch (e, stackTrace) {
      print("Email Sign-In Error: $e");
      print(stackTrace);
      return null;
    }
  }

  static Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      await _saveJwt(response.session);
    } catch (e, stackTrace) {
      print("Sign-Up Error: $e");
      print(stackTrace);
    }
  }

  static Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
      await LocalStorageService().delete("JWT");
    } catch (e, stackTrace) {
      print("Sign-Out Error: $e");
      print(stackTrace);
    }
  }

  static Future<void> resendVerificationCode(String email) async {
    try {
      await supabaseClient.auth.resend(type: OtpType.signup, email: email);
    } catch (e, stackTrace) {
      print("Resend Verification Error: $e");
      print(stackTrace);
    }
  }

  static Future<void> forgotPassword(String email) async {
    // TODO: Implement forgot password
  }

  static Stream<AuthState> get authStateChanges =>
      supabaseClient.auth.onAuthStateChange;

  static bool isUserLoggedIn() {
    return supabaseClient.auth.currentSession != null;
  }

  static bool isUserVerified() {
    return supabaseClient.auth.currentUser?.emailConfirmedAt != null;
  }

  static User? get currentUser => supabaseClient.auth.currentUser;

  /// Helper method to save JWT if available
  static Future<void> _saveJwt(Session? session) async {
    if (session?.accessToken != null) {
      await LocalStorageService().write("JWT", session!.accessToken);
      print("JWT Saved: ${session.accessToken}");
    } else {
      print("No JWT found after authentication.");
    }
  }
}
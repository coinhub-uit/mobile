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

    final respond = await supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    print("${respond.session?.accessToken} token is here");
    return respond.user;
  }

  static Future<AuthResponse> signInWithEmailandPassword(
    String email,
    String password,
  ) async {
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print("${response.session?.accessToken} token is here");
    return response;
  }

  static Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  static Future<void> signUpWithEmailandPassword(
    String email,
    String password,
  ) async {
    await supabaseClient.auth.signUp(email: email, password: password);
  }

  static Future<void> forgotPassword(String email) async {
    //TODO: Implement forgot password
  }

  static Stream<AuthState> get authStateChanges =>
      supabaseClient.auth.onAuthStateChange;

  static bool isUserLoggedIn() {
    final session = supabaseClient.auth.currentSession;
    return session != null;
  }

  static bool isUserVerified() {
    final user = supabaseClient.auth.currentUser;
    return user?.emailConfirmedAt != null;
  }

  static Future<void> resendVerificationCode(String email) async {
    await supabaseClient.auth.resend(type: OtpType.signup, email: email);
  }

  static User? get currentUser => supabaseClient.auth.currentUser;
}

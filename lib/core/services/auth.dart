import "package:google_sign_in/google_sign_in.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:coinhub/core/constants/auth.dart";

class AuthService {
  static final supabaseClient = Supabase.instance.client;

  static Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
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

    await supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  static Stream<AuthState> get authStateChanges =>
      supabaseClient.auth.onAuthStateChange;
}

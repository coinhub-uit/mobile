class Env {
  static String get appName => const String.fromEnvironment("APP_NAME");
  static String get supabaseUrl => const String.fromEnvironment("SUPABASE_URL");
  static String get supabaseAnonKey =>
      const String.fromEnvironment("SUPABASE_ANON_KEY");
  static String get oauthWebClientId =>
      const String.fromEnvironment("OAUTH_WEB_CLIENT_ID");
  static String get oauthIosClientId =>
      const String.fromEnvironment("OAUTH_IOS_CLIENT_ID");
  static String get aiApiKey => const String.fromEnvironment("AI_API_KEY");
}

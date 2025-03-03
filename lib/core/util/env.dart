class Env {
  // TODO: Check if can be final?
  static String get apiServerUrl =>
      const String.fromEnvironment("API_SERVER_URL");
  static String get supabaseUrl => const String.fromEnvironment("SUPABASE_URL");
  static String get supabaseAnonKey =>
      const String.fromEnvironment("SUPABASE_ANON_KEY");
  static String get oauthWebClientId =>
      const String.fromEnvironment("OAUTH_WEB_CLIENT_ID");
  static String get oauthIosClientId =>
      const String.fromEnvironment("OAUTH_IOS_CLIENT_ID");
}

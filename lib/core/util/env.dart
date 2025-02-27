class Env {
  static String get apiServerUrl => const String.fromEnvironment(
    "API_SERVER_URL",
  ); // TODO: Check if can be final?
}

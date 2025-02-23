import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String _getEnv(String keyword) {
    final value = dotenv.env[keyword];
    if (value == null || value.isEmpty) {
      throw ArgumentError('Environment variable $keyword is not defined! Please add a .env file');
    }
    return value;
  }

  static String get appName => _getEnv('APP_NAME');
  static String get supabaseUrl => _getEnv('SUPABASE_URL');
  static String get supabaseAnonKey => _getEnv('SUPABASE_ANON_KEY');
  static String get oauthWebClientId => _getEnv('OAUTH_WEB_CLIENT_ID');
  static String get oauthIosClientId => _getEnv('OAUTH_IOS_CLIENT_ID');
  static String get aiApiKey => _getEnv('AI_API_KEY');
}
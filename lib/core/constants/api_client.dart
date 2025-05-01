import "package:coinhub/core/util/env.dart";
import "package:http/http.dart" as http;

class ApiClient {
  static final String baseUrl = Env.apiServerUrl;

  static final http.Client client = http.Client();

  static final userEndpoint = Uri.parse("$baseUrl/users");
  static final authEndpoint = Uri.parse("$baseUrl/auth");
  // more to come
}
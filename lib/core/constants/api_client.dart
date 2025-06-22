import "package:coinhub/core/util/env.dart";
import "package:http/http.dart" as http;

class ApiClient {
  static final String baseUrl = Env.apiServerUrl;

  static final http.Client client = http.Client();

  static final userEndpoint = Uri.parse("$baseUrl/users");
  static final authEndpoint = Uri.parse("$baseUrl/auth");
  static final planEndpoint = Uri.parse("$baseUrl/plans");
  static final sourceEndpoint = Uri.parse("$baseUrl/sources");
  static final ticketEndpoint = Uri.parse("$baseUrl/tickets");
  static final transferEndpoint = Uri.parse("$baseUrl/payment/transfer");
  // more to come
}

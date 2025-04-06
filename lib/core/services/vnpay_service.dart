import "dart:convert";
import "package:coinhub/core/services/local_storage.dart";
import "package:http/http.dart" as http;
import "package:coinhub/core/util/env.dart";
import "package:coinhub/core/util/ip_address.dart";

class VnpayService {
  final String baseUrl = Env.apiServerUrl;

  Future<void> generatePaymentLink({required int amount, required String sources}) async {
    String? ipAddress = await getIpAddress();
    String? jwt = await LocalStorageService().read("JWT");
    if (ipAddress == null) {
      print("Failed to get IP address =(((");
      return;
    }

    final uri = Uri.parse("$baseUrl/vnpay/create");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwt",
      },
      body: jsonEncode({
        "provider": "momo",  
        "returnUrl": "coinhub://home",
        "amount": amount, 
        "sourceDestination": sources,  
        "ipAddress": ipAddress,
      }),
    );

    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final paymentUrl = data["data"]["paymentUrl"];
      print("Payment URL: $paymentUrl");
    } else {
      print("Error: ${response.statusCode}");
    }
  }
}

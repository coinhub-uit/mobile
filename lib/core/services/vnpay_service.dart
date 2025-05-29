import "dart:convert";
import "package:coinhub/core/services/local_storage.dart";
import "package:http/http.dart" as http;
import "package:coinhub/core/util/env.dart";
import "package:coinhub/core/util/ip_address.dart";
import "package:url_launcher/url_launcher.dart";

class VnpayService {
  final String baseUrl = Env.apiServerUrl;

  Future<String?> generatePaymentLink({
    required int amount,
    required String source,
  }) async {
    String? ipAddress = await getIpAddress();
    String? jwt = await LocalStorageService().read("JWT");

    if (ipAddress == null) {
      print("Failed to get IP address =(((");
      return null;
    }

    final uri = Uri.parse("$baseUrl/payment/vnpay/create");

    try {
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
          "sourceDestinationId": source,
          "ipAddress": ipAddress,
        }),
      );

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentUrl = data["data"]["paymentUrl"];
        print("Payment URL: $paymentUrl");
        return paymentUrl;
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error creating payment: $e");
      return null;
    }
  }

  Future<bool> openPaymentWebView(String paymentUrl) async {
    try {
      final uri = Uri.parse(paymentUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      }
      return false;
    } catch (e) {
      print("Error opening web view: $e");
      return false;
    }
  }

  Future<bool> processPayment({
    required int amount,
    required String source,
  }) async {
    final paymentUrl = await generatePaymentLink(
      amount: amount,
      source: source,
    );

    if (paymentUrl != null) {
      return await openPaymentWebView(paymentUrl);
    }

    return false;
  }
}

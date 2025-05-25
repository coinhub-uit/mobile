import "dart:convert";
import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/core/services/local_storage.dart";
import "package:coinhub/models/plan_model.dart";

class PlanService {
  static Future<List<PlanModel>> fetchPlans() async {
    final accessToken = await LocalStorageService().read("JWT");
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final response = await ApiClient.client.get(
      Uri.parse("${ApiClient.planEndpoint}/available-plans"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      print("Decoded plans: $decoded");
      print("Decoded plans length: ${decoded.length}");
      return decoded.map((plan) => PlanModel.fromJson(plan)).toList();
    } else {
      throw Exception("Failed to fetch plans: ${response.statusCode}");
    }
  }
}

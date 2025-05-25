class PlanModel {
  final int planId;
  final int days;
  final double rate;

  PlanModel({required this.planId, required this.days, required this.rate});

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    print("[MODEL] Raw plan json: $json");

    return PlanModel(
      planId: json["planId"] ?? -1,
      days: json["days"] ?? 0,
      rate:
          (json["rate"] is String)
              ? double.tryParse(json["rate"]) ?? 0
              : (json["rate"] as num).toDouble(),
    );
  }

  @override
  String toString() => "PlanModel(planId: $planId, days: $days, rate: $rate)";
}

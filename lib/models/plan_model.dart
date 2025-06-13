class PlanModel {
  final int planId;
  final int days;
  final double rate;
  final int? planHistoryId;

  PlanModel({
    required this.planId,
    required this.days,
    required this.rate,
    this.planHistoryId,
  });

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      planId: map["id"] ?? map["planId"] ?? -1,
      days: map["days"] ?? 0,
      rate:
          (map["rate"] is String)
              ? double.tryParse(map["rate"]) ?? 0
              : (map["rate"] as num?)?.toDouble() ?? 0,
      planHistoryId: map["planHistoryId"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "planId": planId,
      "days": days,
      "rate": rate,
      if (planHistoryId != null) "planHistoryId": planHistoryId,
    };
  }

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      PlanModel.fromMap(json);

  @override
  String toString() =>
      "PlanModel(planId: $planId, days: $days, rate: $rate, planHistoryId: $planHistoryId)";
}

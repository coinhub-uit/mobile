class PlanModel {
  final int id;
  final int days;
  final double rate;
  final int? planHistoryId;

  PlanModel({
    required this.id,
    required this.days,
    required this.rate,
    this.planHistoryId,
  });

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'] ?? map['planId'] ?? -1,
      days: map['days'] ?? 0,
      rate:
          (map['rate'] is String)
              ? double.tryParse(map['rate']) ?? 0
              : (map['rate'] as num?)?.toDouble() ?? 0,
      planHistoryId: map['planHistoryId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'days': days,
      'rate': rate,
      if (planHistoryId != null) 'planHistoryId': planHistoryId,
    };
  }

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      PlanModel.fromMap(json);

  @override
  String toString() =>
      "PlanModel(id: $id, days: $days, rate: $rate, planHistoryId: $planHistoryId)";
}

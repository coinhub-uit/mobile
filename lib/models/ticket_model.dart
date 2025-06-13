import "dart:convert";
import "plan_model.dart";
import "ticket_history_model.dart";

class TicketModel {
  final int? id;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final String? status;
  final String method;
  final int planHistoryId;
  String sourceId;
  final int amount;
  final List<TicketHistoryModel>? ticketHistory;
  final PlanModel? plan;

  TicketModel({
    this.id,
    this.openedAt,
    this.closedAt,
    this.status,
    required this.method,
    required this.planHistoryId,
    required this.sourceId,
    required this.amount,
    this.ticketHistory,
    this.plan,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map["id"],
      openedAt:
          map["openedAt"] != null ? DateTime.parse(map["openedAt"]) : null,
      closedAt:
          map["closedAt"] != null ? DateTime.parse(map["closedAt"]) : null,
      status: map["status"],
      method: map["method"],
      planHistoryId:
          map["planHistoryId"] is int
              ? map["planHistoryId"]
              : int.tryParse(map["planHistoryId"]?.toString() ?? "0") ?? 0,
      amount:
          map["amount"] is int
              ? map["amount"]
              : int.tryParse(map["amount"]?.toString() ?? "0") ?? 0,
      sourceId: map["sourceId"]?.toString() ?? "",
      ticketHistory:
          map["ticketHistories"] != null
              ? List<TicketHistoryModel>.from(
                (map["ticketHistories"] as List).map(
                  (x) => TicketHistoryModel.fromMap(x),
                ),
              )
              : null,
      plan: map["plan"] != null ? PlanModel.fromMap(map["plan"]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "openedAt": openedAt?.toIso8601String(),
      "closedAt": closedAt?.toIso8601String(),
      "status": status,
      "method": method,
      "planHistoryId": planHistoryId,
      "sourceId": sourceId,
      "amount": amount,
      if (ticketHistory != null)
        "ticketHistories": ticketHistory!.map((x) => x.toMap()).toList(),
      if (plan != null) "plan": plan!.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
  factory TicketModel.fromJson(String source) =>
      TicketModel.fromMap(json.decode(source));

  @override
  String toString() =>
      "TicketModel(id: $id, openedAt: $openedAt, closedAt: $closedAt, status: $status, method: $method, planHistoryId: $planHistoryId, sourceId: $sourceId, amount: $amount, ticketHistory: $ticketHistory, plan: $plan)";
}

import "dart:convert";
import "package:coinhub/models/source_model.dart";

import "plan_model.dart";
import "ticket_history_model.dart";

class TicketModel {
  final int? id;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final String? status;
  final String method;
  final int planHistoryId;
  SourceModel? source;
  String sourceId; // ✅ kept and assigned from `source`
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
    this.source,
    required this.amount,
    this.ticketHistory,
    this.plan,
    this.sourceId = "",
  }); // ✅ assign sourceId automatically

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    final parsedSource =
        map["sourceId"] is Map<String, dynamic>
            ? SourceModel.fromMap(map["sourceId"])
            : SourceModel(id: map["sourceId"]?.toString() ?? "");

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
      source: parsedSource,
      ticketHistory:
          map["ticketHistories"] != null
              ? List<TicketHistoryModel>.from(
                (map["ticketHistories"] as List).map(
                  (x) => TicketHistoryModel.fromMap(x),
                ),
              )
              : null,
      plan:
          map["plan"] != null
              ? PlanModel.fromMap({
                "planId": map["plan"]["id"],
                "days": map["plan"]["days"],
                "rate": map["plan"]["planHistories"].last["rate"],
              })
              : null,
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
      "sourceId": source!.toMap(), // ✅ full object for backend
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
      "TicketModel(id: $id, openedAt: $openedAt, closedAt: $closedAt, status: $status, method: $method, planHistoryId: $planHistoryId, sourceId: $sourceId, source: $source, amount: $amount, ticketHistory: $ticketHistory, plan: $plan)";
}

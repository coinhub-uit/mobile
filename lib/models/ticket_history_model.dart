import 'dart:convert';
import 'plan_model.dart';

class TicketHistoryModel {
  final int? id;
  final DateTime? issuedAt;
  final DateTime? maturedAt;
  final double? principal;
  final double? interest;
  final int? ticketId;
  final PlanModel? plan;

  TicketHistoryModel({
    this.id,
    this.issuedAt,
    this.maturedAt,
    this.principal,
    this.interest,
    this.ticketId,
    this.plan,
  });

  factory TicketHistoryModel.fromMap(Map<String, dynamic> map) {
    return TicketHistoryModel(
      id: map['id'],
      issuedAt:
          map['issuedAt'] != null ? DateTime.parse(map['issuedAt']) : null,
      maturedAt:
          map['maturedAt'] != null ? DateTime.parse(map['maturedAt']) : null,
      principal:
          (map['principal'] is String)
              ? double.tryParse(map['principal']) ?? 0
              : (map['principal'] as num?)?.toDouble(),
      interest:
          (map['interest'] is String)
              ? double.tryParse(map['interest']) ?? 0
              : (map['interest'] as num?)?.toDouble(),
      ticketId: map['ticketId'],
      plan: map['plan'] != null ? PlanModel.fromMap(map['plan']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'issuedAt': issuedAt?.toIso8601String(),
      'maturedAt': maturedAt?.toIso8601String(),
      'principal': principal,
      'interest': interest,
      'ticketId': ticketId,
      'plan': plan?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
  factory TicketHistoryModel.fromJson(String source) =>
      TicketHistoryModel.fromMap(json.decode(source));
  @override
  String toString() =>
      "TicketHistoryModel(issuedAt: $issuedAt, maturedAt: $maturedAt, principal: $principal, interest: $interest)";
}

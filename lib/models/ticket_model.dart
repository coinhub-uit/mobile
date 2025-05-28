// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TicketModel {
  final int? id;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final String? status;
  final String method;
  final int planHistoryId;
  final String sourceId;
  final int amount;
  TicketModel({
    this.id,
    this.openedAt,
    this.closedAt,
    this.status,
    required this.method,
    required this.planHistoryId,
    required this.sourceId,
    required this.amount,
  });

  TicketModel copyWith({
    int? id,
    DateTime? openedAt,
    DateTime? closedAt,
    String? status,
    String? method,
    int? planHistoryId,
    String? sourceId,
    int? amount,
  }) {
    return TicketModel(
      id: id ?? this.id,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      status: status ?? this.status,
      method: method ?? this.method,
      planHistoryId: planHistoryId ?? this.planHistoryId,
      sourceId: sourceId ?? this.sourceId,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'openedAt': openedAt?.millisecondsSinceEpoch,
      'closedAt': closedAt?.millisecondsSinceEpoch,
      'status': status,
      'method': method,
      'planHistoryId': planHistoryId,
      'sourceId': sourceId,
      'amount': amount,
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] != null ? map['id'] as int : null,
      openedAt:
          map['openedAt'] != null ? DateTime.parse(map['openedAt']) : null,
      closedAt:
          map['closedAt'] != null ? DateTime.parse(map['closedAt']) : null,
      status: map['status'] != null ? map['status'] as String : null,
      method: map['method'] as String,
      planHistoryId:
          map['planHistoryId'] != null ? map['planHistoryId'] as int : 0,

      sourceId: map['sourceId']?.toString() ?? '',

      amount: map['amount'] is int ? map['amount'] : 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketModel.fromJson(String source) =>
      TicketModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TicketModel(id: $id, openedAt: $openedAt, closedAt: $closedAt, status: $status, method: $method, planHistoryId: $planHistoryId, sourceId: $sourceId, amount: $amount)';
  }

  @override
  bool operator ==(covariant TicketModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.openedAt == openedAt &&
        other.closedAt == closedAt &&
        other.status == status &&
        other.method == method &&
        other.planHistoryId == planHistoryId &&
        other.sourceId == sourceId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        openedAt.hashCode ^
        closedAt.hashCode ^
        status.hashCode ^
        method.hashCode ^
        planHistoryId.hashCode ^
        sourceId.hashCode ^
        amount.hashCode;
  }
}

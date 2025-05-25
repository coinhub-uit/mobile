// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TicketModel {
  final String id;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final String status;
  final String method;
  final int planId;
  final String sourceId;
  TicketModel({
    required this.id,
    this.openedAt,
    this.closedAt,
    required this.status,
    required this.method,
    required this.planId,
    required this.sourceId,
  });

  TicketModel copyWith({
    String? id,
    DateTime? openedAt,
    DateTime? closedAt,
    String? status,
    String? method,
    int? planId,
    String? sourceId,
  }) {
    return TicketModel(
      id: id ?? this.id,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      status: status ?? this.status,
      method: method ?? this.method,
      planId: planId ?? this.planId,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'openedAt': openedAt?.millisecondsSinceEpoch,
      'closedAt': closedAt?.millisecondsSinceEpoch,
      'status': status,
      'method': method,
      'planId': planId,
      'sourceId': sourceId,
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] as String,
      openedAt:
          map['openedAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['openedAt'] as int)
              : null,
      closedAt:
          map['closedAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['closedAt'] as int)
              : null,
      status: map['status'] as String,
      method: map['method'] as String,
      planId: map['planId'] as int,
      sourceId: map['sourceId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketModel.fromJson(String source) =>
      TicketModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TicketModel(id: $id, openedAt: $openedAt, closedAt: $closedAt, status: $status, method: $method, planId: $planId, sourceId: $sourceId)';
  }

  @override
  bool operator ==(covariant TicketModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.openedAt == openedAt &&
        other.closedAt == closedAt &&
        other.status == status &&
        other.method == method &&
        other.planId == planId &&
        other.sourceId == sourceId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        openedAt.hashCode ^
        closedAt.hashCode ^
        status.hashCode ^
        method.hashCode ^
        planId.hashCode ^
        sourceId.hashCode;
  }
}

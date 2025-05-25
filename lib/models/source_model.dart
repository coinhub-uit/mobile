// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SourceModel {
  final String id;
  final String balance;
  final String userId;
  SourceModel({required this.id, required this.balance, required this.userId});

  SourceModel copyWith({String? id, String? balance, String? userId}) {
    return SourceModel(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'balance': balance, 'userId': userId};
  }

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(
      id: map['id'] as String,
      balance: map['balance'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SourceModel.fromJson(String source) =>
      SourceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SourceModel(id: $id, balance: $balance, userId: $userId)';

  @override
  bool operator ==(covariant SourceModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.balance == balance && other.userId == userId;
  }

  @override
  int get hashCode => id.hashCode ^ balance.hashCode ^ userId.hashCode;
}

import "dart:convert";

class SourceModel {
  final String id;
  final String? balance;
  final String? userId;

  SourceModel({required this.id, this.balance, this.userId});

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(
      id: map['id'] ?? '',
      balance: map['balance']?.toString(),
      userId: map['userId']?.toString(),
    );
  }

  /// This is what your fetch function is using!
  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      SourceModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {'id': id, 'balance': balance, 'userId': userId};
  }

  String toJson() => jsonEncode(toMap());
}

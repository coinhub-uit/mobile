import "dart:convert";

class DepositTopUpResponse {
  final String url;
  final String topUpId;

  DepositTopUpResponse({required this.url, required this.topUpId});

  factory DepositTopUpResponse.fromMap(Map<String, dynamic> map) {
    return DepositTopUpResponse(
      url: map["url"] ?? "",
      topUpId: map["topUpId"] ?? "",
    );
  }

  factory DepositTopUpResponse.fromJson(Map<String, dynamic> json) =>
      DepositTopUpResponse.fromMap(json);

  Map<String, dynamic> toMap() {
    return {"url": url, "topUpId": topUpId};
  }

  String toJson() => jsonEncode(toMap());
}

class DepositStatusResponse {
  final String id;
  final String provider;
  final String amount;
  final String status;
  final String createdAt;

  DepositStatusResponse({
    required this.id,
    required this.provider,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory DepositStatusResponse.fromMap(Map<String, dynamic> map) {
    return DepositStatusResponse(
      id: map["id"] ?? "",
      provider: map["provider"] ?? "",
      amount: map["amount"] ?? "",
      status: map["status"] ?? "",
      createdAt: map["createdAt"] ?? "",
    );
  }

  factory DepositStatusResponse.fromJson(Map<String, dynamic> json) =>
      DepositStatusResponse.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "provider": provider,
      "amount": amount,
      "status": status,
      "createdAt": createdAt,
    };
  }

  String toJson() => jsonEncode(toMap());
}

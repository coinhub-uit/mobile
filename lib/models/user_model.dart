// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

class UserModel {
  final String id; // supabase based
  String fullName;
  String birthDate;
  String? avatar;
  String citizenId;
  String? address;
  DateTime? createdAt;
  DateTime? deletedAt;
  UserModel({
    required this.id,
    required this.fullName,
    required this.birthDate,
    this.avatar,
    required this.citizenId,
    this.address,
    this.createdAt,
    this.deletedAt,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? birthDate,
    String? avatar,
    String? citizenId,
    String? address,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
      citizenId: citizenId ?? this.citizenId,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "birthDate": birthDate,
      "avatar": avatar,
      "citizenId": citizenId,
      "address": address,
      "createdAt": createdAt?.millisecondsSinceEpoch,
      "deletedAt": deletedAt?.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toMapForRequest() {
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "birthDate": birthDate,
      "avatar": avatar,
      "citizenId": citizenId,
      "address": address,
    };
  }

  String toJsonForRequest() => json.encode(toMapForRequest());

  factory UserModel.fromMap(Map<String, dynamic> map) {
    // Validate required fields
    final id = map["id"]?.toString();
    // Handle both "fullName" (backend) and "fullname" (legacy) field names
    var fullName = map["fullName"]?.toString() ?? map["fullname"]?.toString();
    final birthDate = map["birthDate"]?.toString();
    final citizenId = map["citizenId"]?.toString();

    if (id == null || id.isEmpty) {
      throw Exception("User ID is required but was null or empty");
    }
    if (fullName == null || fullName.isEmpty) {
      throw Exception("Full name is required but was null or empty");
    }
    if (birthDate == null || birthDate.isEmpty) {
      throw Exception("Birth date is required but was null or empty");
    }
    if (citizenId == null || citizenId.isEmpty) {
      throw Exception("Citizen ID is required but was null or empty");
    }

    return UserModel(
      id: id,
      fullName: fullName,
      birthDate: birthDate,
      avatar: map["avatar"] != null ? map["avatar"] as String : null,
      citizenId: citizenId,
      address: map["address"] != null ? map["address"] as String : null,
      createdAt:
          map["createdAt"] != null ? DateTime.parse(map["createdAt"]) : null,
      deletedAt:
          map["deletedAt"] != null ? DateTime.parse(map["deletedAt"]) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return "UserModel(id: $id, fullName: $fullName, birthDate: $birthDate, avatar: $avatar, citizenId: $citizenId, address: $address,createdAt: $createdAt, deletedAt: $deletedAt)";
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.birthDate == birthDate &&
        other.avatar == avatar &&
        other.citizenId == citizenId &&
        other.address == address &&
        other.createdAt == createdAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        birthDate.hashCode ^
        avatar.hashCode ^
        citizenId.hashCode ^
        address.hashCode ^
        createdAt.hashCode ^
        deletedAt.hashCode;
  }
}

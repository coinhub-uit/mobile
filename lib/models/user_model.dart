// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

class UserModel {
  final String id; // supabase based
  String fullname;
  String birthDate;
  String? avatar;
  String citizenId;
  String? address;
  DateTime? createdAt;
  DateTime? deletedAt;
  UserModel({
    required this.id,
    required this.fullname,
    required this.birthDate,
    this.avatar,
    required this.citizenId,
    this.address,
    this.createdAt,
    this.deletedAt,
  });

  UserModel copyWith({
    String? id,
    String? fullname,
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
      fullname: fullname ?? this.fullname,
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
      "fullname": fullname,
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
      "fullname": fullname,
      "birthDate": birthDate,
      "avatar": avatar,
      "citizenId": citizenId,
      "address": address,
    };
  }

  String toJsonForRequest() => json.encode(toMapForRequest());

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"] as String,
      fullname: map["fullname"] as String,
      birthDate: map["birthDate"] as String,
      avatar: map["avatar"] != null ? map["avatar"] as String : null,
      citizenId: map["citizenId"] as String,
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
    return "UserModel(id: $id, fullname: $fullname, birthDate: $birthDate, avatar: $avatar, citizenId: $citizenId, address: $address,createdAt: $createdAt, deletedAt: $deletedAt)";
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullname == fullname &&
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
        fullname.hashCode ^
        birthDate.hashCode ^
        avatar.hashCode ^
        citizenId.hashCode ^
        address.hashCode ^
        createdAt.hashCode ^
        deletedAt.hashCode;
  }
}

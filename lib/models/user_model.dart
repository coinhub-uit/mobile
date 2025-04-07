// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";

class UserModel {
  final String id; // supabase based
  String fullName;
  DateTime birthDay;
  String? avatar;
  String citizenId;
  String? address;
  String? phoneNumber;
  DateTime createdAt;
  DateTime? deleteddAt;
  UserModel({
    required this.id,
    required this.fullName,
    required this.birthDay,
    this.avatar,
    required this.citizenId,
    this.address,
    this.phoneNumber,
    required this.createdAt,
    this.deleteddAt,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    DateTime? birthDay,
    String? avatar,
    String? citizenId,
    String? address,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? deleteddAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      birthDay: birthDay ?? this.birthDay,
      avatar: avatar ?? this.avatar,
      citizenId: citizenId ?? this.citizenId,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      deleteddAt: deleteddAt ?? this.deleteddAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'birthDay': birthDay.millisecondsSinceEpoch,
      'avatar': avatar,
      'citizenId': citizenId,
      'address': address,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'deleteddAt': deleteddAt?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      birthDay: DateTime.fromMillisecondsSinceEpoch(map['birthDay'] as int),
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      citizenId: map['citizenId'] as String,
      address: map['address'] != null ? map['address'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      deleteddAt:
          map['deleteddAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['deleteddAt'] as int)
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, birthDay: $birthDay, avatar: $avatar, citizenId: $citizenId, address: $address, phoneNumber: $phoneNumber, createdAt: $createdAt, deleteddAt: $deleteddAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.birthDay == birthDay &&
        other.avatar == avatar &&
        other.citizenId == citizenId &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        other.createdAt == createdAt &&
        other.deleteddAt == deleteddAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        birthDay.hashCode ^
        avatar.hashCode ^
        citizenId.hashCode ^
        address.hashCode ^
        phoneNumber.hashCode ^
        createdAt.hashCode ^
        deleteddAt.hashCode;
  }
}

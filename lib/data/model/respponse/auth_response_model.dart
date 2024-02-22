import 'dart:convert';

class AuthResponseModel {
  final User user;
  final String token;

  AuthResponseModel({
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException("Invalid JSON");
    }

    return AuthResponseModel(
      user: User.fromMap(json["user"] as Map<String, dynamic>?),
      token: json["token"] as String? ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "user": user.toMap(),
        "token": token,
      };
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String roles;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      throw FormatException("Invalid JSON");
    }

    return User(
      id: json["id"] as int? ?? 0,
      name: json["name"] as String? ?? "",
      email: json["email"] as String? ?? "",
      phone: json["phone"] as String? ?? "",
      roles: json["roles"] as String? ?? "",
      createdAt: DateTime.parse(json["created_at"] as String? ?? ""),
      updatedAt: DateTime.parse(json["updated_at"] as String? ?? ""),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "roles": roles,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

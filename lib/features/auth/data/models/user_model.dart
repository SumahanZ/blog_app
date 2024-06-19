// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:blog_app/core/common/entities/user.dart';

class UserModel {
  final String id;

  final String email;

  final String? token;

  final String name;
  UserModel({
    required this.id,
    required this.email,
    this.token,
    required this.name,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? token,
    String? name,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      token: token ?? this.token,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'email': email,
      'token': token,
      'username': name,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      token: token,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? "",
      email: map['email'] ?? "",
      token: map['token'] ?? "",
      name: map['username'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(_id: $id, email: $email, token: $token, username: $name)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.token == token &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ token.hashCode ^ name.hashCode;
  }
}

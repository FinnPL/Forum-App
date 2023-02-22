// To parse this JSON data, do
//
//     final auth = authFromJson(jsonString);

import 'dart:convert';

Auth authFromJson(String str) => Auth.fromJson(json.decode(str));

String authToJson(Auth data) => json.encode(data.toJson());

class Auth {
  Auth({
    this.userName,
    this.password,
  });

  String? userName;
  String? password;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        userName: json["user_name"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "password": password,
      };
}

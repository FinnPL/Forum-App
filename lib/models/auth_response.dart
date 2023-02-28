// To parse this JSON data, do
//
//     final authResponse = authResponseFromJson(jsonString);

import 'dart:convert';

AuthResponse authResponseFromJson(String str) => AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  AuthResponse({
    required this.token,
    required this.userId,
  });

  String token;
  String userId;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json["token"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user_id": userId,
  };
}

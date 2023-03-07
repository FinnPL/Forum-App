// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
    required this.userName,
    required this.id,
    this.bio,
  });

  String userName;
  String id;
  dynamic bio;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    userName: json["user_name"],
    id: json["id"],
    bio: json["bio"],
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
    "id": id,
    "bio": bio,
  };
}

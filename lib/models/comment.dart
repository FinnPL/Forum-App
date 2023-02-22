// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  Comment({
    required this.id,
    required this.content,
    required this.userId,
    required this.userName,
    required this.date,
  });

  String id;
  String content;
  String userId;
  String userName;
  DateTime date;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    content: json["content"],
    userId: json["user_id"],
    userName: json["user_name"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "user_id": userId,
    "user_name": userName,
    "date": date.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final commentRequest = commentRequestFromJson(jsonString);
CommentRequest commentRequestFromJson(String str) => CommentRequest.fromJson(json.decode(str));

String commentRequestToJson(CommentRequest data) => json.encode(data.toJson());

class CommentRequest {
  CommentRequest({
    required this.content,
    required this.postId,
  });

  String content;
  String postId;

  factory CommentRequest.fromJson(Map<String, dynamic> json) => CommentRequest(
    content: json["content"],
    postId: json["post_id"],
  );

  Map<String, dynamic> toJson() => {
    "content": content,
    "post_id": postId,
  };
}

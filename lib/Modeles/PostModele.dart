import 'dart:convert';

import 'package:blog_post/Modeles/UserModele.dart';

PostModele postModeleFromJson(String str) =>
    PostModele.fromJson(json.decode(str));

String postModeleToJson(PostModele data) => json.encode(data.toJson());

class PostModele {
  PostModele({
    this.id,
    this.body,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.user,
    this.selfLiked,
  });

  int? id;
  String? body;
  String? image;
  int? likesCount;
  int? commentsCount;
  UserModele? user;
  bool? selfLiked;

  factory PostModele.fromJson(Map<String, dynamic> json) => PostModele(
      id: json["id"],
      body: json["body"],
      image: json["image"],
      likesCount: json["likes_Count"],
      commentsCount: json["comments_Count"],
      selfLiked: json["likes"].length > 0,
      user: UserModele(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
      ));

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "image": image,
        "likesCount": likesCount,
        "commentsCount": commentsCount,
        "user": user,
        "selfLiked": selfLiked,
      };
}

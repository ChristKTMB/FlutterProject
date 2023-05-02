import 'dart:convert';

UserModele userModeleFromJson(String str) => UserModele.fromJson(json.decode(str));

String userModeleToJson(UserModele data) => json.encode(data.toJson());

class UserModele {
  UserModele({
    this.id,
    this.name,
    this.image,
    this.email,
    this.token
  });

  int? id;
  String? name;
  String? image;
  String? email;
  String? token;

  factory UserModele.fromJson(Map<String, dynamic> json) => UserModele(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    email: json["email"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "email": email,
    "token": token,
  };
}
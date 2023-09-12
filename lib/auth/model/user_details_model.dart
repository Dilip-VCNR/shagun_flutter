// To parse this JSON data, do
//
//     final userDetailsModel = userDetailsModelFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
  bool? status;
  String? token;
  User? user;

  UserDetailsModel({
    this.status,
    this.token,
    this.user,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
    status: json["status"],
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "token": token,
    "user": user?.toJson(),
  };
}

class User {
  String? name;
  String? email;
  String? phone;
  int? kyc;
  String? profile;
  String? userId;
  DateTime? createdOn;

  User({
    this.name,
    this.email,
    this.phone,
    this.kyc,
    this.profile,
    this.userId,
    this.createdOn,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    kyc: json["Kyc"],
    profile: json["profile"],
    userId: json["user_id"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "Kyc": kyc,
    "profile": profile,
    "user_id": userId,
    "created_on": createdOn?.toIso8601String(),
  };
}

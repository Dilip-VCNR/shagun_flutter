// To parse this JSON data, do
//
//     final searchDataModel = searchDataModelFromJson(jsonString);

import 'dart:convert';

SearchDataModel searchDataModelFromJson(String str) => SearchDataModel.fromJson(json.decode(str));

String searchDataModelToJson(SearchDataModel data) => json.encode(data.toJson());

class SearchDataModel {
  bool? status;
  List<User>? user;

  SearchDataModel({
    this.status,
    this.user,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) => SearchDataModel(
    status: json["status"],
    user: json["user"] == null ? [] : List<User>.from(json["user"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x.toJson())),
  };
}

class User {
  int? id;
  String? uid;
  String? name;
  String? phone;
  String? profilePic;

  User({
    this.id,
    this.uid,
    this.name,
    this.phone,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    uid: json["uid"],
    name: json["name"],
    phone: json["phone"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "name": name,
    "phone": phone,
    "profile_pic": profilePic,
  };
}

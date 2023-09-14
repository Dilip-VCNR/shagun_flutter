// To parse this JSON data, do
//
//     final notificationDataModel = notificationDataModelFromJson(jsonString);

import 'dart:convert';

NotificationDataModel notificationDataModelFromJson(String str) => NotificationDataModel.fromJson(json.decode(str));

String notificationDataModelToJson(NotificationDataModel data) => json.encode(data.toJson());

class NotificationDataModel {
  List<NotificationList>? notificationList;

  NotificationDataModel({
    this.notificationList,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) => NotificationDataModel(
    notificationList: json["notification_list"] == null ? [] : List<NotificationList>.from(json["notification_list"]!.map((x) => NotificationList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notification_list": notificationList == null ? [] : List<dynamic>.from(notificationList!.map((x) => x.toJson())),
  };
}

class NotificationList {
  int? id;
  String? uid;
  int? type;
  String? title;
  String? message;
  DateTime? createdOn;

  NotificationList({
    this.id,
    this.uid,
    this.type,
    this.title,
    this.message,
    this.createdOn,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    id: json["id"],
    uid: json["uid"],
    type: json["type"],
    title: json["title"],
    message: json["message"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "type": type,
    "title": title,
    "message": message,
    "created_on": createdOn?.toIso8601String(),
  };
}

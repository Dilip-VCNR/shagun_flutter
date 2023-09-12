// To parse this JSON data, do
//
//     final allInvitesDataModel = allInvitesDataModelFromJson(jsonString);

import 'dart:convert';

AllInvitesDataModel allInvitesDataModelFromJson(String str) => AllInvitesDataModel.fromJson(json.decode(str));

String allInvitesDataModelToJson(AllInvitesDataModel data) => json.encode(data.toJson());

class AllInvitesDataModel {
  List<InvitedList>? invitedList;

  AllInvitesDataModel({
    this.invitedList,
  });

  factory AllInvitesDataModel.fromJson(Map<String, dynamic> json) => AllInvitesDataModel(
    invitedList: json["invited_list"] == null ? [] : List<InvitedList>.from(json["invited_list"]!.map((x) => InvitedList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "invited_list": invitedList == null ? [] : List<dynamic>.from(invitedList!.map((x) => x.toJson())),
  };
}

class InvitedList {
  String? eventName;
  DateTime? eventDate;
  int? eventId;
  int? isGifted;
  List<EventAdmin>? eventAdmins;
  String? invitedBy;

  InvitedList({
    this.eventName,
    this.eventDate,
    this.eventId,
    this.isGifted,
    this.eventAdmins,
    this.invitedBy,
  });

  factory InvitedList.fromJson(Map<String, dynamic> json) => InvitedList(
    eventName: json["event_name"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventId: json["event_id"],
    isGifted: json["is_gifted"],
    eventAdmins: json["event_admins"] == null ? [] : List<EventAdmin>.from(json["event_admins"]!.map((x) => EventAdmin.fromJson(x))),
    invitedBy: json["invited_by"],
  );

  Map<String, dynamic> toJson() => {
    "event_name": eventName,
    "event_date": eventDate?.toIso8601String(),
    "event_id": eventId,
    "is_gifted": isGifted,
    "event_admins": eventAdmins == null ? [] : List<dynamic>.from(eventAdmins!.map((x) => x.toJson())),
    "invited_by": invitedBy,
  };
}

class EventAdmin {
  String? name;
  String? role;
  String? uid;
  String? profile;
  String? qrCode;

  EventAdmin({
    this.name,
    this.role,
    this.uid,
    this.profile,
    this.qrCode,
  });

  factory EventAdmin.fromJson(Map<String, dynamic> json) => EventAdmin(
    name: json["name"],
    role: json["role"],
    uid: json["uid"],
    profile: json["profile"],
    qrCode: json["qr_code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "uid": uid,
    "profile": profile,
    "qr_code": qrCode,
  };
}

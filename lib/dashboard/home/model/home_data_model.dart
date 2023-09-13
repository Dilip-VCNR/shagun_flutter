// To parse this JSON data, do
//
//     final homeDataModel = homeDataModelFromJson(jsonString);

import 'dart:convert';

HomeDataModel homeDataModelFromJson(String str) => HomeDataModel.fromJson(json.decode(str));

String homeDataModelToJson(HomeDataModel data) => json.encode(data.toJson());

class HomeDataModel {
  bool? status;
  int? kycStatus;
  double? totalSentAmount;
  double? totalReceivedAmount;
  List<EventsInviteList>? eventsInviteList;
  bool? isActiveKycRequest;

  HomeDataModel({
    this.status,
    this.kycStatus,
    this.totalSentAmount,
    this.totalReceivedAmount,
    this.eventsInviteList,
    this.isActiveKycRequest
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
    status: json["status"],
    kycStatus: json["kyc_status"],
    totalSentAmount: json["total_sent_amount"].toDouble(),
    totalReceivedAmount: json["total_recieved_amount"]?.toDouble(),
    eventsInviteList: json["events_invite_list"] == null ? [] : List<EventsInviteList>.from(json["events_invite_list"]!.map((x) => EventsInviteList.fromJson(x))),
    isActiveKycRequest: json['is_active_kyc_request']
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "kyc_status": kycStatus,
    "total_sent_amount": totalSentAmount,
    "total_recieved_amount": totalReceivedAmount,
    "events_invite_list": eventsInviteList == null ? [] : List<dynamic>.from(eventsInviteList!.map((x) => x.toJson())),
    "is_active_kyc_request":isActiveKycRequest
  };
}

class EventsInviteList {
  String? eventName;
  DateTime? eventDate;
  int? eventId;
  int? isGifted;
  String? invitedBy;
  String? invitedByName;
  String? invitedByProfilePic;
  List<EventAdmin>? eventAdmins;

  EventsInviteList({
    this.eventName,
    this.eventDate,
    this.eventId,
    this.isGifted,
    this.invitedBy,
    this.invitedByName,
    this.invitedByProfilePic,
    this.eventAdmins,
  });

  factory EventsInviteList.fromJson(Map<String, dynamic> json) => EventsInviteList(
    eventName: json["event_name"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventId: json["event_id"],
    isGifted: json["is_gifted"],
    invitedBy: json["invited_by"],
    invitedByName: json["invited_by_name"],
    invitedByProfilePic: json["invited_by_profile"],
    eventAdmins: json["event_admins"] == null ? [] : List<EventAdmin>.from(json["event_admins"]!.map((x) => EventAdmin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "event_name": eventName,
    "event_date": eventDate?.toIso8601String(),
    "event_id": eventId,
    "is_gifted": isGifted,
    "invited_by": invitedBy,
    "invited_by_name": invitedByName,
    "invited_by_profile": invitedByProfilePic,
    "event_admins": eventAdmins == null ? [] : List<dynamic>.from(eventAdmins!.map((x) => x.toJson())),
  };
}

class EventAdmin {
  String? name;
  String? role;
  String? profile;
  String? qrCode;

  EventAdmin({
    this.name,
    this.role,
    this.profile,
    this.qrCode,
  });

  factory EventAdmin.fromJson(Map<String, dynamic> json) => EventAdmin(
    name: json["name"],
    role: json["role"],
    profile: json["profile"],
    qrCode: json["qr_code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "profile": profile,
    "qr_code": qrCode,
  };
}

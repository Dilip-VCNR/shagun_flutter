// To parse this JSON data, do
//
//     final eventsScreenModel = eventsScreenModelFromJson(jsonString);

import 'dart:convert';

EventsScreenModel eventsScreenModelFromJson(String str) => EventsScreenModel.fromJson(json.decode(str));

String eventsScreenModelToJson(EventsScreenModel data) => json.encode(data.toJson());

class EventsScreenModel {
  bool? status;
  List<EventS>? myEvents;
  List<InvitedEvent>? invitedEvents;
  List<EventTypeList>? eventTypeList;

  EventsScreenModel({
    this.status,
    this.myEvents,
    this.invitedEvents,
    this.eventTypeList,
  });

  factory EventsScreenModel.fromJson(Map<String, dynamic> json) => EventsScreenModel(
    status: json["status"],
    myEvents: json["my_events"] == null ? [] : List<EventS>.from(json["my_events"]!.map((x) => EventS.fromJson(x))),
    invitedEvents: json["invited_events"] == null ? [] : List<InvitedEvent>.from(json["invited_events"]!.map((x) => InvitedEvent.fromJson(x))),
    eventTypeList: json["event_type_list"] == null ? [] : List<EventTypeList>.from(json["event_type_list"]!.map((x) => EventTypeList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "my_events": myEvents == null ? [] : List<dynamic>.from(myEvents!.map((x) => x.toJson())),
    "invited_events": invitedEvents == null ? [] : List<dynamic>.from(invitedEvents!.map((x) => x.toJson())),
    "event_type_list": eventTypeList == null ? [] : List<dynamic>.from(eventTypeList!.map((x) => x.toJson())),
  };
}

class EventTypeList {
  int? id;
  String? eventTypeName;

  EventTypeList({
    this.id,
    this.eventTypeName,
  });

  factory EventTypeList.fromJson(Map<String, dynamic> json) => EventTypeList(
    id: json["id"],
    eventTypeName: json["event_type_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_type_name": eventTypeName,
  };
}

class InvitedEvent {
  String? eventName;
  DateTime? eventDate;
  int? eventId;
  int? isGifted;
  String? invitedBy;
  String? invitedByName;
  String? invitedByProfilePic;
  List<Admin>? eventAdmins;

  InvitedEvent({
    this.eventName,
    this.eventDate,
    this.eventId,
    this.isGifted,
    this.invitedBy,
    this.invitedByName,
    this.invitedByProfilePic,
    this.eventAdmins,
  });

  factory InvitedEvent.fromJson(Map<String, dynamic> json) => InvitedEvent(
    eventName: json["event_name"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventId: json["event_id"],
    isGifted: json["is_gifted"],
    invitedBy: json["invited_by"],
    invitedByName: json["invited_by_name"],
    invitedByProfilePic: json["invited_by_profile"],
    eventAdmins: json["event_admins"] == null ? [] : List<Admin>.from(json["event_admins"]!.map((x) => Admin.fromJson(x))),
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

class Admin {
  String? name;
  String? role;
  String? uid;
  String? profile;
  String? qrCode;

  Admin({
    this.name,
    this.role,
    this.uid,
    this.profile,
    this.qrCode,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
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

class EventS {
  DateTime? eventDate;
  String? eventName;
  List<Admin>? admins;
  int? eventId;
  int? isApproved;
  int? status;
  dynamic totalRecievedAmount;
  dynamic totalSendersCount;

  EventS({
    this.eventDate,
    this.eventName,
    this.admins,
    this.eventId,
    this.isApproved,
    this.status,
    this.totalRecievedAmount,
    this.totalSendersCount,
  });

  factory EventS.fromJson(Map<String, dynamic> json) => EventS(
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventName: json["event_name"],
    admins: json["admins"] == null ? [] : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
    eventId: json["event_id"],
    isApproved: json["is_approved"],
    status: json["status"],
    totalRecievedAmount: json["total_recieved_amount"] ?? 0.0,
    totalSendersCount: json["total_senders_count"]?? 0,
  );

  Map<String, dynamic> toJson() => {
    "event_date": eventDate?.toIso8601String(),
    "event_name": eventName,
    "admins": admins == null ? [] : List<dynamic>.from(admins!.map((x) => x.toJson())),
    "event_id": eventId,
    "is_approved": isApproved,
    "status": status,
    "total_recieved_amount": totalRecievedAmount,
    "total_senders_count": totalSendersCount,
  };
}

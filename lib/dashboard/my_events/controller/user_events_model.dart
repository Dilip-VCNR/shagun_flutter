// To parse this JSON data, do
//
//     final userEventsDataModel = userEventsDataModelFromJson(jsonString);

import 'dart:convert';

UserEventsDataModel userEventsDataModelFromJson(String str) => UserEventsDataModel.fromJson(json.decode(str));

String userEventsDataModelToJson(UserEventsDataModel data) => json.encode(data.toJson());

class UserEventsDataModel {
  bool? status;
  List<UpcomingEvent>? upcomingEvents;

  UserEventsDataModel({
    this.status,
    this.upcomingEvents,
  });

  factory UserEventsDataModel.fromJson(Map<String, dynamic> json) => UserEventsDataModel(
    status: json["status"],
    upcomingEvents: json["upcoming_events"] == null ? [] : List<UpcomingEvent>.from(json["upcoming_events"]!.map((x) => UpcomingEvent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "upcoming_events": upcomingEvents == null ? [] : List<dynamic>.from(upcomingEvents!.map((x) => x.toJson())),
  };
}

class UpcomingEvent {
  DateTime? eventDate;
  String? eventName;
  List<Admin>? admins;
  int? eventId;
  int? isApproved;
  int? status;
  String? phone;

  UpcomingEvent({
    this.eventDate,
    this.eventName,
    this.admins,
    this.eventId,
    this.isApproved,
    this.status,
    this.phone,
  });

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) => UpcomingEvent(
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventName: json["event_name"],
    admins: json["admins"] == null ? [] : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
    eventId: json["event_id"],
    isApproved: json["is_approved"],
    status: json["status"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "event_date": eventDate?.toIso8601String(),
    "event_name": eventName,
    "admins": admins == null ? [] : List<dynamic>.from(admins!.map((x) => x.toJson())),
    "event_id": eventId,
    "is_approved": isApproved,
    "status": status,
    "phone": phone,
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

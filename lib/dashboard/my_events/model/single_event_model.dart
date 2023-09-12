// To parse this JSON data, do
//
//     final singleEventDataModel = singleEventDataModelFromJson(jsonString);

import 'dart:convert';

SingleEventDataModel singleEventDataModelFromJson(String str) => SingleEventDataModel.fromJson(json.decode(str));

String singleEventDataModelToJson(SingleEventDataModel data) => json.encode(data.toJson());

class SingleEventDataModel {
  bool? status;
  Event? event;

  SingleEventDataModel({
    this.status,
    this.event,
  });

  factory SingleEventDataModel.fromJson(Map<String, dynamic> json) => SingleEventDataModel(
    status: json["status"],
    event: json["event"] == null ? null : Event.fromJson(json["event"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "event": event?.toJson(),
  };
}

class Event {
  DateTime? eventDate;
  String? eventNote;
  String? addressLine1;
  String? addressLine2;
  String? eventLatLng;
  String? eventType;
  String? uid;
  String? name;
  double? deliveryFee;
  int? eventId;
  List<Admin>? admins;
  List<SubEvent>? subEvents;

  Event({
    this.eventDate,
    this.eventNote,
    this.addressLine1,
    this.addressLine2,
    this.eventLatLng,
    this.eventType,
    this.uid,
    this.name,
    this.deliveryFee,
    this.eventId,
    this.admins,
    this.subEvents,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventNote: json["event_note"],
    addressLine1: json["address_line1"],
    addressLine2: json["address_line2"],
    eventLatLng: json["event_lat_lng"],
    eventType: json["event_type"],
    uid: json["uid"],
    name: json["name"],
    deliveryFee: json["delivery_fee"],
    eventId: json["event_id"],
    admins: json["admins"] == null ? [] : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
    subEvents: json["sub_events"] == null ? [] : List<SubEvent>.from(json["sub_events"]!.map((x) => SubEvent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "event_date": eventDate?.toIso8601String(),
    "event_note": eventNote,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "event_lat_lng": eventLatLng,
    "event_type": eventType,
    "uid": uid,
    "name": name,
    "delivery_fee": deliveryFee,
    "event_id": eventId,
    "admins": admins == null ? [] : List<dynamic>.from(admins!.map((x) => x.toJson())),
    "sub_events": subEvents == null ? [] : List<dynamic>.from(subEvents!.map((x) => x.toJson())),
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

class SubEvent {
  String? subEventName;
  String? startTime;
  String? endTime;

  SubEvent({
    this.subEventName,
    this.startTime,
    this.endTime,
  });

  factory SubEvent.fromJson(Map<String, dynamic> json) => SubEvent(
    subEventName: json["sub_event_name"],
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "sub_event_name": subEventName,
    "start_time": startTime,
    "end_time": endTime,
  };
}

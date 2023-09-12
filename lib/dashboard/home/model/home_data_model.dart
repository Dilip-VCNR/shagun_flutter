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
  double? totalRecievedAmount;
  List<TransactionSentList>? transactionSentList;
  List<TransactionRecievedList>? transactionRecievedList;
  List<EventsInviteList>? eventsInviteList;
  String? randomQuote;

  HomeDataModel({
    this.status,
    this.kycStatus,
    this.totalSentAmount,
    this.totalRecievedAmount,
    this.transactionSentList,
    this.transactionRecievedList,
    this.eventsInviteList,
    this.randomQuote,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
    status: json["status"],
    kycStatus: json["kyc_status"],
    totalSentAmount: json["total_sent_amount"].toDouble(),
    totalRecievedAmount: json["total_recieved_amount"]?.toDouble(),
    transactionSentList: json["transaction_sent_list"] == null ? [] : List<TransactionSentList>.from(json["transaction_sent_list"]!.map((x) => TransactionSentList.fromJson(x))),
    transactionRecievedList: json["transaction_recieved_list"] == null ? [] : List<TransactionRecievedList>.from(json["transaction_recieved_list"]!.map((x) => TransactionRecievedList.fromJson(x))),
    eventsInviteList: json["events_invite_list"] == null ? [] : List<EventsInviteList>.from(json["events_invite_list"]!.map((x) => EventsInviteList.fromJson(x))),
    randomQuote: json["random_quote"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "kyc_status": kycStatus,
    "total_sent_amount": totalSentAmount,
    "total_recieved_amount": totalRecievedAmount,
    "transaction_sent_list": transactionSentList == null ? [] : List<dynamic>.from(transactionSentList!.map((x) => x.toJson())),
    "transaction_recieved_list": transactionRecievedList == null ? [] : List<dynamic>.from(transactionRecievedList!.map((x) => x.toJson())),
    "events_invite_list": eventsInviteList == null ? [] : List<dynamic>.from(eventsInviteList!.map((x) => x.toJson())),
    "random_quote": randomQuote,
  };
}

class EventsInviteList {
  String? eventName;
  DateTime? eventDate;
  int? eventId;
  int? isGifted;
  String? invitedBy;
  List<EventAdmin>? eventAdmins;

  EventsInviteList({
    this.eventName,
    this.eventDate,
    this.eventId,
    this.isGifted,
    this.invitedBy,
    this.eventAdmins,
  });

  factory EventsInviteList.fromJson(Map<String, dynamic> json) => EventsInviteList(
    eventName: json["event_name"],
    eventDate: json["event_date"] == null ? null : DateTime.parse(json["event_date"]),
    eventId: json["event_id"],
    isGifted: json["is_gifted"],
    invitedBy: json["invited_by"],
    eventAdmins: json["event_admins"] == null ? [] : List<EventAdmin>.from(json["event_admins"]!.map((x) => EventAdmin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "event_name": eventName,
    "event_date": eventDate?.toIso8601String(),
    "event_id": eventId,
    "is_gifted": isGifted,
    "invited_by": invitedBy,
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

class TransactionRecievedList {
  double? amountReceived;
  String? evenName;
  String? receivedFrom;
  int? eventId;
  String? profilePic;

  TransactionRecievedList({
    this.amountReceived,
    this.evenName,
    this.receivedFrom,
    this.eventId,
    this.profilePic,
  });

  factory TransactionRecievedList.fromJson(Map<String, dynamic> json) => TransactionRecievedList(
    amountReceived: json["amount_received"]?.toDouble(),
    evenName: json["even_name"],
    receivedFrom: json["received_from"],
    eventId: json["event_id"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "amount_received": amountReceived,
    "even_name": evenName,
    "received_from": receivedFrom,
    "event_id": eventId,
    "profile_pic": profilePic,
  };
}

class TransactionSentList {
  double? amountSent;
  String? eventName;
  String? sentTo;
  int? eventId;
  String? profilePic;

  TransactionSentList({
    this.amountSent,
    this.eventName,
    this.sentTo,
    this.eventId,
    this.profilePic,
  });

  factory TransactionSentList.fromJson(Map<String, dynamic> json) => TransactionSentList(
    amountSent: json["amount_sent"]?.toDouble(),
    eventName: json["event_name"],
    sentTo: json["sent_to"],
    eventId: json["event_id"],
    profilePic: json["profile_pic"],
  );

  Map<String, dynamic> toJson() => {
    "amount_sent": amountSent,
    "event_name": eventName,
    "sent_to": sentTo,
    "event_id": eventId,
    "profile_pic": profilePic,
  };
}

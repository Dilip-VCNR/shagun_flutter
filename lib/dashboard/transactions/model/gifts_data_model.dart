// To parse this JSON data, do
//
//     final giftsDataModel = giftsDataModelFromJson(jsonString);

import 'dart:convert';

GiftsDataModel giftsDataModelFromJson(String str) => GiftsDataModel.fromJson(json.decode(str));

String giftsDataModelToJson(GiftsDataModel data) => json.encode(data.toJson());

class GiftsDataModel {
  bool? status;
  double? totalGiftSent;
  List<EventsList>? eventsList;
  List<SentGift>? sentGifts;

  GiftsDataModel({
    this.status,
    this.totalGiftSent,
    this.eventsList,
    this.sentGifts,
  });

  factory GiftsDataModel.fromJson(Map<String, dynamic> json) => GiftsDataModel(
    status: json["status"],
    totalGiftSent: json["total_gift_sent"]?.toDouble(),
    eventsList: json["events_list"] == null ? [] : List<EventsList>.from(json["events_list"]!.map((x) => EventsList.fromJson(x))),
    sentGifts: json["sent_gifts"] == null ? [] : List<SentGift>.from(json["sent_gifts"]!.map((x) => SentGift.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "total_gift_sent": totalGiftSent,
    "events_list": eventsList == null ? [] : List<dynamic>.from(eventsList!.map((x) => x.toJson())),
    "sent_gifts": sentGifts == null ? [] : List<dynamic>.from(sentGifts!.map((x) => x.toJson())),
  };
}

class EventsList {
  int? id;
  String? eventTypeName;

  EventsList({
    this.id,
    this.eventTypeName,
  });

  factory EventsList.fromJson(Map<String, dynamic> json) => EventsList(
    id: json["id"],
    eventTypeName: json["event_type_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_type_name": eventTypeName,
  };
}

class SentGift {
  String? receiverUid;
  String? senderUid;
  String? profilePic;
  String? name;
  double? shagunAmount;
  double? transactionAmount;
  double? transactionFee;
  double? deliveryFee;
  DateTime? createdOn;
  double? cardPrice;
  String? eventTypeName;
  int? id;
  int? settlementStatus;
  dynamic bankName;
  dynamic bankLogo;
  dynamic accNo;

  SentGift({
    this.receiverUid,
    this.senderUid,
    this.profilePic,
    this.name,
    this.shagunAmount,
    this.transactionAmount,
    this.transactionFee,
    this.deliveryFee,
    this.createdOn,
    this.cardPrice,
    this.eventTypeName,
    this.id,
    this.settlementStatus,
    this.bankName,
    this.bankLogo,
    this.accNo,
  });

  factory SentGift.fromJson(Map<String, dynamic> json) => SentGift(
    receiverUid: json["receiver_uid"],
    senderUid: json["sender_uid"],
    profilePic: json["profile_pic"],
    name: json["name"],
    shagunAmount: json["shagun_amount"]?.toDouble(),
    transactionAmount: json["transaction_amount"]?.toDouble(),
    transactionFee: json["transaction_fee"],
    deliveryFee: json["delivery_fee"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    cardPrice: json["card_price"],
    eventTypeName: json["event_type_name"],
    id: json["id"],
    settlementStatus: json["settlement_status"],
    bankName: json["bank_name"],
    bankLogo: json["bank_logo"],
    accNo: json["acc_no"],
  );

  Map<String, dynamic> toJson() => {
    "receiver_uid": receiverUid,
    "sender_uid": senderUid,
    "profile_pic": profilePic,
    "name": name,
    "shagun_amount": shagunAmount,
    "transaction_amount": transactionAmount,
    "transaction_fee": transactionFee,
    "delivery_fee": deliveryFee,
    "created_on": createdOn?.toIso8601String(),
    "card_price": cardPrice,
    "event_type_name": eventTypeName,
    "id": id,
    "settlement_status": settlementStatus,
    "bank_name": bankName,
    "bank_logo": bankLogo,
    "acc_no": accNo,
  };
}

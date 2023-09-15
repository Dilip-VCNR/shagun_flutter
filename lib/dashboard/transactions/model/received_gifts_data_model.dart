// To parse this JSON data, do
//
//     final receivedGiftsDataModel = receivedGiftsDataModelFromJson(jsonString);

import 'dart:convert';

import 'gifts_data_model.dart';

ReceivedGiftsDataModel receivedGiftsDataModelFromJson(String str) => ReceivedGiftsDataModel.fromJson(json.decode(str));

String receivedGiftsDataModelToJson(ReceivedGiftsDataModel data) => json.encode(data.toJson());

class ReceivedGiftsDataModel {
  bool? status;
  double? totalGiftSent;
  List<EventsList>? eventsList;
  List<ReceivedGift>? receivedGifts;

  ReceivedGiftsDataModel({
    this.status,
    this.totalGiftSent,
    this.eventsList,
    this.receivedGifts,
  });

  factory ReceivedGiftsDataModel.fromJson(Map<String, dynamic> json) => ReceivedGiftsDataModel(
    status: json["status"],
    totalGiftSent: json["total_received_gifts"]?.toDouble(),
    eventsList: json["events_list"] == null ? [] : List<EventsList>.from(json["events_list"]!.map((x) => EventsList.fromJson(x))),
    receivedGifts: json["received_gifts"] == null ? [] : List<ReceivedGift>.from(json["received_gifts"]!.map((x) => ReceivedGift.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "total_gift_sent": totalGiftSent,
    "events_list": eventsList == null ? [] : List<dynamic>.from(eventsList!.map((x) => x.toJson())),
    "received_gifts": receivedGifts == null ? [] : List<dynamic>.from(receivedGifts!.map((x) => x.toJson())),
  };
}


class ReceivedGift {
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

  ReceivedGift({
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

  factory ReceivedGift.fromJson(Map<String, dynamic> json) => ReceivedGift(
    receiverUid: json["receiver_uid"],
    senderUid: json["sender_uid"],
    profilePic: json["profile_pic"],
    name: json["name"],
    shagunAmount: json["shagun_amount"],
    transactionAmount: json["transaction_amount"],
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

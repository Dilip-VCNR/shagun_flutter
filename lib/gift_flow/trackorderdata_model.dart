// To parse this JSON data, do
//
//     final trackOrderDataModel = trackOrderDataModelFromJson(jsonString);

import 'dart:convert';

TrackOrderDataModel trackOrderDataModelFromJson(String str) => TrackOrderDataModel.fromJson(json.decode(str));

String trackOrderDataModelToJson(TrackOrderDataModel data) => json.encode(data.toJson());

class TrackOrderDataModel {
  bool? status;
  List<TrackTransaction>? trackTransaction;

  TrackOrderDataModel({
    this.status,
    this.trackTransaction,
  });

  factory TrackOrderDataModel.fromJson(Map<String, dynamic> json) => TrackOrderDataModel(
    status: json["status"],
    trackTransaction: json["track_transaction"] == null ? [] : List<TrackTransaction>.from(json["track_transaction"]!.map((x) => TrackTransaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "track_transaction": trackTransaction == null ? [] : List<dynamic>.from(trackTransaction!.map((x) => x.toJson())),
  };
}

class TrackTransaction {
  int? tid;
  int? status;
  DateTime? date;

  TrackTransaction({
    this.tid,
    this.status,
    this.date,
  });

  factory TrackTransaction.fromJson(Map<String, dynamic> json) => TrackTransaction(
    tid: json["tid"],
    status: json["status"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "tid": tid,
    "status": status,
    "date": date?.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final compatibilityCheckModel = compatibilityCheckModelFromJson(jsonString);

import 'dart:convert';

CompatibilityCheckModel compatibilityCheckModelFromJson(String str) => CompatibilityCheckModel.fromJson(json.decode(str));

String compatibilityCheckModelToJson(CompatibilityCheckModel data) => json.encode(data.toJson());

class CompatibilityCheckModel {
  String? appName;
  String? minVersion;
  String? latestVersion;
  String? platform;
  DateTime? created;
  DateTime? updated;

  CompatibilityCheckModel({
    this.appName,
    this.minVersion,
    this.latestVersion,
    this.platform,
    this.created,
    this.updated,
  });

  factory CompatibilityCheckModel.fromJson(Map<String, dynamic> json) => CompatibilityCheckModel(
    appName: json["app_name"],
    minVersion: json["min_version"],
    latestVersion: json["latest_version"],
    platform: json["platform"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
  );

  Map<String, dynamic> toJson() => {
    "app_name": appName,
    "min_version": minVersion,
    "latest_version": latestVersion,
    "platform": platform,
    "created": created?.toIso8601String(),
    "updated": updated?.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final profileDataModel = profileDataModelFromJson(jsonString);

import 'dart:convert';

ProfileDataModel profileDataModelFromJson(String str) => ProfileDataModel.fromJson(json.decode(str));

String profileDataModelToJson(ProfileDataModel data) => json.encode(data.toJson());

class ProfileDataModel {
  bool? status;
  String? message;
  int? eventsCount;
  int? bankCount;
  double? totalAmountSent;
  double? totalAmountReceived;
  User? user;
  List<BankDatum>? bankData;
  KycData? kycData;
  bool? isActiveKycRequest;


  ProfileDataModel({
    this.status,
    this.message,
    this.eventsCount,
    this.bankCount,
    this.totalAmountSent,
    this.totalAmountReceived,
    this.user,
    this.bankData,
    this.kycData,
    this.isActiveKycRequest
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) => ProfileDataModel(
    status: json["status"],
    message: json["message"],
    eventsCount: json["events_count"],
    bankCount: json["bank_count"],
    totalAmountSent: json["total_amount_sent"],
    totalAmountReceived: json["total_amount_received"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    bankData: json["bank_data"] == null ? [] : List<BankDatum>.from(json["bank_data"]!.map((x) => BankDatum.fromJson(x))),
    kycData: json["kyc_data"] == null ? null : KycData.fromJson(json["kyc_data"]),
    isActiveKycRequest: json['is_active_kyc_request'],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "events_count": eventsCount,
    "bank_count": bankCount,
    "total_amount_sent": totalAmountSent,
    "total_amount_received": totalAmountReceived,
    "user": user?.toJson(),
    "bank_data": bankData == null ? [] : List<dynamic>.from(bankData!.map((x) => x.toJson())),
    "kyc_data": kycData?.toJson(),
    "is_active_kyc_request": isActiveKycRequest,
  };
}

class BankDatum {
  String? bankName;
  String? accNo;
  String? ifscCode;
  int? status;

  BankDatum({
    this.bankName,
    this.accNo,
    this.ifscCode,
    this.status,
  });

  factory BankDatum.fromJson(Map<String, dynamic> json) => BankDatum(
    bankName: json["bank_name"],
    accNo: json["acc_no"],
    ifscCode: json["ifsc_code"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "bank_name": bankName,
    "acc_no": accNo,
    "ifsc_code": ifscCode,
    "status": status,
  };
}

class KycData {
  String? docName;
  String? docNum;
  String? docName1;
  String? docNum1;
  int? status;

  KycData({
    this.docName,
    this.docNum,
    this.docName1,
    this.docNum1,
    this.status,
  });

  factory KycData.fromJson(Map<String, dynamic> json) => KycData(
    docName: json["doc_name"],
    docNum: json["doc_num"],
    docName1: json["doc_name1"],
    docNum1: json["doc_num1"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "doc_name": docName,
    "doc_num": docNum,
    "doc_name1": docName1,
    "doc_num1": docNum1,
    "status": status,
  };
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? kyc;
  String? profile;
  String? userId;
  DateTime? createdOn;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.kyc,
    this.profile,
    this.userId,
    this.createdOn,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    kyc: json["Kyc"],
    profile: json["profile"],
    userId: json["user_id"],
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "Kyc": kyc,
    "profile": profile,
    "user_id": userId,
    "created_on": createdOn?.toIso8601String(),
  };
}

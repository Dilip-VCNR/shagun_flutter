
import 'package:shagun_mobile/auth/model/user_details_model.dart';

class PrefModel {
  UserDetailsModel? userData;

  PrefModel({
    this.userData,
  });

  factory PrefModel.fromJson(Map<String, dynamic> parsedJson) {
    return PrefModel(
      userData: parsedJson["userData"] == null
          ? null
          : UserDetailsModel.fromJson(parsedJson["userData"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userData": userData?.toJson(),
    };
  }
}

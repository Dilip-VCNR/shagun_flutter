
class PrefModel {
  String? userData;

  PrefModel({
    this.userData,
  });

  factory PrefModel.fromJson(Map<String, dynamic> parsedJson) {
    return PrefModel(
      userData: parsedJson["userData"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userData": userData
    };
  }
}

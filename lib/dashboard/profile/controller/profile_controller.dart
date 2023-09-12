import 'package:flutter/material.dart';
import 'package:shagun_mobile/dashboard/profile/model/profile_data_model.dart';

import '../../../network/api_calls.dart';

class ProfileController{
  ApiCalls apiCalls = ApiCalls();

  Future<ProfileDataModel>? fetchProfileData(BuildContext context) {
    return apiCalls.getProfileData(context);

  }

}
import 'package:flutter/material.dart';
import 'package:shagun_mobile/auth/controller/auth_controller.dart';
import 'package:shagun_mobile/dashboard/home/model/home_data_model.dart';
import 'package:shagun_mobile/dashboard/home/model/search_data_model.dart';
import 'package:shagun_mobile/network/api_calls.dart';

class HomeControllers{
  ApiCalls apiCalls = ApiCalls();
  AuthController authController = AuthController();
  Future<HomeDataModel>? fetchHomeData(BuildContext context) {
    return apiCalls.getHomeData(context);
  }

  Future<SearchDataModel>?searchProfile(String query, BuildContext context) {
    return apiCalls.getSearchProfiles(query,context);
  }

  getEventDetailsFromHome(BuildContext context, int eventId, String invitedByPhone) {
    return apiCalls.getSingleEventDataFromHome(context,eventId,invitedByPhone);
  }

  getUserEvents(BuildContext context, String? searchUid) {
    return apiCalls.getUserEventsData(context,searchUid);
  }

}
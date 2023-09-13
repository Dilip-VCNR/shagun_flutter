import 'package:flutter/material.dart';
import 'package:shagun_mobile/dashboard/my_events/controller/user_events_model.dart';
import 'package:shagun_mobile/network/api_calls.dart';

import '../model/all_invites_data_model.dart';
import '../model/events_screen_model.dart';

class MyEventsController {
  ApiCalls apiCalls = ApiCalls();

  Future<AllInvitesDataModel>? fetchAllInvitedEventsData() {
    return apiCalls.getAllInvitedEvents();
  }

  Future<EventsScreenModel>? fetchEventsData(BuildContext context) {
    return apiCalls.getEventsData(context);
  }


  getEventDetails(BuildContext context, UpcomingEvent upcomingEvent) {
    return apiCalls.getSingleEventData(context,upcomingEvent);
  }


  requestEvent(String? eventTypeName, BuildContext context) {
    return apiCalls.requestEventCallBack(context,eventTypeName);
  }
}

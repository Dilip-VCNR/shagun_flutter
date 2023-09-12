import 'package:flutter/material.dart';
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
}

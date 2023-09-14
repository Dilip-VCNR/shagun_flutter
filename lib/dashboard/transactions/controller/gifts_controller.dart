import 'package:flutter/material.dart';
import 'package:shagun_mobile/network/api_calls.dart';

import '../model/gifts_data_model.dart';
import '../model/received_gifts_data_model.dart';


class GiftsController{
  ApiCalls apiCalls = ApiCalls();
  Future<GiftsDataModel>? fetchSentGiftsData(BuildContext context,String type,String month) {
    return apiCalls.getGiftsSentData(context,type,month);
  }

  Future<ReceivedGiftsDataModel>? fetchReceivedGiftsData(BuildContext context,String type,String month) {
    return apiCalls.getGiftsReceivedData(context,type,month);
  }

  Future<ReceivedGiftsDataModel>? fetchReceivedGiftsDataForEvent(BuildContext context, String? userId, String eventId) {
    return apiCalls.getGiftsReceivedDataForEvent(context,userId,eventId);
  }

}
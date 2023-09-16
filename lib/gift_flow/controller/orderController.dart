import 'package:flutter/src/widgets/framework.dart';
import 'package:shagun_mobile/gift_flow/trackorderdata_model.dart';

import '../../network/api_calls.dart';

class OrderController{
  ApiCalls apiCalls = ApiCalls();

  createOrder(Map arguments, BuildContext context) {
    return apiCalls.createOrder(context,arguments);

  }

  getPaymentSessionId(Map arguments, BuildContext context) {
    return apiCalls.createPaymentSessionId(arguments,context);
  }

  Future<TrackOrderDataModel>? fetchOrderTrackData(BuildContext context, String? orderId) {
    return apiCalls.fetchOrderTrackData(context,orderId);
  }

}
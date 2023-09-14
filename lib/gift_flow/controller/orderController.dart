import 'package:flutter/src/widgets/framework.dart';

import '../../network/api_calls.dart';

class OrderController{
  ApiCalls apiCalls = ApiCalls();

  createOrder(Map arguments, BuildContext context) {
    return apiCalls.createOrder(context,arguments);

  }

  getPaymentSessionId(Map arguments, BuildContext context) {
    return apiCalls.createPaymentSessionId(arguments,context);
  }

}
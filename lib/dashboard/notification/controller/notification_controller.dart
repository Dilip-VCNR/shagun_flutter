import 'package:flutter/src/widgets/framework.dart';
import 'package:shagun_mobile/dashboard/notification/model/notification_data_model.dart';
import 'package:shagun_mobile/network/api_calls.dart';

class NotificationController{
  ApiCalls apiCalls = ApiCalls();

  Future<NotificationDataModel>? fetchNotificationsData(BuildContext context) {
    return apiCalls.fetchNotifications(context);
  }
}
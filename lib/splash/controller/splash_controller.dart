import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shagun_mobile/dashboard/home/controller/home_controllers.dart';
import 'package:uni_links/uni_links.dart';

import '../../dashboard/my_events/model/single_event_model.dart';
import '../../database/app_pref.dart';
import '../../database/models/pref_model.dart';
import '../../network/api_calls.dart';
import '../../utils/app_widgets.dart';
import '../../utils/routes.dart';
import '../model/compatibility_check_model.dart';

class SplashController {
  ApiCalls apiCalls = ApiCalls();

  moveToCorrespondingScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      PrefModel prefModel = AppPref.getPref();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (context.mounted) {
        CompatibilityCheckModel result =
            await apiCalls.checkCompatibilityApi(packageInfo, context);
        if (!shouldUpdateApp(result, packageInfo)) {
          if (prefModel.userData == null) {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, Routes.onBoarding);
            }
          } else {
            final initialLink = await getInitialLink();
            if(initialLink!=null){
              var uri = Uri.parse(initialLink);
              if(uri.queryParameters['eventId']!=null){
                  showLoaderDialog(context);
                  SingleEventDataModel eventData =
                  await HomeControllers()
                      .getEventDetailsFromHome(
                    context,
                    int.parse(uri.queryParameters['eventId']!),
                    uri.queryParameters['invitedBy']!,
                  );
                if(context.mounted){
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.pushReplacementNamed(
                      context, Routes.eventDetailsRoute,
                      arguments: {
                        'type': uri.queryParameters['invitedBy']==prefModel.userData!.user!.phone?'own':'invited',
                        'eventData': eventData
                      });
                }
              }else{
                if(context.mounted){
                  showErrorToast(context, "Could not find the event\nEvent invalid");
                  Navigator.pushReplacementNamed(context, Routes.dashboardRoute);
                }
              }
            }else{
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, Routes.dashboardRoute);
              }
            }
          }
        } else {
          String updateTextContent =
              'Please update Shagun™ to the latest version '
              '${result.latestVersion} to continue using the app';
          if (context.mounted) {
            showForceUpdateDialog(context, updateTextContent, packageInfo);
          }
        }
      }
    });
  }


  bool shouldUpdateApp(
      CompatibilityCheckModel result, PackageInfo packageInfo) {
    final store = result.minVersion!.split('.').map(int.parse).toList();
    final current = packageInfo.version.split('.').map(int.parse).toList();
    for (var i = 0; i < store.length; i++) {
      if (store[i] < current[i]) {
        return false;
      }
      if (current[i] < store[i]) {
        return true;
      }
    }
    return false;
  }
}

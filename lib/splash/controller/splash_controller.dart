import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
              Navigator.pushReplacementNamed(context, Routes.loginRoute);
            }
          } else {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, Routes.dashboardRoute);
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

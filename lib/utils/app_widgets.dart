import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:toastification/toastification.dart';

import 'app_colors.dart';

showErrorToast(BuildContext context, String message) {
  toastification.showError(
    context: context,
    closeOnClick: true,
    title: message,
    autoCloseDuration: const Duration(seconds: 5),
  );
}

showSuccessToast(BuildContext context, String message) {
  toastification.showSuccess(
    closeOnClick: true,
    context: context,
    title: message,
    autoCloseDuration: const Duration(seconds: 5),
  );
}

showLoaderDialog(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/loading.json', height: 150),
                const Text(
                  "Loading...",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ));
}

showForceUpdateDialog(
    BuildContext buildContext, updateTextContent, PackageInfo packageInfo) {
  showDialog(
      barrierDismissible: false,
      context: buildContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Update Available !",
          ),
          content: Text(updateTextContent),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                StoreRedirect.redirect(
                    androidAppId: packageInfo.packageName,
                    iOSAppId: "1633065411");
              },
            ),
          ],
        );
      });
}

showWishDialog(BuildContext buildContext, wishText, String sender) {
  showDialog(
      barrierDismissible: false,
      context: buildContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("By $sender"),
          content: Text(wishText,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
               Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shagun_mobile/network/api_calls.dart';
import 'package:shagun_mobile/utils/app_widgets.dart';

import '../../database/app_pref.dart';
import '../../database/models/pref_model.dart';
import '../../utils/routes.dart';
import '../model/user_details_model.dart';

class AuthController {
  PrefModel prefModel = AppPref.getPref();

  ApiCalls apiCalls = ApiCalls();

  bool isNotValidEmail(String email) {
    const emailRegex =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*(\.[a-zA-Z]{2,})$';
    final regExp = RegExp(emailRegex);
    return !regExp.hasMatch(email);
  }

  bool isNotValidPhone(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return true;
    }
    if (phoneNumber.length != 10 || !isNumeric(phoneNumber)) {
      return true;
    }
    return false;
  }

  bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  bool isNotValidName(String name) {
    const nameRegex = r'^[a-zA-Z\s]+$';
    final regExp = RegExp(nameRegex);
    if (!regExp.hasMatch(name)) {
      return true;
    }
    final containsNumbers = name.contains(RegExp(r'[0-9]'));
    return containsNumbers;
  }

  Future<void> loginWithPhoneNumber(BuildContext context, String phoneNumber,
      String? selectedCountryCode) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '$selectedCountryCode $phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Navigator.pop(context);
        showErrorToast(context, "Something Went Wrong $e");
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pop(context);
        Navigator.pushNamed(context, Routes.otpScreenRoute, arguments: {
          'verificationId': verificationId,
          'phone': phoneNumber,
          'selectedCountryCode': selectedCountryCode,
        });
        showSuccessToast(
            context, "OTP is sent to $selectedCountryCode $phoneNumber");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyOTPCode(BuildContext context, String otpCode, String? verificationId,
      String phone, String countryCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otpCode,
    );
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        await apiCallForUserDetails(
            context, value.user?.uid, phone, countryCode, null, "Phone");
      });
    } on FirebaseAuthException catch (e) {
      if(context.mounted){
        Navigator.pop(context);
        showErrorToast(context, "Oops !You have entered a wrong OTP\n$e");
      }
    }
  }

  resendOtp(BuildContext context, String phone, String countryCode) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '$countryCode $phone',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Navigator.pop(context);
        showErrorToast(context, "Something Went Wrong $e");
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pop(context);
        showSuccessToast(context, "OTP is sent to $countryCode $phone");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  apiCallForUserDetails(BuildContext context, String? uid, String? phone,
      String? selectedCountryCode, String? email, String authType) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    var result = await apiCalls.getUserDetails(uid!, fcmToken!);
    switch (result['statusCode']) {
      case 200:
        UserDetailsModel userData = result['data'];
        prefModel.userData = userData;
        await AppPref.setPref(prefModel);
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.dashboardRoute, (route) => false);
        }
        break;
      case 301:
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pushNamed(context, Routes.registerRoute, arguments: {
            'phone': phone,
            'countryCode': selectedCountryCode,
            'uid': uid,
            'email': email,
            'authType': authType
          });
        }
        break;
      default:
        if (context.mounted) {
          Navigator.pop(context);
          showErrorToast(context, "Something Went wrong");
        }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
    if (context.mounted) {
      await apiCallForUserDetails(context, userCredential.user?.uid, null, null,
          userCredential.user!.email!, "Google");
    }
  }

  Future<void> apiCallForRegisterUser(
      String? uid,
      String? fcmToken,
      String name,
      String phone,
      String email,
      String authType,
      BuildContext context, File? selectedImage) async {
    var result = await apiCalls.registerUser(
        uid!, fcmToken!, name, phone, email, authType,selectedImage);
    switch (result['statusCode']) {
      case 200:
        UserDetailsModel userData = result['data'];
        PrefModel prefModel = AppPref.getPref();
        prefModel.userData = userData;
        await AppPref.setPref(prefModel);
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.dashboardRoute, (route) => false);
        }
        break;
      case 301:
        if (context.mounted) {
          Navigator.pop(context);
          showErrorToast(context,"User already exist !");
        }
        break;
      default:
        if (context.mounted) {
          Navigator.pop(context);
          showErrorToast(context,"Something Went wrong");
        }
    }
  }

}

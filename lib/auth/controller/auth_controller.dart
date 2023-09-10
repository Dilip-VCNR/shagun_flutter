import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../database/app_pref.dart';
import '../../database/models/pref_model.dart';
import '../../utils/routes.dart';

class AuthController {
  PrefModel prefModel = AppPref.getPref();

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

  resendOtp(BuildContext context, String phone, String countryCode, Size screenSize) {}

  verifyOTPCode(BuildContext context, String otpCode, String? verificationId, String phone, String countryCode) {
    Navigator.pop(context);
    Navigator.pushNamed(context, Routes.registerRoute);
  }
}

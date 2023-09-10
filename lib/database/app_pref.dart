import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/pref_model.dart';

class AppPref {
  static AppPref? _appPref;
  static SharedPreferences? _preferences;
  static String key = "com_shagun_mobile";

  static Future<AppPref> getInstance() async {
    if (_appPref == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = AppPref._();
      await secureStorage._init();
      _appPref = secureStorage;
    }
    return _appPref!;
  }

  AppPref._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static PrefModel getPref() {
    String? pref = _preferences?.getString(key);
    if (pref != null) {
      PrefModel model = PrefModel.fromJson(json.decode(pref));
      return model;
    } else {
      return PrefModel();
    }
  }

  static setPref(value) async {
    await _preferences?.setString(key, json.encode(value));
  }

  static setKeyValPref(key, value) {
    _preferences?.setString(key, json.encode(value));
  }

  static clearPref() {
    _preferences?.remove(key);
  }
}

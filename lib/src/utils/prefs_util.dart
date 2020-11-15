import 'dart:async';

import 'package:autobuff/src/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtil {
  static final PrefsUtil _prefsUtil = PrefsUtil._();
  factory PrefsUtil() => _prefsUtil;
  PrefsUtil._();

  SharedPreferences prefs;

  Future<Map<String, dynamic>> init() async {
    prefs = await SharedPreferences.getInstance();

    String accessToken = prefs.getString(Constants.ACCESS_TOKEN);
    //String refreshToken = prefs.getString(Constants.REFRESH_TOKEN);

    accessToken = accessToken == null ? "" : accessToken;
    //refreshToken = refreshToken == null ? "" : refreshToken;

    return <String, dynamic>{
      Constants.ACCESS_TOKEN: accessToken,
      //Constants.REFRESH_TOKEN: refreshToken,
    };
  }

  void nullifySignedInDetails() {
    prefs.setString(Constants.ACCESS_TOKEN, null);
    // prefs.setString(Constants.REFRESH_TOKEN, null);
  }
}

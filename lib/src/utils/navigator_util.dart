import 'dart:async';
import 'package:flutter/material.dart';

import '../widgets/app_loader.dart';

class NavigatorUtil {
  void navigateToHomeScreen(BuildContext context) {
    navigateToScreen(context, '/home', replace: true);
  }

  void navigateToScreen(BuildContext context, String path, {bool replace}) {
    if (replace != null && replace) {
      Navigator.pushReplacementNamed(context, path);
    } else {
      Navigator.pushNamed(context, path);
    }
  }

  void navigateAndPopScreen(BuildContext context, String path) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (Route<dynamic> route) => false,
    );
    print('object');
    Navigator.pushReplacementNamed(context, path);
  }

  void navigateToSignInScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (Route<dynamic> route) => false,
    );
    Navigator.pushNamed(context, '/login');
  }

  void navigateUntilHomeScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (Route<dynamic> route) => false,
    );
    //Navigator.pushNamed(context, '/home');
  }

  void pop(BuildContext context, [bool result]) {
    Navigator.pop(context, result);
  }

  bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  Future<Dialog> showLoader(BuildContext context, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AppLoader(message).loader;
        });
  }

  void hideLoader(BuildContext context, bool rootNavigator) {
    return Navigator.of(context, rootNavigator: rootNavigator).pop();
  }
}

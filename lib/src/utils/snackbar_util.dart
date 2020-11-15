import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../widgets/app_message.dart';

class SnackbarUtil {
  static final SnackbarUtil _snackbarUtil = SnackbarUtil._();
  factory SnackbarUtil() => _snackbarUtil;
  SnackbarUtil._() {
    _messageHome.listen((data) {
      _showSnackbar(_buildContextHome, data);
    });
    _messageSignup.listen((data) {
      _showSnackbar(_buildContextSignup, data);
    });
    _messageProfile.listen((data) {
      _showSnackbar(_buildContextProfile, data);
    });
    _messageForget.listen((data) {
      _showSnackbar(_buildContextForget, data);
    });
    _messageLogin.listen((data) {
      _showSnackbar(_buildContextLogin, data);
    });
    _messageSupport.listen((data) {
      _showSnackbar(_buildContextSupport, data);
    });
  }

  BuildContext _buildContextHome;
  BuildContext _buildContextSignup;
  BuildContext _buildContextProfile;
  BuildContext _buildContextForget;
  BuildContext _buildContextLogin;
  BuildContext _buildContextSupport;
  set buildContextHome(BuildContext context) => _buildContextHome = context;
  set buildContextSignup(BuildContext context) => _buildContextSignup = context;
  set buildContextProfile(BuildContext context) =>
      _buildContextProfile = context;
  set buildContextForget(BuildContext context) => _buildContextForget = context;
  set buildContextLogin(BuildContext context) => _buildContextLogin = context;
  set buildContextSupport(BuildContext context) =>
      _buildContextSupport = context;

  final BehaviorSubject<String> _messageHome = BehaviorSubject<String>();
  Function(String) get updateMessageHome => _messageHome.sink.add;
  final BehaviorSubject<String> _messageSignup = BehaviorSubject<String>();
  Function(String) get updateMessageSignup => _messageSignup.sink.add;
  final BehaviorSubject<String> _messageProfile = BehaviorSubject<String>();
  Function(String) get updateMessageProfile => _messageProfile.sink.add;
  final BehaviorSubject<String> _messageForget = BehaviorSubject<String>();
  Function(String) get updateMessageForget => _messageForget.sink.add;
  final BehaviorSubject<String> _messageLogin = BehaviorSubject<String>();
  Function(String) get updateMessageLogin => _messageLogin.sink.add;
  final BehaviorSubject<String> _messageSupport = BehaviorSubject<String>();
  Function(String) get updateMessageSupport => _messageSupport.sink.add;

  Future _showSnackbar(BuildContext context, String message) {
    if (context != null) {
      AppMessage appMessage = AppMessage(message);
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(appMessage.snackBar);
    }
    return null;
  }

  void displaySnackbar(BuildContext context, String message) {
    _showSnackbar(context, message);
  }

  void dispose() {
    _messageHome.close();
    _messageSignup.close();
    _messageProfile.close();
    _messageForget.close();
    _messageLogin.close();
    _messageSupport.close();
  }
}

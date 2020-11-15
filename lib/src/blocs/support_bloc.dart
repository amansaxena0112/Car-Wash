import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:autobuff/src/models/auto_complete_location.dart';
import 'package:autobuff/src/models/booking_model.dart';
import 'package:autobuff/src/models/car_model.dart';
import 'package:autobuff/src/models/service_model.dart';
import 'package:autobuff/src/models/user_model.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:autobuff/src/utils/constants.dart';
import 'package:autobuff/src/utils/prefs_util.dart';
import 'package:autobuff/src/validators/validator.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_permissions_helper/enums.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/network_util.dart';
import '../utils/snackbar_util.dart';
import '../utils/connectivity_util.dart';
import '../utils/navigator_util.dart';

class SupportBloc extends Object with Validators {
  static final SupportBloc _supportBloc = SupportBloc._();
  factory SupportBloc() => _supportBloc;
  SupportBloc._() {
    _networkUtil = NetworkUtil();
    _connectivityUtil = ConnectivityUtil();
    _snackbarUtil = SnackbarUtil();
    _commonUtil = CommonUtil();
    _navigatorUtil = NavigatorUtil();
    _prefsUtil = PrefsUtil();
    // _notificationUtil = NotificationUtil();
    // _fcmUtil = FcmUtil();
  }

  String imagePath;
  UserModel _user;
  BookingModel _bookingModel;
  NetworkUtil _networkUtil;
  NavigatorUtil _navigatorUtil;
  CommonUtil _commonUtil;
  ConnectivityUtil _connectivityUtil;
  PrefsUtil _prefsUtil;
  SnackbarUtil _snackbarUtil;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  BehaviorSubject<List<ServiceModel>> _services =
      BehaviorSubject<List<ServiceModel>>.seeded([]);
  BehaviorSubject<int> _serviceIndex = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<String> _name = BehaviorSubject<String>.seeded("");
  BehaviorSubject<String> _mobile = BehaviorSubject<String>.seeded("");
  BehaviorSubject<String> _email = BehaviorSubject<String>.seeded("");
  BehaviorSubject<String> _message = BehaviorSubject<String>.seeded("");

  Stream<List<ServiceModel>> get servicesList => _services.stream;
  List<ServiceModel> get servicesListValue => _services.stream.value;
  Function(List<ServiceModel>) get updateServicesList => _services.sink.add;
  Stream<int> get serviceIndex => _serviceIndex.stream;
  int get serviceIndexValue => _serviceIndex.stream.value;
  Function(int) get updateServiceindex => _serviceIndex.sink.add;
  Stream<String> get name => _name.stream;
  String get nameValue => _name.stream.value;
  Function(String) get updateName => _name.sink.add;
  Stream<String> get mobile => _mobile.stream;
  String get mobileValue => _mobile.stream.value;
  Function(String) get updateMobile => _mobile.sink.add;
  Stream<String> get email => _email.stream;
  String get emailValue => _email.stream.value;
  Function(String) get updateEmail => _email.sink.add;
  Stream<String> get message => _message.stream;
  String get messageValue => _message.stream.value;
  Function(String) get updateMessage => _message.sink.add;

  void dispose() {
    _services.close();
    _serviceIndex.close();
    _name.close();
    _mobile.close();
    _email.close();
    _message.close();
  }

  Future<bool> clearAll() async {
    return true;
  }

  Future<bool> updateData(BuildContext context) async {
    if (nameValue == null || nameValue.isEmpty) {
      print('name');
      _snackbarUtil.updateMessageSupport('Enter name');
      return false;
    }
    if (emailValue == null || emailValue.isEmpty) {
      _snackbarUtil.updateMessageSupport('Enter email');
      return false;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailValue)) {
      _snackbarUtil.updateMessageSupport('Enter correct email');
      return false;
    }
    if (mobileValue == null ||
        mobileValue.isEmpty ||
        mobileValue.length != 10) {
      _snackbarUtil.updateMessageSupport('Enter correct mobile number');
      return false;
    }
    if (messageValue == null || messageValue.isEmpty) {
      _snackbarUtil.updateMessageSupport('Enter message');
      return false;
    }
    print('object');
    requestContact(context);
    return true;
  }

  Future<bool> requestContact(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        _navigatorUtil.showLoader(context, 'Please wait...');
        http.Response response = await _networkUtil.requestContact(
            name: nameValue,
            email: emailValue,
            mobile: mobileValue,
            msg: messageValue);
        _navigatorUtil.hideLoader(context, true);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          updateName(null);
          nameController.clear();
          updateEmail(null);
          emailController.clear();
          updateMobile(null);
          mobileController.clear();
          updateMessage(null);
          messageController.clear();
          _snackbarUtil.updateMessageSupport(responseBody['message']);
          return true;
        } else {
          Map<dynamic, dynamic> responseMap = json.decode(response.body);
          if (responseMap['msg'] != null) {
            _snackbarUtil
                .updateMessageSignup(responseMap['message'].toString());
          } else {
            _snackbarUtil.updateMessageSignup(
                'Unable to reach our server. Check network connection');
          }
          return false;
        }
      } catch (ex, t) {
        print(ex);
        print(t);
        _snackbarUtil.updateMessageSignup(ex);
        return false;
      }
    } else {
      _snackbarUtil
          .updateMessageSignup('No network available. Check your connection');
      return false;
    }
  }
}

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

class ServiceBloc extends Object with Validators {
  static final ServiceBloc _serviceBloc = ServiceBloc._();
  factory ServiceBloc() => _serviceBloc;
  ServiceBloc._() {
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

  List<ServiceModel> services = [];

  BehaviorSubject<List<ServiceModel>> _services =
      BehaviorSubject<List<ServiceModel>>.seeded([]);
  BehaviorSubject<int> _serviceIndex = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<bool> _isNow = BehaviorSubject<bool>.seeded(false);

  Stream<List<ServiceModel>> get servicesList => _services.stream;
  List<ServiceModel> get servicesListValue => _services.stream.value;
  Function(List<ServiceModel>) get updateServicesList => _services.sink.add;
  Stream<int> get serviceIndex => _serviceIndex.stream;
  int get serviceIndexValue => _serviceIndex.stream.value;
  Function(int) get updateServiceindex => _serviceIndex.sink.add;
  Stream<bool> get isNow => _isNow.stream;
  bool get isNowValue => _isNow.stream.value;
  Function(bool) get updateIsNow => _isNow.sink.add;

  void dispose() {
    _services.close();
    _serviceIndex.close();
    _isNow.close();
  }

  Future<bool> clearAll() async {
    return true;
  }

  Future<bool> updateBookingModel() async {
    _bookingModel = BookingModel(
      carModel: _commonUtil.bookingModel != null
          ? _commonUtil.bookingModel.carModel
          : CarModel(),
      modeOfPayment: _commonUtil.bookingModel != null
          ? _commonUtil.bookingModel.modeOfPayment
          : 'cod',
      address: _commonUtil.bookingModel != null
          ? _commonUtil.bookingModel.address
          : '',
      latitude: _commonUtil.bookingModel != null
          ? _commonUtil.bookingModel.latitude
          : 0.0,
      longitude: _commonUtil.bookingModel != null
          ? _commonUtil.bookingModel.longitude
          : 0.0,
      serviceModel: servicesListValue[serviceIndexValue],
      dateTime: DateTime.now().toLocal().toString(),
    );
    _commonUtil.updateBookingModel = _bookingModel;
    return true;
  }

  Future<bool> getServices(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        http.Response response = await _networkUtil.getServices();
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          services = [];
          Map<String, dynamic> responseBody = json.decode(response.body);
          List<dynamic> responseData = responseBody['data'];
          print(responseData);
          responseData.forEach((data) {
            ServiceModel service = ServiceModel.fromMap(data);
            services.add(service);
          });
          updateServicesList(services);
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

import 'dart:async';
import 'dart:convert';
import 'package:autobuff/src/blocs/service_bloc.dart';
import 'package:autobuff/src/models/booking_model.dart';
import 'package:autobuff/src/models/car_model.dart';
import 'package:autobuff/src/models/my_booking_model.dart';
import 'package:autobuff/src/models/service_model.dart';
import 'package:autobuff/src/models/user_model.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:autobuff/src/utils/prefs_util.dart';
import 'package:autobuff/src/validators/validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/network_util.dart';
import '../utils/snackbar_util.dart';
import '../utils/connectivity_util.dart';
import '../utils/navigator_util.dart';

class BookingBloc extends Object with Validators {
  static final BookingBloc _bookingBloc = BookingBloc._();
  factory BookingBloc() => _bookingBloc;
  BookingBloc._() {
    _networkUtil = NetworkUtil();
    _connectivityUtil = ConnectivityUtil();
    _snackbarUtil = SnackbarUtil();
    _commonUtil = CommonUtil();
    _navigatorUtil = NavigatorUtil();
    _prefsUtil = PrefsUtil();
    // _notificationUtil = NotificationUtil();
    // _fcmUtil = FcmUtil();
  }

  BuildContext context;
  String imagePath;
  UserModel _user;
  BookingModel _bookingModel;
  NetworkUtil _networkUtil;
  NavigatorUtil _navigatorUtil;
  CommonUtil _commonUtil;
  ConnectivityUtil _connectivityUtil;
  PrefsUtil _prefsUtil;
  SnackbarUtil _snackbarUtil;
  List<MyBookingModel> myBookings = [];
  String next_page_url = "";
  int currentPage = 1;

  BehaviorSubject<String> _date = BehaviorSubject<String>.seeded("");
  BehaviorSubject<String> _time = BehaviorSubject<String>.seeded("");
  BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _isRepeatBooking = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<List<MyBookingModel>> _myBookings =
      BehaviorSubject<List<MyBookingModel>>.seeded([]);
  BehaviorSubject<MyBookingModel> _selectedBooking =
      BehaviorSubject<MyBookingModel>();

  Stream<String> get date => _date.stream;
  String get dateValue => _date.stream.value;
  Function(String) get updateDate => _date.sink.add;
  Stream<String> get time => _time.stream;
  String get timeValue => _time.stream.value;
  Function(String) get updateTime => _time.sink.add;
  Stream<bool> get isLoading => _isLoading.stream;
  bool get isLoadingValue => _isLoading.stream.value;
  Function(bool) get updateIsLoading => _isLoading.sink.add;
  Stream<List<MyBookingModel>> get myBookingList => _myBookings.stream;
  List<MyBookingModel> get myBookingListValue => _myBookings.stream.value;
  Function(List<MyBookingModel>) get updateMyBookingList =>
      _myBookings.sink.add;
  Stream<bool> get isRepeatBooking => _isRepeatBooking.stream;
  bool get isRepeatBookingValue => _isRepeatBooking.stream.value;
  Function(bool) get updateisRepeatBooking => _isRepeatBooking.sink.add;
  Stream<MyBookingModel> get selectedBooking => _selectedBooking.stream;
  MyBookingModel get selectedBookingValue => _selectedBooking.stream.value;
  Function(MyBookingModel) get updateselectedBooking =>
      _selectedBooking.sink.add;

  void dispose() {
    _date.close();
    _time.close();
    _isLoading.close();
    _myBookings.close();
    _isRepeatBooking.close();
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
      serviceModel: _commonUtil.bookingModel != null
          ? _commonUtil.bookingModel.serviceModel
          : ServiceModel(),
      dateTime: dateValue != null &&
              dateValue.isNotEmpty &&
              timeValue != null &&
              timeValue.isNotEmpty
          ? '$dateValue $timeValue'
          : '',
    );
    _commonUtil.updateBookingModel = _bookingModel;
    return true;
  }

  Future<bool> bookNowService(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        http.Response response = await _networkUtil.bookNow();
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          _navigatorUtil.navigateToScreen(context, '/success');
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

  Future<bool> bookLaterService(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        http.Response response = await _networkUtil.bookLater();
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          _navigatorUtil.navigateToScreen(context, '/success');
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

  Future<bool> repeatService(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        String dateTime = dateValue != null &&
                dateValue.isNotEmpty &&
                timeValue != null &&
                timeValue.isNotEmpty
            ? '$dateValue $timeValue'
            : '';
        http.Response response = await _networkUtil.repeatService(
            booking: selectedBookingValue, dateTime: dateTime);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          _navigatorUtil.navigateToScreen(context, '/success');
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

  Future<bool> getBooking(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        http.Response response = await _networkUtil.getBookings(currentPage);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          if (currentPage == 1) {
            myBookings = [];
          }
          Map<dynamic, dynamic> responseMap = json.decode(response.body);
          //_navigatorUtil.navigateToScreen(context, '/success');
          List<dynamic> responseData = responseMap['data'];
          responseData.forEach((data) {
            MyBookingModel booking = MyBookingModel.fromMap(data);
            myBookings.add(booking);
          });
          next_page_url = responseMap['next_page_url'];
          currentPage = responseMap['current_page'];
          updateMyBookingList(myBookings);
          updateIsLoading(false);
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

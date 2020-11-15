import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:autobuff/src/models/booking_model.dart';
import 'package:autobuff/src/models/my_booking_model.dart';
import 'package:autobuff/src/models/user_model.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../utils/constants.dart';

class NetworkUtil {
  CommonUtil _commonUtil = CommonUtil();
  bool isProduction = bool.fromEnvironment('dart.vm.product');

  Uri getUri(String path, {Map<String, dynamic> queryParams: const {}}) {
    if (isProduction) {
      return Uri(
        host: Constants.HOST_PROD,
        path: path,
        scheme: Constants.PROTOCOL_PROD,
        queryParameters: queryParams,
      );
    } else {
      return Uri(
        host: Constants.hostDev,
        path: path,
        port: Constants.PORT,
        scheme: Constants.PROTOCOL_DEV,
        queryParameters: queryParams,
      );
    }
  }

  Future<http.Response> authenticateUser(String token, LocationData location,
      String imei, String deviceID, String uuid) {
    String _body = json.encode({
      'location_details': json.encode({
        'mLatitude': location.latitude,
        'mLongitude': location.longitude,
      }),
      'time': DateTime.now().toIso8601String(),
      'imei_number': imei,
      'device_id': deviceID,
      'uuid': uuid,
    });
    return http.post(
      getUri(Constants.LOGIN_API),
      headers: {
        'token': token,
        'Content-Type': 'application/json',
      },
      body: _body,
    );
  }

  Future<http.Response> signUp({UserModel userModel}) {
    print(getUri(Constants.SIGNUP_API));
    print('Body:${json.encode({
      'full_name': userModel.name,
      'mobile': userModel.mobile,
      'email': userModel.email,
      'password': userModel.password,
    })}');
    return http.post(
      getUri(Constants.SIGNUP_API),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'full_name': userModel.name,
        'mobile': userModel.mobile,
        'email': userModel.email,
        'password': userModel.password,
      }),
    );
  }

  Future<http.Response> resetPassword({String mobile}) {
    print(getUri(Constants.FORGET_PASSWORD));
    print('Body:${json.encode({
      'mobile': mobile,
    })}');
    return http.post(
      getUri(Constants.FORGET_PASSWORD),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'mobile': mobile,
      }),
    );
  }

  Future<http.Response> login({UserModel userModel}) {
    print(getUri(Constants.LOGIN_API));
    print('Body:${json.encode({
      'mobile': userModel.mobile,
      'password': userModel.password,
    })}');
    return http.post(
      getUri(Constants.LOGIN_API),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'mobile': userModel.mobile,
        'password': userModel.password,
      }),
    );
  }

  Future<http.Response> getProfile() {
    print(getUri(Constants.GET_PROFILE_API));
    print(_commonUtil.user.accessToken);
    return http.get(
      getUri(Constants.GET_PROFILE_API),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      },
    );
  }

  Future<http.Response> verifyOTP({String otpID, String otp}) {
    print(getUri(Constants.VERIFY_OTP_API));
    print('Body:${json.encode({
      'otp_id': otpID,
      'otp': otp,
    })}');
    return http.post(
      getUri(Constants.VERIFY_OTP_API),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'otp_id': otpID,
        'otp': otp,
      }),
    );
  }

  Future<http.Response> resendOTP({String otpID}) {
    print(getUri(Constants.RESEND_OTP_API));
    print('Body:${json.encode({
      'otp_id': otpID,
    })}');
    return http.post(
      getUri(Constants.RESEND_OTP_API),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'otp_id': otpID,
      }),
    );
  }

  Future<http.Response> seacrhCars() {
    // Map<String, dynamic> queryParams = {
    //   'search_query': car,
    // };
    print(getUri(Constants.SEARCH_CAR_API));
    print(_commonUtil.user.accessToken);
    return http.get(
      getUri(Constants.SEARCH_CAR_API),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      },
    );
  }

  Future<http.Response> getServices() {
    print(getUri(Constants.SERVICES_API));
    print(_commonUtil.user.accessToken);
    return http.get(
      getUri(Constants.SERVICES_API),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      },
    );
  }

  Future<http.Response> requestContact(
      {String name, String mobile, String email, String msg}) {
    print(getUri(Constants.SUPPORT));
    print('Body:${json.encode({
      'full_name': name,
      'mobile': mobile,
      'email': email,
      'message': msg,
    })}');
    return http.post(
      getUri(Constants.SUPPORT),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      },
      body: json.encode({
        'full_name': name,
        'mobile': mobile,
        'email': email,
        'message': msg,
      }),
    );
  }

  Future<http.Response> bookNow() {
    BookingModel _bookingModel = _commonUtil.bookingModel;
    print(getUri(Constants.BOOK_NOW_API));
    print('Body:${json.encode({
      'mode_of_payment': _bookingModel.modeOfPayment,
      'service_id': _bookingModel.serviceModel.id,
      'car_id': _bookingModel.carModel.id,
      'address': _bookingModel.address,
      'latitude': _bookingModel.latitude,
      'longitude': _bookingModel.longitude,
    })}');
    return http.post(
      getUri(Constants.BOOK_NOW_API),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      },
      body: json.encode({
        'mode_of_payment': _bookingModel.modeOfPayment,
        'service_id': _bookingModel.serviceModel.id,
        'car_id': _bookingModel.carModel.id,
        'address': _bookingModel.address,
        'latitude': _bookingModel.latitude,
        'longitude': _bookingModel.longitude,
      }),
    );
  }

  Future<http.Response> bookLater() {
    BookingModel _bookingModel = _commonUtil.bookingModel;
    print(getUri(Constants.BOOK_LATER_API));
    print('Body:${json.encode({
      'mode_of_payment': _bookingModel.modeOfPayment,
      'service_id': _bookingModel.serviceModel.id,
      'car_id': _bookingModel.carModel.id,
      'address': _bookingModel.address,
      'latitude': _bookingModel.latitude,
      'longitude': _bookingModel.longitude,
      'date_time': _bookingModel.dateTime,
    })}');
    return http.post(
      getUri(Constants.BOOK_LATER_API),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      },
      body: json.encode({
        'mode_of_payment': _bookingModel.modeOfPayment,
        'service_id': _bookingModel.serviceModel.id,
        'car_id': _bookingModel.carModel.id,
        'address': _bookingModel.address,
        'latitude': _bookingModel.latitude,
        'longitude': _bookingModel.longitude,
        'date_time': _bookingModel.dateTime,
      }),
    );
  }

  Future<http.Response> repeatService(
      {MyBookingModel booking, String dateTime}) {
    print(getUri(Constants.REPEAT_SERVICE_API));
    if (dateTime != null && dateTime.isNotEmpty) {
      print('Body:${json.encode({
        'mode_of_payment': booking.modeOfPayment,
        'booking_id': booking.bookingId,
        'date_time': dateTime,
      })}');
    } else {
      print('Body:${json.encode({
        'mode_of_payment': booking.modeOfPayment,
        'booking_id': booking.bookingId,
      })}');
    }
    return http.post(
      getUri(Constants.REPEAT_SERVICE_API),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      },
      body: dateTime != null && dateTime.isNotEmpty
          ? json.encode({
              'mode_of_payment': booking.modeOfPayment,
              'booking_id': booking.bookingId,
              'date_time': dateTime,
            })
          : json.encode({
              'mode_of_payment': booking.modeOfPayment,
              'booking_id': booking.bookingId,
            }),
    );
  }

  Future<http.StreamedResponse> updateProfile(
      {UserModel userModel, String profile}) async {
    print(getUri(Constants.UPDATE_PROFILE_API));
    print(userModel.email);
    print(userModel.name);
    print(userModel.dob);
    Uri uri = getUri(Constants.UPDATE_PROFILE_API);
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      'Content-Type': 'application/json',
    });
    if (profile != null && profile.isNotEmpty) {
      var file = await http.MultipartFile.fromPath(
        'profile',
        profile,
      );
      request.files.add(file);
    }
    request.fields.addAll(<String, String>{
      'email': userModel.email,
      'full_name': userModel.name,
      'dob': userModel.dob,
    });
    return request.send();
  }

  Future<http.Response> getBookings(int page) {
    Map<String, dynamic> queryParams = {
      'page': page.toString(),
    };
    print(getUri(Constants.GET_BOOKINGS_API, queryParams: queryParams));
    print(_commonUtil.user.accessToken);
    return http.get(
      getUri(Constants.GET_BOOKINGS_API, queryParams: queryParams),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_commonUtil.user.accessToken}',
      },
    );
  }
}

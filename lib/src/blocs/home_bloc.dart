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
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/network_util.dart';
import '../utils/snackbar_util.dart';
import '../utils/connectivity_util.dart';
import '../utils/navigator_util.dart';

class HomeBloc extends Object with Validators {
  static final HomeBloc _homeBloc = HomeBloc._();
  factory HomeBloc() => _homeBloc;
  HomeBloc._() {
    _networkUtil = NetworkUtil();
    _connectivityUtil = ConnectivityUtil();
    _snackbarUtil = SnackbarUtil();
    _commonUtil = CommonUtil();
    _navigatorUtil = NavigatorUtil();
    _prefsUtil = PrefsUtil();
    key = new GlobalKey();
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
  int _start = 60;
  String accessToken = "",
      refreshToken = "",
      uuid = "",
      createdAt = "",
      updatedAt = "",
      otpId = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key;
  GoogleMapController controller;
  List<String> suggestions = [];
  List<CarModel> carModels = [];

  TextEditingController locationController = TextEditingController();
  TextEditingController carController = TextEditingController();

  BehaviorSubject<List<CarModel>> _carModelList =
      BehaviorSubject<List<CarModel>>.seeded([]);
  BehaviorSubject<CarModel> _carModel = BehaviorSubject<CarModel>();
  BehaviorSubject<List<String>> _suggestion =
      BehaviorSubject<List<String>>.seeded([]);

  Stream<CarModel> get carModel => _carModel.stream;
  CarModel get carModelValue => _carModel.stream.value;
  Function(CarModel) get updateCarModel => _carModel.sink.add;
  Stream<List<CarModel>> get carModelList => _carModelList.stream;
  List<CarModel> get carModelListValue => _carModelList.stream.value;
  Function(List<CarModel>) get updateCarModelList => _carModelList.sink.add;
  Stream<List<String>> get suggestionList => _suggestion.stream;
  List<String> get suggestionListValue => _suggestion.stream.value;
  Function(List<String>) get updateSuggestionList => _suggestion.sink.add;

  void dispose() {
    _carModel.close();
    _carModelList.close();
    _suggestion.close();
  }

  Future<bool> clearAll() async {
    return true;
  }

  void moveMarker() {
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_commonUtil.latitudeValue, _commonUtil.longitudeValue),
            zoom: 14,
          ),
        ),
      );
    }
  }

  void movetoCurrentLocation() {
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_commonUtil.currentLocation.latitude,
                _commonUtil.currentLocation.longitude),
            zoom: 14,
          ),
        ),
      );
    }
  }

  Future<Null> searchAddress(double lat, double lng) async {
    final coordinates = new Coordinates(lat, lng);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    addresses.forEach((address) {
      print(address.toMap().toString());
    });
    if (addresses.length > 0) {
      _commonUtil.updateAutoCompleteText(addresses[0].addressLine);
    }
    // List<Placemark> placemark = await Geolocator()
    //     .placemarkFromCoordinates(lat, lng, localeIdentifier: "en_IN");
    // print(placemark.length);
    // placemark.forEach((place) {
    //   print(place.administrativeArea);
    //   print(place.position);
    //   print(place.subThoroughfare);
    //   print(place.thoroughfare);
    //   print(place.name);
    //   print(place.locality);
    //   print(place.subAdministrativeArea);
    //   print(place.subLocality);
    //   print(place.toJson().toString());
    // });
    // if (placemark.length > 0) {
    //   String locationText = "";
    //   if (placemark[0].thoroughfare.isNotEmpty) {
    //     locationText = placemark[0].thoroughfare;
    //   }
    //   if (placemark[0].name.isNotEmpty && locationText.isEmpty) {
    //     locationText = placemark[0].name;
    //   } else {
    //     locationText = '$locationText, ${placemark[0].name}';
    //   }
    //   if (placemark[0].subLocality.isNotEmpty && locationText.isEmpty) {
    //     locationText = placemark[0].subLocality;
    //   } else if (placemark[0].subLocality.isNotEmpty &&
    //       placemark[0].subLocality != null) {
    //     locationText = '$locationText, ${placemark[0].subLocality}';
    //   }
    //   if (placemark[0].locality.isNotEmpty && locationText.isEmpty) {
    //     locationText = placemark[0].locality;
    //   } else if (placemark[0].locality.isNotEmpty &&
    //       placemark[0].locality != null) {
    //     locationText = '$locationText, ${placemark[0].locality}';
    //   }
    //   if (placemark[0].administrativeArea.isNotEmpty && locationText.isEmpty) {
    //     locationText = placemark[0].administrativeArea;
    //   } else if (placemark[0].administrativeArea.isNotEmpty &&
    //       placemark[0].administrativeArea != null) {
    //     locationText = '$locationText, ${placemark[0].administrativeArea}';
    //   }
    //   _commonUtil.updateAutoCompleteText(locationText);
    // }
  }

  updateSelectedCarModel(String model) {
    print('@@@@@@');
    int index = carModelListValue
        .indexWhere((car) => model.toLowerCase() == car.model.toLowerCase());
    print(index);
    if (index != -1) {
      print(carModelListValue[index].id);
      updateCarModel(carModelListValue[index]);
    }
  }

  Future<bool> updateBookingModel() async {
    print(carModelValue == null);
    if (carModelValue == null) {
      _snackbarUtil.updateMessageHome('Select a car model');
      return false;
    }
    if ((_commonUtil.latitudeValue == null && _commonUtil.latitudeValue > 0) ||
        (_commonUtil.longitudeValue == null &&
            _commonUtil.longitudeValue > 0)) {
      _snackbarUtil.updateMessageHome('Select a location');
      return false;
    }
    print(_commonUtil.latitudeValue);
    print(_commonUtil.longitudeValue);
    _bookingModel = BookingModel(
      modeOfPayment: 'cod',
      carModel: carModelValue,
      latitude: _commonUtil.latitudeValue,
      longitude: _commonUtil.longitudeValue,
      address: _commonUtil.autoCompleteTextLastValue,
      serviceModel: _commonUtil.bookingModel != null
          ? _commonUtil.bookingModel.serviceModel
          : ServiceModel(),
    );
    _commonUtil.updateBookingModel = _bookingModel;
    return true;
  }

  Future<bool> searchCarModelAPI(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        http.Response response = await _networkUtil.seacrhCars();
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          carModels = [];
          suggestions = [];
          Map<String, dynamic> responseBody = json.decode(response.body);
          List<dynamic> responseData = responseBody['data'];
          print(responseData);
          responseData.forEach((data) {
            CarModel car = CarModel.fromMap(data);
            carModels.add(car);
            suggestions.add(car.model);
          });
          print(suggestions.length);
          //print(car);
          updateCarModelList(carModels);
          updateSuggestionList(suggestions);
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

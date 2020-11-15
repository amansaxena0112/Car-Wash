import 'dart:async';
import 'dart:io';

import 'package:autobuff/src/blocs/home_bloc.dart';
import 'package:autobuff/src/blocs/user_bloc.dart';
import 'package:autobuff/src/models/booking_model.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_permissions_helper/enums.dart' as en;
import 'package:flutter_permissions_helper/permissions_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/connectivity_util.dart';
import '../utils/constants.dart';
import '../utils/navigator_util.dart';
import '../utils/permission_util.dart';
import '../models/user_model.dart';

class CommonUtil {
  static final CommonUtil _commonUtil = CommonUtil._();
  factory CommonUtil() => _commonUtil;
  CommonUtil._() {
    _permissionsUtil = PermissionsUtil();
  }

  UserModel _user;
  BookingModel _bookingModel;
  LocationData _currentLocation;
  Location _location;
  String _operatingSystem;
  String _appVersion;
  String _appVersionCode;
  List<String> vehicleModels;
  Map<String, List<String>> vehicleModelBodyTypeMap;
  PermissionsUtil _permissionsUtil;
  ConnectivityUtil _connectivityUtil = ConnectivityUtil();
  BehaviorSubject<bool> _userLoaded = BehaviorSubject<bool>.seeded(false);

  TextEditingController controller = TextEditingController();
  LocationData get currentLocation => _currentLocation;
  set currentLocation(location) => _currentLocation = location;
  UserModel get user => _user;
  BookingModel get bookingModel => _bookingModel;
  get operatingSystem => _operatingSystem;
  get appVersion => _appVersion;
  get appVersionCode => _appVersionCode;

  final _searchData = BehaviorSubject<String>();
  BehaviorSubject<bool> _isSignedIn = BehaviorSubject<bool>();
  BehaviorSubject<bool> _isInitiallySignedIn = BehaviorSubject<bool>();
  BehaviorSubject<bool> _isDarkMode = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _isForceUpdate = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _isUpdateRequired = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _isSuperUser = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<List<String>> _cities = BehaviorSubject<List<String>>();
  BehaviorSubject<bool> _showMiniLoader = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<String> _countryCode = BehaviorSubject<String>.seeded("+91");
  BehaviorSubject<String> _country = BehaviorSubject<String>.seeded("IN");
  BehaviorSubject<double> _latitude = BehaviorSubject<double>.seeded(0.0);
  BehaviorSubject<double> _longitude = BehaviorSubject<double>.seeded(0.0);
  final BehaviorSubject<String> _autoCompleteText =
      BehaviorSubject<String>.seeded('');

  Stream<String> get autoCompleteText => _autoCompleteText.stream;
  String get autoCompleteTextLastValue => _autoCompleteText.value;
  Function(String) get updateAutoCompleteText => _autoCompleteText.sink.add;
  Stream<String> get searchData => _searchData.stream;
  Function(String) get updateSearchData => _searchData.sink.add;
  Stream<bool> get isSignedIn => _isSignedIn.stream;
  Function(bool) get _updateIsSignedIn => _isSignedIn.sink.add;
  Stream<String> get countryCode => _countryCode.stream;
  Function(String) get _updateCountryCode => _countryCode.sink.add;
  Stream<String> get country => _country.stream;
  Function(String) get _updateCountry => _country.sink.add;
  Stream<bool> get showMiniLoader => _showMiniLoader.stream;
  bool get showMiniLoaderLastvalue => _showMiniLoader.value;
  Function(bool) get _updateShowMiniLoader => _showMiniLoader.sink.add;
  Stream<bool> get isSuperUser => _isSuperUser.stream;
  Function(bool) get updateIsSuperUser => _isSuperUser.sink.add;
  Stream<bool> get isInitiallySignedIn => _isInitiallySignedIn.stream;
  Function(bool) get updateIsInitiallySignedIn => _isInitiallySignedIn.sink.add;
  Stream<bool> get isDarkMode => _isDarkMode.stream;
  Function(bool) get updateIsDarkMode => _isDarkMode.sink.add;
  Stream<bool> get isForceUpdate => _isForceUpdate.stream;
  bool get isForceUpdateValue => _isForceUpdate.value;
  Function(bool) get updateIsForceUpdate => _isForceUpdate.sink.add;
  Function(bool) get updateIsUpdateRequired => _isUpdateRequired.sink.add;
  Stream<bool> get isUpdateRequired => _isUpdateRequired.stream;
  bool get isUpdateRequiredLatValue => _isUpdateRequired.value;
  bool get isSIgnedInLastValue => _isSignedIn.value;
  String get countryCodeValue => _countryCode.value;
  String get countryValue => _country.value;
  Stream<List<String>> get cities => _cities.stream;
  Function(List<String>) get updateCities => _cities.sink.add;
  List<String> get citiesLastValue => _cities.value;
  Stream<bool> get userLoaded => _userLoaded.stream;
  Function(bool) get updateUserLoaded => _userLoaded.sink.add;
  double get latitudeValue => _latitude.value;
  Stream<double> get latitude => _latitude.stream;
  Function(double) get updateLatitude => _latitude.sink.add;
  double get longitudeValue => _longitude.value;
  Stream<double> get longitude => _longitude.stream;
  Function(double) get updateLongitude => _longitude.sink.add;

  void dispose() {
    _isSignedIn.close();
    _cities.close();
    _isInitiallySignedIn.close();
    _isForceUpdate.close();
    _isSuperUser.close();
    _isUpdateRequired.close();
    _showMiniLoader.close();
    _userLoaded.close();
    _isDarkMode.close();
    _countryCode.close();
    _country.close();
    _searchData.close();
    _latitude.close();
    _longitude.close();
    _autoCompleteText.close();
  }

  Future<bool> clearAll() async {
    controller.clear();
    updateSearchData(null);
    return true;
  }

  Future init(
    bool isSignedIn,
    List<String> cities,
    bool isLocationPermissionEnabled,
    BuildContext context,
  ) async {
    updateOperatingSystem();
    await updateAppDetails();
    checkFirebaseUpdate(isSignedIn, context);
    updateCities(cities);
    updateIsSignedIn(isSignedIn);
    if (isLocationPermissionEnabled) {
      initCurrentLocation();
    }
  }

  String getDateTimeString(DateTime dateTime, String _format) {
    DateFormat format = DateFormat(_format);
    return format.format(dateTime);
  }

  set updateUser(UserModel user) {
    _user = user;
  }

  set updateBookingModel(BookingModel bookingModel) {
    _bookingModel = bookingModel;
  }

  void updateIsSignedIn(
    bool isSignedIn,
  ) {
    if (isSignedIn != _isSignedIn.value) {
      _updateIsSignedIn(isSignedIn);
    }
  }

  void updateCountryCode(
    String code,
  ) {
    _updateCountryCode(code);
  }

  void updateCountry(
    String country,
  ) {
    _updateCountry(country);
  }

  void nullifySignedInDetails() {
    updateIsSignedIn(false);
    updateCities(null);
    //updateUser = null;
  }

  Future<bool> initCurrentLocation() async {
    print('22222222222');
    print(_location);
    if (_location == null) {
      try {
        _location = Location();
        _location.onLocationChanged().listen((location) {
          // print(location.latitude);
          // print(location.longitude);
          if (_commonUtil.currentLocation == null) {
            _commonUtil.currentLocation = location;
            // updateLatitude(currentLocation.latitude);
            // updateLongitude(currentLocation.longitude);
          }
        });
        _commonUtil.currentLocation = await _location.getLocation();
        updateLatitude(currentLocation.latitude);
        updateLongitude(currentLocation.longitude);
        UserBloc().updateIsPermissionEnabled(true);
        HomeBloc().moveMarker();
        return true;
      } on PlatformException {
        return false;
      }
    } else if (_commonUtil.currentLocation == null) {
      _commonUtil.currentLocation = await _location.getLocation();
      updateLatitude(currentLocation.latitude);
      updateLongitude(currentLocation.longitude);
      HomeBloc().moveMarker();
      UserBloc().updateIsPermissionEnabled(true);
      return true;
    } else {
      return true;
    }
  }

  void updateOperatingSystem() {
    _operatingSystem = Platform.isAndroid ? 'Android' : 'iOS';
  }

  Future<Null> updateAppDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersionCode = packageInfo.buildNumber;
    _appVersion = packageInfo.version;
  }

  void makeCall(BuildContext context, String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    bool isEnabled = true;
    en.PermissionStatus permissionStatus;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 23) {
        permissionStatus =
            await _permissionsUtil.requestPermission(Permission.CallPhone);
        isEnabled = permissionStatus == en.PermissionStatus.Granted;
      }
    }
    if (isEnabled && await canLaunch(url)) {
      await launch(url);
    } else if (permissionStatus == en.PermissionStatus.DeniedAndDisabled) {
      String number = phoneNumber.startsWith(CommonUtil().countryCodeValue)
          ? phoneNumber.substring(CommonUtil().countryCodeValue.length)
          : phoneNumber;
      openSettings(
          context, 'Telephone permission is disabled. Phone number: $number');
    }
  }

  Future<bool> openSettings(BuildContext context, String message) {
    NavigatorUtil _navigatorUtil = NavigatorUtil();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Permission Alert'),
          content: Text(message),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => _navigatorUtil.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              color: Colors.grey,
            ),
            RaisedButton(
              onPressed: () async {
                _permissionsUtil.openSettings();
                _navigatorUtil.pop(context);
              },
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlue[300],
            ),
          ],
        );
      },
    );
  }

  Future checkFirebaseUpdate(bool isSignedIn, BuildContext context) async {
    if (Platform.isIOS) {
      updateIsUpdateRequired(false);
      updateIsInitiallySignedIn(isSignedIn);
    } else {
      String versionCode = "0", forceUpdate = "";
      if (_connectivityUtil.isConnectionActive) {
        final RemoteConfig remoteConfig = await RemoteConfig.instance;
        // Enable developer mode to relax fetch throttling
        remoteConfig.setConfigSettings(RemoteConfigSettings(
            debugMode: !bool.fromEnvironment('dart.vm.product')));
        remoteConfig.setDefaults(<String, dynamic>{
          Constants.KEY_CURRENT_VERSION: _appVersionCode,
        });

        await remoteConfig.fetch(expiration: Duration(seconds: 30));
        await remoteConfig.activateFetched();
        versionCode = remoteConfig.getString(Constants.KEY_CURRENT_VERSION);
        forceUpdate = remoteConfig.getString(Constants.KEY_UPDATE_REQUIRED);
      }
      if (int.parse(versionCode) > int.parse(_appVersionCode)) {
        if (isSignedIn && forceUpdate == "true") {
          updateIsForceUpdate(true);
        }
        updateIsInitiallySignedIn(false);
        updateIsUpdateRequired(true);
      } else {
        updateIsInitiallySignedIn(isSignedIn);
        updateIsUpdateRequired(false);
      }
    }
  }

  String formatDateYMD(String date) {
    List<String> dateFragments = date.split('/');
    return '${dateFragments[2]}-${dateFragments[1]}-${dateFragments[0]}';
  }

  String formatDateDMY(String date) {
    List<String> dateFragments = date.split('-');
    return '${dateFragments[2]}/${dateFragments[1]}/${dateFragments[0]}';
  }

  String getFormattedDateFromIsoDateString(String date, String _format) {
    DateTime parsedDate = DateTime.tryParse(date).toLocal();
    return DateFormat.yMMMMd("en_US").add_Hm().format(parsedDate);
  }

  Future resetApp() async {
    // DbUtil dbUtil = DbUtil();
    // await dbUtil.clearTimeStamp();
    // await dbUtil.clearDrivers();
    // await dbUtil.clearVendorTimeStamp();
    // await dbUtil.clearFleets();
  }

  void updateShowMiniLoader(bool value) {
    if (_updateShowMiniLoader != _showMiniLoader.value) {
      _updateShowMiniLoader(value);
    }
  }
}

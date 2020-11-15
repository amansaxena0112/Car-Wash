import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:autobuff/src/models/auto_complete_location.dart';
import 'package:flutter_permissions_helper/enums.dart';
import 'package:autobuff/src/blocs/home_bloc.dart';
import 'package:autobuff/src/models/user_model.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:autobuff/src/utils/constants.dart';
import 'package:autobuff/src/utils/permission_util.dart';
import 'package:autobuff/src/utils/prefs_util.dart';
import 'package:autobuff/src/validators/validator.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/network_util.dart';
import '../utils/snackbar_util.dart';
import '../utils/connectivity_util.dart';
import '../utils/navigator_util.dart';

class UserBloc extends Object with Validators {
  static final UserBloc _userBloc = UserBloc._();
  factory UserBloc() => _userBloc;
  UserBloc._() {
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
  NetworkUtil _networkUtil;
  NavigatorUtil _navigatorUtil;
  CommonUtil _commonUtil;
  ConnectivityUtil _connectivityUtil;
  PrefsUtil _prefsUtil;
  PermissionsUtil _permissionsUtil = PermissionsUtil();
  SnackbarUtil _snackbarUtil;
  int _start = 60;
  String accessToken = "",
      refreshToken = "",
      uuid = "",
      createdAt = "",
      updatedAt = "",
      otpId = "";
  bool initialised = false;
  bool redirectable = false;

  List<TextEditingController> preferredLocationControllers = [];
  List<AutoCompleteLocationResponse> autoCompleteResults = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  final BehaviorSubject<String> _userName = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<String> _email = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<String> _mobile = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<String> _password = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<String> _otp = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<String> _dob = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<DateTime> _selectedDate =
      BehaviorSubject<DateTime>.seeded(DateTime.now());
  final BehaviorSubject<String> _profile = BehaviorSubject<String>.seeded("");
  final BehaviorSubject<File> _image = BehaviorSubject<File>();
  final BehaviorSubject<int> _timer = BehaviorSubject<int>.seeded(60);
  final BehaviorSubject<bool> _isTimerRunning =
      BehaviorSubject<bool>.seeded(true);
  final BehaviorSubject<bool> _isOTPDone = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<List<AutoCompleteLocationResponse>>
      _autoCompleteResponses =
      BehaviorSubject<List<AutoCompleteLocationResponse>>();
  final BehaviorSubject<List<TextEditingController>> _preferredLocations =
      BehaviorSubject<List<TextEditingController>>();
  final BehaviorSubject<bool> _isPermissionEnabled =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<UserModel> _userModel = BehaviorSubject<UserModel>();
  final BehaviorSubject<int> _loadingTimer = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<bool> _isLoadingTimerRunning =
      BehaviorSubject<bool>.seeded(true);

  // UserModel get user => _user;

  Stream<String> get otp => _otp.stream;
  String get otpValue => _otp.stream.value;
  Function(String) get _updateOTP => _otp.sink.add;
  Stream<String> get userName => _userName.stream.transform(isStringNull);
  String get userNameValue => _userName.stream.value;
  Function(String) get updateUserName => _userName.sink.add;
  Stream<String> get email => _email.stream.transform(isStringNull);
  String get emailValue => _email.stream.value;
  Function(String) get updateEmail => _email.sink.add;
  Stream<String> get mobile => _mobile.stream.transform(isStringNull);
  String get mobileValue => _mobile.stream.value;
  Function(String) get updateMobile => _mobile.sink.add;
  Stream<String> get password => _password.stream.transform(isStringNull);
  String get passwordValue => _password.stream.value;
  Function(String) get updatePassword => _password.sink.add;
  Stream<int> get timer => _timer.stream;
  int get timerValue => _timer.stream.value;
  Function(int) get _updateTimer => _timer.sink.add;
  Stream<bool> get isTimerRunning => _isTimerRunning.stream;
  bool get isTimerRunningValue => _isTimerRunning.stream.value;
  Function(bool) get _updateIsTimerRunning => _isTimerRunning.sink.add;
  Stream<bool> get isOTPDone => _isOTPDone.stream;
  bool get isOTPDoneValue => _isOTPDone.stream.value;
  Function(bool) get _updateIsOTPDone => _isOTPDone.sink.add;
  Stream<String> get dob => _dob.stream;
  String get dobValue => _dob.stream.value;
  Function(String) get updateDOB => _dob.sink.add;
  Stream<String> get profile => _profile.stream;
  String get profileValue => _profile.stream.value;
  Function(String) get updateProfile => _profile.sink.add;
  Stream<File> get image => _image.stream;
  File get imageValue => _image.stream.value;
  Function(File) get updateImage => _image.sink.add;
  Stream<DateTime> get selectedDate => _selectedDate.stream;
  DateTime get selectedDateValue => _selectedDate.stream.value;
  Function(DateTime) get updateSelectedDate => _selectedDate.sink.add;
  Stream<List<AutoCompleteLocationResponse>> get autoCompleteResponses =>
      _autoCompleteResponses.stream;
  List<AutoCompleteLocationResponse> get autoCompleteResponsesLastValue =>
      _autoCompleteResponses.value;
  Function(List<AutoCompleteLocationResponse>)
      get updateAutoCompleteResponses => _autoCompleteResponses.sink.add;
  Stream<List<TextEditingController>> get preferredLocations =>
      _preferredLocations.stream;
  List<TextEditingController> get preferredLocationsLastValue =>
      _preferredLocations.value;
  Function(List<TextEditingController>) get updatePreferredLocations =>
      _preferredLocations.sink.add;
  Stream<bool> get isPermissionEnabled => _isPermissionEnabled.stream;
  bool get isPermissionEnabledValue => _isPermissionEnabled.stream.value;
  Function(bool) get updateIsPermissionEnabled => _isPermissionEnabled.sink.add;
  Stream<UserModel> get userModel => _userModel.stream;
  UserModel get userModelValue => _userModel.stream.value;
  Function(UserModel) get updateUserModel => _userModel.sink.add;
  Stream<int> get loadingTimer => _loadingTimer.stream;
  int get loadingTimerValue => _loadingTimer.stream.value;
  Function(int) get _updateLoadingTimer => _loadingTimer.sink.add;
  Stream<bool> get isLoadingTimerRunning => _isLoadingTimerRunning.stream;
  bool get isLoadingTimerRunningValue => _isLoadingTimerRunning.stream.value;
  Function(bool) get _updateIsLoadingTimerRunning =>
      _isLoadingTimerRunning.sink.add;

  void dispose() {
    _otp.close();
    _userName.close();
    _email.close();
    _mobile.close();
    _password.close();
    _isTimerRunning.close();
    _timer.close();
    _isOTPDone.close();
    _dob.close();
    _profile.close();
    _image.close();
    _autoCompleteResponses.close();
    _preferredLocations.close();
    _selectedDate.close();
    _isPermissionEnabled.close();
    _userModel.close();
    _loadingTimer.close();
    _isLoadingTimerRunning.close();
  }

  Future<bool> clearAll() async {
    return true;
  }

  void startTimer(BuildContext context, int start) {
    _start = start;
    _updateIsTimerRunning(true);
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) => setState(context, timer));
  }

  void setState(BuildContext context, Timer timer) {
    if (_start < 1) {
      timer.cancel();
      _updateIsTimerRunning(false);
      //initApp(context);
    } else {
      _start = _start - 1;
      _updateTimer(_start);
    }
  }

  void startLoadingTimer(BuildContext context, int start) {
    print('start');
    _start = start;
    _updateIsLoadingTimerRunning(true);
    const oneSec = const Duration(milliseconds: 1);
    Timer.periodic(oneSec, (Timer timer) => setLoadingState(context, timer));
  }

  void setLoadingState(BuildContext context, Timer timer) {
    print(_start);
    if (_start == 10000) {
      if (redirectable) {
        _navigatorUtil.navigateToScreen(context, '/home', replace: true);
      }
      timer.cancel();
      _updateIsLoadingTimerRunning(false);
      //initApp(context);
    } else {
      _start = _start + 1;
      _updateLoadingTimer(_start);
    }
  }

  updateOTP(String otp) {
    _updateOTP(otp);
    if (otpValue.length == 4) {
      _updateIsOTPDone(true);
    } else {
      _updateIsOTPDone(false);
    }
  }

  void resetPassword(BuildContext context) {
    if (mobileValue == null || mobileValue.isEmpty || mobileValue.length < 10) {
      _snackbarUtil.updateMessageForget('Please enter 10 digit mobile number');
      return;
    }
    _resetPassword(context);
  }

  void updatePreferredLocationResult(
      int index, AutoCompleteLocationResponse res) {
    autoCompleteResults = autoCompleteResponsesLastValue;
    autoCompleteResults[index] = res;
    updateAutoCompleteResponses(autoCompleteResults);
  }

  void deletePreferredLocation(int index) {
    preferredLocationControllers.removeAt(index);
    autoCompleteResults.removeAt(index);
    updatePreferredLocations(preferredLocationControllers);
    updateAutoCompleteResponses(autoCompleteResults);
  }

  void addPreferredLocation() {
    if (preferredLocationControllers.length < 4) {
      TextEditingController textController = TextEditingController();
      AutoCompleteLocationResponse response =
          AutoCompleteLocationResponse(null, null, null);
      preferredLocationControllers.add(textController);
      autoCompleteResults.add(response);
      updatePreferredLocations(preferredLocationControllers);
      updateAutoCompleteResponses(autoCompleteResults);
      //updateIsShowAddLocations(false);
    }
  }

  Future<Null> initApp(BuildContext context) async {
    bool isLocationPermissionEnabled = true;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> prefsValues = await _prefsUtil.init();
    String token = prefsValues[Constants.ACCESS_TOKEN];
    if (Platform.isAndroid) {
      //uuid = await ImeiPlugin.getId();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      //deviceID = androidInfo.androidId;
      if (androidInfo.version.sdkInt >= 23) {
        isLocationPermissionEnabled = await _permissionsUtil
            .checkPermission(Permission.AccessFineLocation);
        // isContactPermissionEnabled =
        //     await _permissionsUtil.checkPermission(Permission.ReadContacts);
      }
    }
    initialised = true;
    if (!isLocationPermissionEnabled) {
      if (Platform.isIOS) {
        _commonUtil.openSettings(
            context, 'Location access permission is disabled.');
      } else {
        PermissionStatus permissionStatus =
            await _permissionsUtil.requestLocationPermission();
        if (_permissionsUtil.isLocationPermissionEnabled) {
          //isSignedIn = await _signIn(context);
          await _commonUtil.initCurrentLocation();
          if (token != null && token.isNotEmpty) {
            accessToken = token;
            _user = UserModel(
              accessToken: accessToken,
            );
            _commonUtil.updateUser = _user;
            bool isValid = await _profileApi(context);
            if (isValid) {
              await HomeBloc().searchCarModelAPI(context);
              //_navigatorUtil.navigateToScreen(context, '/home', replace: true);
            }
          }
        } else if (permissionStatus == PermissionStatus.DeniedAndDisabled) {
          _commonUtil.openSettings(
              context, 'Location access permission is disabled.');
        }
      }
    } else {
      _commonUtil.initCurrentLocation();
      if (token != null && token.isNotEmpty) {
        accessToken = token;
        _user = UserModel(
          accessToken: accessToken,
        );
        print(_user.accessToken);
        _commonUtil.updateUser = _user;
        bool isValid = await _profileApi(context);
        if (isValid) {
          await HomeBloc().searchCarModelAPI(context);
          //_navigatorUtil.navigateToScreen(context, '/home', replace: true);
        }
      }
    }
  }

  Future<bool> saveDetails(BuildContext context) async {
    print('@@@@@@');
    if (userNameValue == null || userNameValue.isEmpty) {
      updateUserName(null);
      return false;
    }
    if (emailValue == null ||
        emailValue.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailValue)) {
      updateEmail(null);
      return false;
    }
    if (mobileValue == null || mobileValue.isEmpty || mobileValue.length < 10) {
      updateMobile(null);
      return false;
    }
    if (passwordValue == null || passwordValue.isEmpty) {
      updatePassword(null);
      return false;
    }
    print('object');
    _user = UserModel(
      name: userNameValue,
      email: emailValue,
      mobile: mobileValue,
      password: passwordValue,
    );
    return await _signupApi(context);
  }

  updateDataFromModel() {
    updateUserName(_user.name);
    nameController.text = _user.name;
    updateEmail(_user.email);
    emailController.text = _user.email;
    updateMobile(_user.mobile);
    mobileController.text = _user.mobile;
    updateDOB(_user.dob);
    dobController.text = _user.dob;
    updateProfile(_user.profile);
  }

  Future<bool> login(BuildContext context) async {
    print('@@@@@@');
    if (mobileValue == null || mobileValue.isEmpty || mobileValue.length < 10) {
      updateMobile(null);
      return false;
    }
    if (passwordValue == null || passwordValue.isEmpty) {
      updatePassword(null);
      return false;
    }
    print('object');
    _user = UserModel(
      mobile: mobileValue,
      password: passwordValue,
    );
    return await _loginApi(context);
  }

  Future<bool> _resetPassword(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        _navigatorUtil.showLoader(context, 'Please wait...');
        http.Response response =
            await _networkUtil.resetPassword(mobile: mobileValue);
        _navigatorUtil.hideLoader(context, true);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageForget('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          //_navigatorUtil.pop(context);
          Map<dynamic, dynamic> responseMap = json.decode(response.body);
          _snackbarUtil.updateMessageForget(responseMap['message'].toString());
          return true;
        } else {
          Map<dynamic, dynamic> responseMap = json.decode(response.body);
          if (responseMap['errorMsg'] != null) {
            _snackbarUtil
                .updateMessageForget(responseMap['errorMsg'].toString());
          } else {
            _snackbarUtil.updateMessageForget(
                'Unable to reach our server. Check network connection');
          }
          return false;
        }
      } catch (ex, t) {
        print(ex);
        print(t);
        return false;
      }
    } else {
      _snackbarUtil
          .updateMessageForget('No network available. Check your connection');
      return false;
    }
  }

  Future<bool> _signupApi(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        _navigatorUtil.showLoader(context, 'Please wait...');
        http.Response response = await _networkUtil.signUp(userModel: _user);
        _navigatorUtil.hideLoader(context, true);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          otpId = responseData['otp_id'];
          _navigatorUtil.navigateToScreen(context, '/otp');
          return true;
        } else {
          Map<dynamic, dynamic> responseMap = json.decode(response.body);
          if (responseMap['errorMsg'] != null) {
            _snackbarUtil
                .updateMessageSignup(responseMap['errorMsg'].toString());
            if (responseMap['errorMsg'].toString().contains('password')) {
              updatePassword(null);
            }
          } else {
            _snackbarUtil.updateMessageSignup(
                'Unable to reach our server. Check network connection');
          }
          return false;
        }
      } catch (ex, t) {
        print(ex);
        print(t);
        return false;
      }
    } else {
      _snackbarUtil
          .updateMessageSignup('No network available. Check your connection');
      return false;
    }
  }

  Future<bool> _loginApi(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        _navigatorUtil.showLoader(context, 'Please wait...');
        http.Response response = await _networkUtil.login(userModel: _user);
        _navigatorUtil.hideLoader(context, true);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageLogin('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          accessToken = responseData['token'];
          print(accessToken);
          _user = UserModel(
            mobile: mobileValue,
            password: passwordValue,
            accessToken: accessToken,
          );
          _commonUtil.updateUser = _user;
          _prefsUtil.prefs.setString(Constants.ACCESS_TOKEN, accessToken);
          await _profileApi(context);
          await HomeBloc().searchCarModelAPI(context);
          print('success');
          _navigatorUtil.navigateAndPopScreen(context, '/home');
          return true;
        } else {
          Map<dynamic, dynamic> responseMap = json.decode(response.body);
          if (responseMap['errorMsg'] != null) {
            _snackbarUtil
                .updateMessageLogin(responseMap['errorMsg'].toString());
          } else {
            _snackbarUtil.updateMessageLogin(
                'Unable to reach our server. Check network connection');
          }
          return false;
        }
      } catch (ex, t) {
        print(ex);
        print(t);
        return false;
      }
    } else {
      _snackbarUtil
          .updateMessageLogin('No network available. Check your connection');
      return false;
    }
  }

  Future<bool> _profileApi(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        //_navigatorUtil.showLoader(context, 'Please wait...');
        http.Response response = await _networkUtil.getProfile();
        //_navigatorUtil.hideLoader(context, true);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          _user = UserModel.fromMap(responseData['data']);
          _user.accessToken = accessToken;
          print(accessToken);
          print(_user.accessToken);
          _commonUtil.updateUser = _user;
          updateDataFromModel();
          updateUserModel(_user);
          redirectable = true;
          //_prefsUtil.prefs.setString(Constants.ACCESS_TOKEN, accessToken);
          //await HomeBloc().searchCarModelAPI(context);
          //_navigatorUtil.navigateToHomeScreen(context);
          return true;
        } else {
          Map<dynamic, dynamic> responseMap = json.decode(response.body);
          if (responseMap['errorMsg'] != null) {
            _snackbarUtil
                .updateMessageSignup(responseMap['errorMsg'].toString());
          } else {
            _snackbarUtil.updateMessageSignup(
                'Unable to reach our server. Check network connection');
          }
          return false;
        }
      } catch (ex, t) {
        print(ex);
        print(t);
        return false;
      }
    } else {
      _snackbarUtil
          .updateMessageSignup('No network available. Check your connection');
      return false;
    }
  }

  Future<bool> resendOTP(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        _navigatorUtil.showLoader(context, 'Please wait...');
        http.Response response = await _networkUtil.resendOTP(otpID: otpId);
        _navigatorUtil.hideLoader(context, true);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
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

  Future<bool> verifyOTP(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        initialised = true;
        _navigatorUtil.showLoader(context, 'Please wait...');
        http.Response response =
            await _networkUtil.verifyOTP(otpID: otpId, otp: otpValue);
        _navigatorUtil.hideLoader(context, true);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          accessToken = responseData['token'];
          _user = UserModel(
            name: userNameValue,
            email: emailValue,
            mobile: mobileValue,
            password: passwordValue,
            accessToken: accessToken,
          );
          _commonUtil.updateUser = _user;
          updateUserModel(_user);
          _prefsUtil.prefs.setString(Constants.ACCESS_TOKEN, accessToken);
          await HomeBloc().searchCarModelAPI(context);
          _navigatorUtil.navigateAndPopScreen(context, '/home');
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

  Future<bool> saveProfile() async {
    if (userNameValue == null || userNameValue.isEmpty) {
      _snackbarUtil.updateMessageProfile('Enter user name');
      return false;
    }
    if (emailValue == null || emailValue.isEmpty) {
      _snackbarUtil.updateMessageProfile('Enter user email');
      return false;
    }
    if (dobValue == null || dobValue.isEmpty) {
      _snackbarUtil.updateMessageProfile('Enter user dob');
      return false;
    }
    _user.email = emailValue;
    _user.name = userNameValue;
    _user.dob = dobValue;
    return true;
  }

  Future<bool> updateProfileAPI(BuildContext context) async {
    if (_connectivityUtil.isConnectionActive) {
      try {
        _navigatorUtil.showLoader(context, 'Please wait...');
        http.StreamedResponse response = await _networkUtil.updateProfile(
            profile: imageValue != null ? imagePath : '', userModel: _user);
        _navigatorUtil.hideLoader(context, true);
        if (response.statusCode == 500) {
          _snackbarUtil.updateMessageSignup('Something went wrong!');
          return false;
        } else if (response.statusCode == 200) {
          await response.stream.bytesToString().then((onValue) {
            if (onValue.runtimeType.toString() == 'String') {
              Map<String, dynamic> responseData =
                  json.decode(onValue.toString());
              _user = UserModel.fromMap(responseData['profile']);
              _snackbarUtil.updateMessageProfile(responseData['message']);
              _commonUtil.updateUser = _user;
              print(_user.dob);
            }
          });
          return true;
        } else {
          await response.stream.bytesToString().then((onValue) {
            if (onValue.runtimeType.toString() == 'String') {
              Map<String, dynamic> responseData =
                  json.decode(onValue.toString());
              _snackbarUtil.updateMessageProfile(responseData['errorMsg']);
            }
          });
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

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateValue,
        firstDate: DateTime(1900, 1, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDateValue)
      updateDOB('${picked.year}-${picked.month}-${picked.day}');
  }

  Future updateImageFile(
      BuildContext context, ImageSource source, String title) async {
    NavigatorUtil navigatorUtil = NavigatorUtil();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    }
    PermissionStatus permissionStatus;
    bool isEnabled = true;
    if (Platform.isIOS ||
        (Platform.isAndroid && androidInfo.version.sdkInt >= 23)) {
      PermissionsUtil permissionUtil = PermissionsUtil();
      permissionStatus = await permissionUtil.requestPermission(
          source == ImageSource.gallery
              ? Platform.isIOS
                  ? Permission.PhotoLibrary
                  : Permission.ReadExternalStorage
              : Permission.Camera);
      isEnabled = permissionStatus == PermissionStatus.Granted ? true : false;
    }
    if (isEnabled) {
      navigatorUtil.pop(context);
      File file = await ImagePicker.pickImage(source: source);
      // await _cropImage(file).then((croppedImage) {
      //   file = croppedImage;
      // });
      double fileSize = file.lengthSync() / (1024 * 1024);
      if (file != null) {
        if (fileSize > 1.5) {
          //updateShowLoading(true);
          getTemporaryDirectory().then((dir) async {
            String targetPath =
                '${dir.path}/${title.replaceAll('/', '_')}_${DateTime.now().toString()}.jpg';
            compressAndGetFile({
              'file': file,
              'targetPath': targetPath,
            }).then((compressedImage) {
              updateImageDetails(compressedImage, targetPath);
            });
          });
        } else {
          updateImageDetails(file, file.absolute.path);
        }
      }
    } else if (Platform.isIOS ||
        (Platform.isAndroid &&
            permissionStatus == PermissionStatus.DeniedAndDisabled)) {
      navigatorUtil.pop(context);
      String sourceType = source == ImageSource.camera
          ? 'Camera'
          : Platform.isIOS ? 'Photos' : 'Storage';
      _commonUtil.openSettings(context, '$sourceType permission is disabled.');
    }
  }

  void updateImageDetails(File file, String path) {
    //image = file;
    updateImage(file);
    imagePath = path;
  }

  Future<File> compressAndGetFile(Map<String, dynamic> params) async {
    double fileSize = params['file'].lengthSync() / (1024 * 1024);
    int quality;
    if (fileSize < 3.0) {
      quality = 75;
    } else if (fileSize < 4.0) {
      quality = 50;
    } else {
      quality = 25;
    }
    var result = await FlutterImageCompress.compressAndGetFile(
      params['file'].absolute.path,
      params['targetPath'],
      quality: quality,
    );
    return result;
  }
}

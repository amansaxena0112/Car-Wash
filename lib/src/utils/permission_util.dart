import 'dart:async';
import 'dart:io';
import 'package:autobuff/src/blocs/user_bloc.dart';
import 'package:flutter_permissions_helper/enums.dart';
import 'package:flutter_permissions_helper/permissions_helper.dart';

import '../utils/snackbar_util.dart';

class PermissionsUtil {
  static final PermissionsUtil _permissionsUtil = PermissionsUtil._();
  factory PermissionsUtil() => _permissionsUtil;
  PermissionsUtil._() {
    _snackbarUtil = SnackbarUtil();
  }

  bool _isLocationPermissionEnabled;
  PermissionStatus _locationPermissionStatus;
  SnackbarUtil _snackbarUtil;
  bool get isLocationPermissionEnabled => _isLocationPermissionEnabled;
  PermissionStatus get locationPermissionStatus => _locationPermissionStatus;
  bool _isContactPermissionEnabled;
  PermissionStatus _contactPermissionStatus;
  bool get isContactPermissionEnabled => _isContactPermissionEnabled;
  PermissionStatus get contactPermissionStatus => _contactPermissionStatus;

  Future<bool> init() async {
    return await _initLocationPermission();
  }

  Future<bool> initContact() async {
    return await _initContactPermission();
  }

  Future<bool> _initLocationPermission() async {
    bool isLocationPermissionEnabled =
        await checkPermission(Permission.AccessFineLocation);
    if (isLocationPermissionEnabled) {
      updateLocationPermissionError(PermissionStatus.Granted);
    } else {
      requestLocationPermission();
    }
    return isLocationPermissionEnabled;
  }

  Future<bool> _initContactPermission() async {
    bool isContactPermissionEnabled =
        await checkPermission(Permission.ReadContacts);
    if (isContactPermissionEnabled) {
      updateContactPermissionError(PermissionStatus.Granted);
    } else {
      requestContactPermission();
    }
    return isContactPermissionEnabled;
  }

  Future<PermissionStatus> requestContactPermission() async {
    PermissionStatus contactPermissionStatus =
        await requestPermission(Permission.ReadContacts);
    updateContactPermissionError(contactPermissionStatus);
    return contactPermissionStatus;
  }

  void updateContactPermissionError(PermissionStatus contactPermissionStatus) {
    _contactPermissionStatus = contactPermissionStatus;
    if (contactPermissionStatus == PermissionStatus.Granted) {
      _isContactPermissionEnabled = true;
    } else {
      _isContactPermissionEnabled = false;
      if ((contactPermissionStatus == PermissionStatus.Denied ||
              contactPermissionStatus == PermissionStatus.Undetermined) &&
          !Platform.isIOS) {
        _snackbarUtil.updateMessageHome('Contact permission denied.');
      }
    }
  }

  Future<PermissionStatus> requestLocationPermission() async {
    PermissionStatus locationPermissionStatus =
        await requestPermission(Permission.AccessFineLocation);
    await updateLocationPermissionError(locationPermissionStatus);
    return locationPermissionStatus;
  }

  Future<bool> updateLocationPermissionError(
      PermissionStatus locationPermissionStatus) async {
    _locationPermissionStatus = locationPermissionStatus;
    if (locationPermissionStatus == PermissionStatus.Granted) {
      _isLocationPermissionEnabled = true;
      UserBloc().updateIsPermissionEnabled(true);
    } else {
      _isLocationPermissionEnabled = false;
      UserBloc().updateIsPermissionEnabled(false);
      if ((locationPermissionStatus == PermissionStatus.Denied ||
              locationPermissionStatus == PermissionStatus.Undetermined) &&
          !Platform.isIOS) {
        _snackbarUtil.updateMessageHome('Location permission denied.');
      }
    }
    return true;
  }

  Future<bool> checkPermission(Permission permission) async {
    return await PermissionsHelper.hasPermission(permission);
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await PermissionsHelper.requestPermission(permission);
  }

  Future<bool> openSettings() {
    return PermissionsHelper.openSettings();
  }
}

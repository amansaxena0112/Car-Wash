import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../utils/network_util.dart';
import '../utils/connectivity_util.dart';

class NotificationBloc {
  static final NotificationBloc _notificationBloc = NotificationBloc._();
  factory NotificationBloc() => _notificationBloc;
  NotificationBloc._() {
    _networkUtil = NetworkUtil();
    _connectivityUtil = ConnectivityUtil();
    //_snackbarUtil = SnackbarUtil();
    _searchData.listen((searchWord) {
      //_filterNotifications();
    });
  }

  NetworkUtil _networkUtil;
  ConnectivityUtil _connectivityUtil;
  // SnackbarUtil _snackbarUtil;

  // final BehaviorSubject<List<NotificationModel>> _notifications =
  //     BehaviorSubject<List<NotificationModel>>.seeded([]);
  final BehaviorSubject<bool> _isActionTaken = BehaviorSubject<bool>();
  final BehaviorSubject<String> _reasonForRejection = BehaviorSubject<String>();
  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _isSearchEnabled = BehaviorSubject<bool>();
  final _searchData = BehaviorSubject<String>();
  final BehaviorSubject<int> _currentNotification = BehaviorSubject<int>();

  //List<NotificationModel> notificationMasterList = [];

  // Stream<List<NotificationModel>> get notifications => _notifications.stream;
  // Function(List<NotificationModel>) get updateNotifications =>
  //     _notifications.sink.add;
  Stream<bool> get isActionTaken => _isActionTaken.stream;
  Function(bool) get updateIsActionTaken => _isActionTaken.sink.add;
  Stream<String> get reasonForRejection => _reasonForRejection.stream;
  Function(String) get updateReasonForRejection => _reasonForRejection.sink.add;

  Stream<bool> get isLoading => _isLoading.stream;
  Function(bool) get updateIsLoading => _isLoading.sink.add;

  // Stream<DriverModel> get activeNotification => _activeNotification.stream;
  // Function(DriverModel) get _updateActiveNotification =>
  //     _activeNotification.sink.add;

  Stream<int> get currentNotification => _currentNotification.stream;
  int get currentNotificationId => _currentNotification.value;
  Function(int) get updateCurrentNotification => _currentNotification.sink.add;

  void dispose() {
    //_notifications.close();
    //_activeNotification.close();
    _isActionTaken.close();
    _reasonForRejection.close();
    _isLoading.close();
    _isSearchEnabled.close();
    _searchData.close();
    _currentNotification.close();
  }

  // int notificationsCount() {
  //   return _notifications.value.length;
  // }

  Future<dynamic> onNotification(Map<String, dynamic> notification) {
    try {
      //fetchNotifications();
    } catch (ex, t) {
      print(ex);
      print(t);
    }
    return null;
  }

  // Future<bool> fetchNotifications() async {
  //   if (_connectivityUtil.isConnectionActive) {
  //     print('fetching notifications..');
  //     try {
  //       http.Response response = await _networkUtil.fetchAllNotifications();
  //       print(response.body);
  //       if (response.statusCode == 500) {
  //         _snackbarUtil.updateMessageBaseScreen('Server error.');
  //         //_updateActiveNotification(null);
  //         updateIsLoading(false);
  //         return false;
  //       } else if (response.statusCode == 200) {
  //         Map<String, dynamic> responseData = json.decode(response.body);
  //         List responseNotifications = responseData['data']['notifications'];
  //         List<NotificationModel> notifications = [];
  //         responseNotifications.forEach((notification) {
  //           notifications.add(NotificationModel.fromMap(notification));
  //         });
  //         updateNotifications(notifications);
  //         notificationMasterList = notifications;
  //         updateIsLoading(false);
  //         return true;
  //       } else {
  //         _snackbarUtil.updateMessageBaseScreen('No notifications found.');
  //         updateIsLoading(false);
  //         return false;
  //       }
  //     } catch (ex) {
  //       print(ex);
  //       _snackbarUtil.updateMessageBaseScreen(ex.toString());
  //       return false;
  //     }
  //   } else {
  //     _snackbarUtil.updateMessageBaseScreen(
  //         'No network available. Check your connection');
  //     return false;
  //   }
  // }

  // Future<dynamic> onResume(Map<String, dynamic> message) {
  //   return null;
  // }

  // Future<bool> updateActiveNotification(int id) async {
  //   SnackbarUtil _snackbarUtil = SnackbarUtil();
  //   if (_connectivityUtil.isConnectionActive) {
  //     try {
  //       http.Response response = await _networkUtil.loadDriver(id);
  //       if (response.statusCode == 500) {
  //         _snackbarUtil.updateMessageNotification('Server error.');
  //         _updateActiveNotification(null);
  //         return false;
  //       } else if (response.statusCode == 200) {
  //         Map<String, dynamic> responseData = json.decode(response.body);
  //         List<dynamic> drivers = responseData['result'];
  //         DriverModel driver = DriverModel.fromMap(drivers[0]);
  //         _updateActiveNotification(driver);
  //         updateIsActionTaken(false);
  //         return true;
  //       } else {
  //         _snackbarUtil.updateMessageNotification('No drivers found.');
  //         _updateActiveNotification(null);
  //         return false;
  //       }
  //     } catch (ex) {
  //       _snackbarUtil.updateMessageNotification(ex);
  //       _updateActiveNotification(null);
  //       return false;
  //     }
  //   } else {
  //     _snackbarUtil.updateMessageNotification(
  //         'No network available. Check your connection');
  //     _updateActiveNotification(null);
  //     return false;
  //   }
  // }

  // Future rejectDriverVerification() async {
  //   VerificationModel verification = VerificationModel();
  //   verification.id = _activeNotification.value.id;
  //   verification.isApproved = false;
  //   verification.reason = _reasonForRejection.value;
  //   await _approveOrReject(verification);
  //   updateReasonForRejection(null);
  // }

  // Future approveDriverVerification(BuildContext context) async {
  //   NavigatorUtil navigatorUtil = NavigatorUtil();
  //   navigatorUtil.showLoader(context, 'Approving...');
  //   VerificationModel verification = VerificationModel();
  //   verification.id = _activeNotification.value.id;
  //   verification.isApproved = true;
  //   verification.reason = '';
  //   await _approveOrReject(verification);
  //   navigatorUtil.hideLoader(context, true);
  // }

  // Future _approveOrReject(VerificationModel verification) async {
  //   SnackbarUtil _snackbarUtil = SnackbarUtil();

  //   if (_connectivityUtil.isConnectionActive) {
  //     try {
  //       http.Response response = await _networkUtil.approveDriverVerification(
  //           verification: verification,
  //           notificationId: NotificationBloc().currentNotificationId);
  //       if (response.statusCode == 500) {
  //         _snackbarUtil.updateMessageNotificationDetails('Server error.');
  //       } else {
  //         Map<dynamic, dynamic> body = json.decode(response.body);
  //         if (body['status']) {
  //           updateIsActionTaken(true);
  //           _snackbarUtil.updateMessageNotificationDetails(body['message']);
  //           NotificationBloc().fetchNotifications();
  //         } else {
  //           if (body['message'] != null) {
  //             var message = body['message'];
  //             if (message is String) {
  //               _snackbarUtil.updateMessageNotificationDetails(message);
  //             } else {
  //               List<String> messages = List<String>.from(message);
  //               _snackbarUtil
  //                   .updateMessageNotificationDetails(messages.join(', '));
  //             }
  //           } else {
  //             _snackbarUtil.updateMessageNotificationDetails(
  //                 'Something went wrong. Please try later');
  //           }
  //         }
  //       }
  //     } catch (ex) {
  //       _snackbarUtil.updateMessageNotificationDetails(ex);
  //     }
  //   } else {
  //     _snackbarUtil.updateMessageNotificationDetails(
  //         'No network available. Check your connection');
  //   }
  // }

  // void _filterNotifications() {
  //   if (_searchData.value != null && _searchData.value.trim().isNotEmpty) {
  //     String searchWord = _searchData.value.trim().toLowerCase();
  //     List<NotificationModel> filteredNotificationList = [];
  //     notificationMasterList.forEach((notification) {
  //       if ((notification.message != null &&
  //               notification.message.toLowerCase().contains(searchWord))) {
  //         filteredNotificationList.add(notification);
  //       }
  //     });
  //     updateNotifications(filteredNotificationList);
  //   } else {
  //     updateNotifications(notificationMasterList);
  //   }
  // }

  // void toggleIsQuickFilterEnabled(bool value) {
  //   if (value != null && value == true) {
  //     updateIsSearchEnabled(false);
  //   } else {
  //     updateIsSearchEnabled(true);
  //   }
  // }
}

import 'package:connectivity/connectivity.dart';

class ConnectivityUtil {
  static final ConnectivityUtil _connectivityUtil = ConnectivityUtil._();
  factory ConnectivityUtil() => _connectivityUtil;
  ConnectivityUtil._();

  bool _isConnectionActive;
  Connectivity _connectivity;

  bool get isConnectionActive => _isConnectionActive;

  void init() async {
    _connectivity = Connectivity();

    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      _isConnectionActive = false;
    } else {
      _isConnectionActive = true;
    }
  }
}

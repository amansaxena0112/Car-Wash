import 'package:autobuff/src/blocs/user_bloc.dart';
import 'package:autobuff/src/providers/user_bloc_provider.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:autobuff/src/utils/connectivity_util.dart';
import 'package:autobuff/src/utils/prefs_util.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../utils/constants.dart';
import '../utils/navigator_util.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserBlocProvider(
      child: SplashDetailsBase(),
    );
  }
}

class SplashDetailsBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashDetails(),
    );
  }
}

class SplashDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = UserBlocProvider.getUserBloc(context);
    NavigatorUtil _navigatorUtil = NavigatorUtil();
    CommonUtil _commonUtil = CommonUtil();
    ConnectivityUtil().init();
    PrefsUtil().init();
    _userBloc.startLoadingTimer(context, 0);
    if (!_userBloc.initialised) {
      _userBloc.initApp(context);
    }
    return Scaffold(
      body: StreamBuilder(
          stream: _userBloc.isPermissionEnabled,
          builder:
              (BuildContext context, AsyncSnapshot<bool> isPermissionEnabled) {
            if (isPermissionEnabled.hasData && isPermissionEnabled.data) {
              AlertDialog(
                content: Text('Hello'),
              );
              _userBloc.initApp(context);
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                  bottom: 30.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      maxRadius: MediaQuery.of(context).size.width / 3,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        'assets/splash.png',
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  'Welcome to'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Text(
                                'Auto Buff'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Car washed, delivered'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 40.0,
                      ),
                      child: StreamBuilder(
                          stream: _userBloc.isLoadingTimerRunning,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> isLoadingTimerRunning) {
                            return isLoadingTimerRunning.hasData &&
                                    !isLoadingTimerRunning.data
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        highlightColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 40.0,
                                        ),
                                        child: Text('Sign up',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        color: Colors.blue[400],
                                        onPressed: () async {
                                          // NavigatorUtil navigatorUtil = NavigatorUtil();
                                          // if (await _commonUtil.initCurrentLocation() &&
                                          //     _commonUtil.currentLocation != null)
                                          _navigatorUtil.navigateToScreen(
                                              context, '/signup');
                                        },
                                      ),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        highlightColor: Colors.grey[800],
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 40.0,
                                        ),
                                        child: Text('Log in',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        color: Colors.black,
                                        onPressed: () async {
                                          // NavigatorUtil navigatorUtil = NavigatorUtil();
                                          print(_commonUtil.currentLocation !=
                                              null);
                                          _navigatorUtil.navigateToScreen(
                                              context, '/login');
                                        },
                                      ),
                                    ],
                                  )
                                : StreamBuilder(
                                    stream: _userBloc.loadingTimer,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> timer) {
                                      // if (timer.hasData &&
                                      //     timer.data == 10 &&
                                      //     _userBloc.redirectable) {
                                      //   _navigatorUtil.navigateToScreen(
                                      //       context, '/home',
                                      //       replace: true);
                                      // }
                                      return Container(
                                        width: double.infinity,
                                        height: 65.0,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: LiquidLinearProgressIndicator(
                                          value: timer.hasData
                                              ? timer.data / 10000
                                              : 0.0,
                                          backgroundColor: Colors.white,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue),
                                          borderRadius: 12.0,
                                          center: Text(
                                            "Loading...",
                                            style: TextStyle(
                                              color: Colors.lightBlueAccent,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                          }),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

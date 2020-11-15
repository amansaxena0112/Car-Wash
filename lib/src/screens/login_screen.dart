import 'package:autobuff/src/blocs/user_bloc.dart';
import 'package:autobuff/src/providers/user_bloc_provider.dart';
import 'package:autobuff/src/utils/navigator_util.dart';
import 'package:autobuff/src/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserBlocProvider(
      child: LoginScreenDetails(),
    );
  }
}

class LoginScreenDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreenBody(),
    );
  }
}

class LoginScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = UserBlocProvider.getUserBloc(context);
    NavigatorUtil _navigatorUtil = NavigatorUtil();
    SnackbarUtil _snackbarUtil = SnackbarUtil();
    _snackbarUtil.buildContextLogin = context;
    return Row(
      children: <Widget>[
        Expanded(
          child: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    bottom: 50.0,
                    left: 30.0,
                    right: 30.0,
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          top: 100.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Log in'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(28.0),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              StreamBuilder(
                                  stream: _userBloc.mobile,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> mobile) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.phone_android,
                                            color: mobile.hasData
                                                ? Colors.black
                                                : Colors.red,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Phone number',
                                              hintStyle: TextStyle(
                                                  color: mobile.hasData
                                                      ? Colors.grey[700]
                                                      : Colors.red),
                                              counterText: "",
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                                color: mobile.hasData
                                                    ? Colors.black
                                                    : Colors.red),
                                            maxLength: 10,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: false,
                                                    signed: false),
                                            controller:
                                                _userBloc.mobileController,
                                            onChanged: _userBloc.updateMobile,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: <Widget>[
                              //     Padding(
                              //       padding:
                              //           const EdgeInsets.only(right: 8.0),
                              //       child: Icon(Icons.mail),
                              //     ),
                              //     Expanded(
                              //       child: TextField(
                              //         decoration: InputDecoration(
                              //           hintText: 'Email',
                              //           border: InputBorder.none,
                              //         ),
                              //         // controller: driverBloc.addDriver.nameController,
                              //         // onChanged: driverBloc.addDriver.updateName,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //     top: 10.0,
                              //     bottom: 10.0,
                              //   ),
                              //   child: Container(
                              //     width: MediaQuery.of(context).size.width,
                              //     height: 1.0,
                              //     decoration: BoxDecoration(
                              //       color: Colors.grey,
                              //     ),
                              //   ),
                              // ),
                              StreamBuilder(
                                  stream: _userBloc.password,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> password) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.lock,
                                            color: password.hasData
                                                ? Colors.black
                                                : Colors.red,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Password',
                                              hintStyle: TextStyle(
                                                  color: password.hasData
                                                      ? Colors.grey[700]
                                                      : Colors.red),
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                                color: password.hasData
                                                    ? Colors.black
                                                    : Colors.red),
                                            obscureText: true,
                                            maxLines: 1,
                                            controller:
                                                _userBloc.passwordController,
                                            onChanged: _userBloc.updatePassword,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 100.0,
                    bottom: 30.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        highlightColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: Text('Forgot password?',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            )),
                        onPressed: () {
                          // NavigatorUtil navigatorUtil = NavigatorUtil();
                          _navigatorUtil.navigateToScreen(context, '/forget');
                        },
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                          ),
                        ),
                        highlightColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 50.0,
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
                          await _userBloc.login(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: 15.0,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

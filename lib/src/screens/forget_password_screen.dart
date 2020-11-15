import 'package:autobuff/src/blocs/user_bloc.dart';
import 'package:autobuff/src/providers/user_bloc_provider.dart';
import 'package:autobuff/src/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ForgetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserBlocProvider(
      child: ForgetPasswordScreenDetails(),
    );
  }
}

class ForgetPasswordScreenDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: ForgetPasswordScreenBody(),
    );
  }
}

class ForgetPasswordScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = UserBlocProvider.getUserBloc(context);
    _userBloc.updateMobile("");
    _userBloc.mobileController.clear();
    SnackbarUtil _snackbarUtil = SnackbarUtil();
    _snackbarUtil.buildContextForget = context;
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
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue[50],
                          backgroundImage: AssetImage(
                            'assets/splash.png',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          top: 40.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    'Forgot your'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    'Password'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Select which contact details should we use to reset \nyour password',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 140.0,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 7.0,
                                      bottom: 8.0,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Via sms',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 28.0,
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.phone_android),
                                      ),
                                      Expanded(
                                        child: StreamBuilder(
                                            stream: _userBloc.mobile,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String> mobile) {
                                              return TextField(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter mobile number',
                                                  counterText: "",
                                                  border: InputBorder.none,
                                                ),
                                                maxLength: 10,
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: false,
                                                        signed: false),
                                                controller:
                                                    _userBloc.mobileController,
                                                onChanged:
                                                    _userBloc.updateMobile,
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 20.0),
                            //   child: Container(
                            //     height: 130.0,
                            //     width: MediaQuery.of(context).size.width,
                            //     padding: EdgeInsets.symmetric(
                            //         vertical: 20.0, horizontal: 20.0),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(16.0),
                            //       ),
                            //     ),
                            //     child: Column(
                            //       crossAxisAlignment:
                            //           CrossAxisAlignment.start,
                            //       children: <Widget>[
                            //         Padding(
                            //           padding: const EdgeInsets.only(
                            //             left: 7.0,
                            //             bottom: 8.0,
                            //           ),
                            //           child: Row(
                            //             children: <Widget>[
                            //               Text(
                            //                 'Via email',
                            //                 style: TextStyle(
                            //                     color: Colors.black),
                            //               ),
                            //               Expanded(
                            //                 child: Container(),
                            //               ),
                            //               // Icon(
                            //               //   Icons.check_circle,
                            //               //   color: Colors.green,
                            //               //   size: 28.0,
                            //               // ),
                            //               Container(
                            //                 height: 28.0,
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: <Widget>[
                            //             Padding(
                            //               padding: const EdgeInsets.only(
                            //                   right: 8.0),
                            //               child: Icon(Icons.email),
                            //             ),
                            //             Expanded(
                            //               child: TextField(
                            //                 decoration: InputDecoration(
                            //                   hintText: 'abc@gmail.com',
                            //                   border: InputBorder.none,
                            //                 ),
                            //                 keyboardType: TextInputType
                            //                     .numberWithOptions(
                            //                         decimal: false,
                            //                         signed: false),
                            //                 // controller: driverBloc.addDriver.nameController,
                            //                 // onChanged: driverBloc.addDriver.updateName,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // FlatButton(
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(30.0)),
                      //   highlightColor: Colors.blue,
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 20.0,
                      //     horizontal: 20.0,
                      //   ),
                      //   child: Text('Forgot password?',
                      //       style: TextStyle(
                      //         fontSize: 16.0,
                      //         fontWeight: FontWeight.w600,
                      //       )),
                      //   color: Colors.blue[50],
                      //   onPressed: () {
                      //     // NavigatorUtil navigatorUtil = NavigatorUtil();
                      //     //_navigatorUtil.pop(context);
                      //   },
                      // ),
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
                        child: Text('Reset',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            )),
                        color: Colors.black,
                        onPressed: () {
                          // NavigatorUtil navigatorUtil = NavigatorUtil();
                          _userBloc.resetPassword(context);
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

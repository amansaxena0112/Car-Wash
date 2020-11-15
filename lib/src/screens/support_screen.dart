import 'package:autobuff/src/blocs/support_bloc.dart';
import 'package:autobuff/src/blocs/user_bloc.dart';
import 'package:autobuff/src/providers/support_bloc_provider.dart';
import 'package:autobuff/src/providers/user_bloc_provider.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:autobuff/src/utils/navigator_util.dart';
import 'package:autobuff/src/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SupportBlocProvider(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Support'),
        ),
        body: SupportDetails(),
      ),
    );
  }
}

class SupportDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SupportBloc _supportBloc = SupportBlocProvider.getSupportBloc(context);
    SnackbarUtil _snackbarUtil = SnackbarUtil();
    _snackbarUtil.buildContextSupport = context;
    return Row(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: 15.0,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    bottom: 50.0,
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Please fill the form below to give us valuable feedback.',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      name(_supportBloc),
                      email(_supportBloc),
                      contact(_supportBloc),
                      msg(_supportBloc),
                      nextButton(context, _supportBloc),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.call,
                            size: 28,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0),
                                topRight: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                            ),
                            highlightColor: Colors.grey[800],
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 40.0,
                            ),
                            child: Text('CALL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                )),
                            color: Colors.black,
                            onPressed: () {
                              CommonUtil().makeCall(context, '0000000000');
                              // NavigatorUtil navigatorUtil = NavigatorUtil();
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      // Column(
                      //   children: <Widget>[
                      //     Icon(
                      //       Icons.markunread,
                      //       size: 28,
                      //     ),
                      //     RaisedButton(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.only(
                      //           topLeft: Radius.circular(30.0),
                      //           bottomLeft: Radius.circular(30.0),
                      //           topRight: Radius.circular(0.0),
                      //           bottomRight: Radius.circular(0.0),
                      //         ),
                      //       ),
                      //       highlightColor: Colors.grey[800],
                      //       padding: const EdgeInsets.symmetric(
                      //         vertical: 15.0,
                      //         horizontal: 25.0,
                      //       ),
                      //       child: Text('MESSAGE',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 16.0,
                      //             fontWeight: FontWeight.w600,
                      //           )),
                      //       color: Colors.black,
                      //       onPressed: () {
                      //         // NavigatorUtil navigatorUtil = NavigatorUtil();
                      //       },
                      //     ),
                      //   ],
                      // ),
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

  Widget name(SupportBloc supportBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50.0,
        // left: 20.0,
        // right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Name'),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              // decoration: InputDecoration(
              //   contentPadding:
              //       new EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              //   border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(4.0)),
              //   //hintText: 'Enter your name',
              // ),
              textCapitalization: TextCapitalization.words,
              controller: supportBloc.nameController,
              onChanged: supportBloc.updateName,
            ),
          ),
        ],
      ),
    );
  }

  Widget email(SupportBloc supportBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        // left: 20.0,
        // right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Email'),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              // decoration: InputDecoration(
              //   contentPadding:
              //       new EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              //   border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(4.0)),
              //   //hintText: 'Enter your name',
              // ),
              keyboardType: TextInputType.emailAddress,
              controller: supportBloc.emailController,
              onChanged: supportBloc.updateEmail,
            ),
          ),
        ],
      ),
    );
  }

  Widget msg(SupportBloc supportBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        // left: 20.0,
        // right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Message'),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              // decoration: InputDecoration(
              //   contentPadding:
              //       new EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              //   border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(4.0)),
              //   //hintText: 'Enter your dob',
              // ),
              textCapitalization: TextCapitalization.sentences,
              controller: supportBloc.messageController,
              onChanged: supportBloc.updateMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget contact(SupportBloc supportBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        // left: 20.0,
        // right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Contact Number'),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              // decoration: InputDecoration(
              //   contentPadding:
              //       new EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              //   border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(4.0)),
              //   //hintText: 'Enter your organization name',
              // ),
              keyboardType: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              controller: supportBloc.mobileController,
              onChanged: supportBloc.updateMobile,
            ),
          ),
        ],
      ),
    );
  }

  Widget nextButton(BuildContext context, SupportBloc supportBloc) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          left: 40.0,
          right: 40.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        // bool isSaved = await userBloc.saveDetails(context, false);
        // if (isSaved) {
        //   NavigatorUtil navigatorUtil = NavigatorUtil();
        //   navigatorUtil.navigateToScreen(context, '/home');
        // }
        print('DDDDDDDDD');
        supportBloc.updateData(context);
      },
    );
  }
}

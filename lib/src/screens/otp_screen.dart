import 'package:autobuff/src/blocs/user_bloc.dart';
import 'package:autobuff/src/providers/user_bloc_provider.dart';
import 'package:autobuff/src/utils/constants.dart';
import 'package:autobuff/src/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserBlocProvider(
      child: VerificationDetails(),
    );
  }
}

class VerificationDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = UserBlocProvider.getUserBloc(context);
    _userBloc.startTimer(context, 60);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          title(),
          otpText(_userBloc),
          changeNumberText(context),
          numberField(context, _userBloc),
          resendText(context, _userBloc),
          smsView(context, _userBloc),
        ],
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30.0,
      ),
      child: Text(
        'OTP Verification'.toUpperCase(),
        style: TextStyle(color: Color(Constants.BASE_COLOR), fontSize: 28),
      ),
    );
  }

  Widget otpText(UserBloc userBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        bottom: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Text(
            'Enter the OTP sent to ${userBloc.mobileValue}',
            style:
                TextStyle(color: Colors.grey, fontSize: 18, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget changeNumberText(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          bottom: 70.0,
        ),
        child: Row(
          children: <Widget>[
            Text(
              'Change Number',
              style: TextStyle(
                color: Color(Constants.BASE_COLOR),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        NavigatorUtil navigatorUtil = NavigatorUtil();
        navigatorUtil.pop(context);
      },
    );
  }

  Widget numberField(BuildContext context, UserBloc userBloc) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 30.0,
      ),
      child: PinFieldAutoFill(
        decoration: UnderlineDecoration(
            color: Colors.grey,
            textStyle: TextStyle(
                fontSize: 20,
                color: Colors
                    .black)), // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
        //currentCode: // prefill with a code
        //onCodeSubmitted: //code submitted callback
        onCodeChanged: userBloc.updateOTP,
        codeLength: 4, //code length, default 6
      ),
    );
  }

  Widget resendText(BuildContext context, UserBloc userBloc) {
    userBloc.startTimer(context, 60);
    return StreamBuilder(
        stream: userBloc.timer,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          Color color = Colors.grey;
          if (snapshot.hasData && snapshot.data != null && snapshot.data == 0) {
            color = Colors.blue;
          }
          return Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              bottom: 20.0,
            ),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Didn't receive the OTP?",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 14, letterSpacing: 0.5),
                  ),
                  GestureDetector(
                    child: Text(
                      " RESEND OTP",
                      style: TextStyle(
                          color: color, fontSize: 14, letterSpacing: 0.5),
                    ),
                    onTap: () async {
                      if (!userBloc.isTimerRunningValue) {
                        await userBloc.resendOTP(context);
                      }
                    },
                  ),
                  Text(
                    " (0:${snapshot.data})",
                    style: TextStyle(
                        color: Color(Constants.BASE_COLOR),
                        fontSize: 14,
                        letterSpacing: 0.5),
                  ),
                ],
              ),
              onTap: () async {
                //await userBloc.resendOTP(context);
                // if (isrequested) {
                //   NavigatorUtil navigatorUtil = NavigatorUtil();
                //   navigatorUtil.navigateToScreen(context, '/registration');
                // }
              },
            ),
          );
        });
  }

  Widget smsView(BuildContext context, UserBloc userBloc) {
    return StreamBuilder(
        stream: userBloc.isOTPDone,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          Color color = Colors.grey[300];
          Color textColor = Colors.grey;
          if (snapshot.hasData && snapshot.data != null && snapshot.data) {
            textColor = Colors.white;
            color = Colors.black;
          }
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Verify & Proceed',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14.0,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () async {
              if (snapshot.data) {
                await userBloc.verifyOTP(context);
              }
              // if (isrequested && snapshot.data) {
              //   NavigatorUtil navigatorUtil = NavigatorUtil();
              //   navigatorUtil.navigateToScreen(context, '/registration');
              // }
            },
          );
        });
  }
}

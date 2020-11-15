import 'package:autobuff/src/blocs/booking_bloc.dart';
import 'package:autobuff/src/providers/booking_bloc_provider.dart';
import 'package:autobuff/src/screens/home_screen.dart';
import 'package:flutter/material.dart';

class BookingSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BookingBlocProvider(
      child: BookingSuccessBase(),
    );
  }
}

class BookingSuccessBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BookingBloc _bookingBloc = BookingBlocProvider.getBookingBloc(context);
    _bookingBloc.context = context;
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (Route<dynamic> route) => false,
        );
        return true;
      },
      child: Scaffold(
        body: BookingSuccessDetails(),
      ),
    );
  }
}

class BookingSuccessDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          bottom: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/tickIcon.png',
                    height: 35.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Thank you for booking',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
              ),
              child: Image.asset(
                'assets/doodle.png',
                height: MediaQuery.of(context).size.height / 1.7,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                      'We will send booking confirmation mail to your registered e-mail id',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    highlightColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 40.0,
                    ),
                    child: Text('Back to home'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        )),
                    color: Colors.blue[400],
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

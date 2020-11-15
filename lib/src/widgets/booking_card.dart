import 'package:autobuff/src/blocs/booking_bloc.dart';
import 'package:autobuff/src/models/my_booking_model.dart';
import 'package:autobuff/src/utils/navigator_util.dart';
import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  //final NotificationModel _notification;
  final BookingBloc bookingBloc;
  final MyBookingModel bookingModel;
  final int index;

  BookingCard(
    //this._notification,
    this.bookingBloc,
    this.bookingModel,
    this.index,
  );

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Card(
          elevation: 0.0,
          color: Colors.grey[200],
          margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 1.0),
          child: Container(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 10.0,
              bottom: 15.0,
              right: 10.0,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getChildren(),
              ),
            ),
          ),
        ),
        onTap: () {
          if (bookingBloc.isRepeatBookingValue) {
            choosefromDialog(context, 'title', bookingBloc);
          }
        },
      ),
    );
  }

  List<Widget> _getChildren() {
    List<Widget> children = [
      Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: firstRow(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: secondRow(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: thirdRow(),
      ),
    ];
    return children;
  }

  Widget firstRow() {
    Color textColor = Colors.red;
    if (bookingModel.status == 'completed') {
      textColor = Colors.indigo[600];
    } else if (bookingModel.status == 'confirmed') {
      textColor = Colors.green;
    } else if (bookingModel.status == 'on the way') {
      textColor = Colors.amber;
    }
    return Row(
      children: <Widget>[
        Text(
          '#${bookingModel.bookingId}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: Container()),
        Text(
          bookingModel.status.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  secondRow() {
    return Row(
      children: <Widget>[
        Text(
          bookingModel.service.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: Container()),
        Text(
          'RS.${bookingModel.amount}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  thirdRow() {
    return Row(
      children: <Widget>[
        Text(
          bookingModel.dateTime,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> choosefromDialog(
      BuildContext context, String title, BookingBloc bookingBloc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose booking type'),
          content: IntrinsicHeight(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            highlightColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 20.0,
                            ),
                            child: new Text('Book Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            color: Colors.lightBlueAccent,
                            onPressed: () async {
                              bookingBloc.updateselectedBooking(bookingModel);
                              bookingBloc.repeatService(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                GestureDetector(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            highlightColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 20.0,
                            ),
                            child: new Text('Book Later',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            color: Colors.lightBlueAccent,
                            onPressed: () async {
                              bookingBloc.updateselectedBooking(bookingModel);
                              NavigatorUtil navigatorUtil = NavigatorUtil();
                              navigatorUtil.navigateToScreen(
                                  context, '/date-time');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

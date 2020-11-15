import 'package:autobuff/src/blocs/booking_bloc.dart';
import 'package:autobuff/src/blocs/service_bloc.dart';
import 'package:autobuff/src/models/booking_model.dart';
import 'package:autobuff/src/providers/booking_bloc_provider.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:autobuff/src/utils/navigator_util.dart';
import 'package:flutter/material.dart';

import '../utils/snackbar_util.dart';

class BookingConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BookingBlocProvider(
      child: BookingConfirmationBase(),
    );
  }
}

class BookingConfirmationBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Booking Details'),
      ),
      body: BookingConfirmationDetails(),
    );
  }
}

class BookingConfirmationDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BookingBloc _bookingBloc = BookingBlocProvider.getBookingBloc(context);
    NavigatorUtil _navigatorUtil = NavigatorUtil();
    BookingModel _bookingModel = CommonUtil().bookingModel;
    //_snackbarUtil.buildContextProfile = context;
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            carModel(context, _bookingModel, _navigatorUtil),
            carCategory(context, _bookingModel),
            dateTime(context, _bookingModel),
            serviceMode(context, _bookingModel),
            service(context, _bookingModel, _navigatorUtil),
            subTotal(context, _bookingModel),
            paymentMode(context, _bookingModel),
            location(context, _bookingModel, _navigatorUtil),
            nextButton(context, _bookingBloc),
          ],
        ),
      ],
    );
  }

  Widget carModel(BuildContext context, BookingModel _bookingModel,
      NavigatorUtil navigatorUtil) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 0.0,
              bottom: 0.0,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Row(
              children: <Widget>[
                Text('Car model selected'.toUpperCase()),
                Expanded(
                  child: Container(),
                ),
                FlatButton(
                  onPressed: () {
                    navigatorUtil.navigateUntilHomeScreen(context);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10.0,
            ),
            child: Text(_bookingModel.carModel.model),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              left: 5.0,
              right: 5.0,
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
        ],
      ),
    );
  }

  Widget carCategory(BuildContext context, BookingModel _bookingModel) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 15.0,
              bottom: 15.0,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Text('Car category'.toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10.0,
            ),
            child: Text(_bookingModel.carModel.category),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              left: 5.0,
              right: 5.0,
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
        ],
      ),
    );
  }

  Widget dateTime(BuildContext context, BookingModel _bookingModel) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 15.0,
              bottom: 15.0,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Text('Date/Time'.toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10.0,
            ),
            child: Text(_bookingModel.dateTime),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              left: 5.0,
              right: 5.0,
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
        ],
      ),
    );
  }

  Widget serviceMode(BuildContext context, BookingModel _bookingModel) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 15.0,
              bottom: 15.0,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Text('Service mode'.toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10.0,
            ),
            child: Text('One time'.toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              left: 5.0,
              right: 5.0,
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
        ],
      ),
    );
  }

  Widget service(BuildContext context, BookingModel _bookingModel,
      NavigatorUtil navigatorUtil) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Row(
              children: <Widget>[
                Text('Service selected'.toUpperCase()),
                Expanded(
                  child: Container(),
                ),
                FlatButton(
                  onPressed: () {
                    navigatorUtil.pop(context);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Row(
              children: <Widget>[
                Text(_bookingModel.serviceModel.service),
                Expanded(
                  child: Container(),
                ),
                Text('Rs${_bookingModel.serviceModel.price}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              left: 5.0,
              right: 5.0,
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
        ],
      ),
    );
  }

  Widget subTotal(BuildContext context, BookingModel _bookingModel) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 0.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'Sub-Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  'Rs.${_bookingModel.serviceModel.price}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentMode(BuildContext context, BookingModel _bookingModel) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 15.0,
              bottom: 15.0,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Text('Select payment mode'.toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 0.0,
            ),
            child: Row(
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: 0,
                  onChanged: (val) {},
                  activeColor: Colors.lightBlueAccent,
                ),
                Text('Cash'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget location(BuildContext context, BookingModel _bookingModel,
      NavigatorUtil navigatorUtil) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 1.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'Select service location'.toUpperCase(),
                ),
                Expanded(
                  child: Container(),
                ),
                FlatButton(
                  onPressed: () {
                    navigatorUtil.navigateUntilHomeScreen(context);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 10.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.lightBlueAccent,
                  size: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 3.0,
                    left: 10.0,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Text(
                      _bookingModel.address,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nextButton(BuildContext context, BookingBloc _bookingBloc) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          bottom: 30.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Confirm booking'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        if (ServiceBloc().isNowValue) {
          _bookingBloc.bookNowService(context);
        } else {
          _bookingBloc.bookLaterService(context);
        }
      },
    );
  }
}

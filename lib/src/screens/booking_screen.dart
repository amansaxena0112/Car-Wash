import 'dart:async';

import 'package:autobuff/src/blocs/booking_bloc.dart';
import 'package:autobuff/src/models/my_booking_model.dart';
import 'package:autobuff/src/providers/booking_bloc_provider.dart';
import 'package:autobuff/src/providers/user_bloc_provider.dart';
import 'package:autobuff/src/widgets/booking_card.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BookingBlocProvider(
      child: BookingDetailsBase(),
    );
  }
}

class BookingDetailsBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1.0,
        title: Text(
          'My Bookings',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BookingDetails(),
    );
  }
}

class BookingDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BookingBloc _bookinBloc = BookingBlocProvider.getBookingBloc(context);
    _bookinBloc.currentPage = 1;
    _bookinBloc.getBooking(context);
    return StreamBuilder(
        stream: _bookinBloc.isLoading,
        builder: (BuildContext context, AsyncSnapshot<bool> isLoading) {
          return Column(
            children: <Widget>[
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (isLoading.hasData &&
                        !isLoading.data &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      if (_bookinBloc.next_page_url != null &&
                          _bookinBloc.next_page_url.isNotEmpty) {
                        _bookinBloc.currentPage += 1;
                        _bookinBloc.updateIsLoading(true);
                        _bookinBloc.getBooking(context);
                      }
                    }
                    return true;
                  },
                  child: StreamBuilder(
                      stream: _bookinBloc.myBookingList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<MyBookingModel>> myBookingList) {
                        if (myBookingList.hasData &&
                            myBookingList.data.length > 0) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: myBookingList.hasData &&
                                    myBookingList.data.length > 0
                                ? myBookingList.data.length
                                : 0,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return BookingCard(_bookinBloc,
                                  myBookingList.data[index], index);
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              'No Bookings',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.grey[350]),
                            ),
                          );
                        }
                      }),
                ),
              ),
              Container(
                height: isLoading.hasData && isLoading.data ? 50.0 : 0,
                color: Colors.transparent,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              ),
            ],
          );
        });
  }
}

import 'package:autobuff/src/blocs/booking_bloc.dart';
import 'package:autobuff/src/providers/booking_bloc_provider.dart';
import 'package:autobuff/src/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DateTimeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BookingBlocProvider(
      child: DateTimeScreenDetails(),
    );
  }
}

class DateTimeScreenDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1.0,
        title: Text(
          'Select date time',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: DateTimeScreenBody(),
    );
  }
}

class DateTimeScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BookingBloc _bookingBloc = BookingBlocProvider.getBookingBloc(context);
    NavigatorUtil _navigatorUtil = NavigatorUtil();
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
          bottom: 30.0,
          left: 30.0,
          right: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Date'),
            GestureDetector(
              child: StreamBuilder(
                  stream: _bookingBloc.date,
                  builder: (BuildContext context, AsyncSnapshot<String> date) {
                    Color textColor = Colors.grey;
                    if (date.hasData && date.data.isNotEmpty) {
                      textColor = Colors.black;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: Colors.black87),
                            color: Colors.white),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                              ),
                              child: Text(
                                date.hasData && date.data.isNotEmpty
                                    ? date.data
                                    : 'Click to select date',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(DateTime.now().year,
                        DateTime.now().month + 8, DateTime.now().day),
                    theme: DatePickerTheme(
                        headerColor: Colors.lightBlueAccent,
                        backgroundColor: Colors.white,
                        itemStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        doneStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                    onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  print('confirm $date');
                  String dateSelected =
                      '${date.year}-${date.month.toString().length == 2 ? date.month : '0${date.month}'}-${date.day}';
                  _bookingBloc.updateDate(dateSelected);
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text('Time'),
            ),
            GestureDetector(
              child: StreamBuilder(
                  stream: _bookingBloc.time,
                  builder: (BuildContext context, AsyncSnapshot<String> time) {
                    Color textColor = Colors.grey;
                    if (time.hasData && time.data.isNotEmpty) {
                      textColor = Colors.black;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: Colors.black87),
                            color: Colors.white),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                              ),
                              child: Text(
                                time.hasData && time.data.isNotEmpty
                                    ? time.data
                                    : 'Click to select time',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: textColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              onTap: () {
                DatePicker.showTimePicker(context,
                    showTitleActions: true,
                    locale: LocaleType.en,
                    theme: DatePickerTheme(
                        headerColor: Colors.lightBlueAccent,
                        backgroundColor: Colors.white,
                        itemStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        doneStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                    onChanged: (time) {
                  print('change $time in time zone ' +
                      time.timeZoneOffset.inHours.toString());
                }, onConfirm: (time) {
                  print('confirm $time');
                  String timeSelected =
                      '${time.hour}:${time.minute}:${time.second}';
                  _bookingBloc.updateTime(timeSelected);
                }, currentTime: DateTime.now());
              },
            ),
            Expanded(
              child: Container(),
            ),
            nextButton(context, _bookingBloc),
          ],
        ),
      ),
    );
  }

  Widget nextButton(BuildContext context, BookingBloc bookingBloc) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                bookingBloc.isRepeatBookingValue ? 'Book' : 'NEXT',
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
        if (bookingBloc.isRepeatBookingValue) {
          bookingBloc.repeatService(context);
        } else {
          await bookingBloc.updateBookingModel();
          NavigatorUtil navigatorUtil = NavigatorUtil();
          navigatorUtil.navigateToScreen(context, '/booking-confirmation');
        }
      },
    );
  }
}

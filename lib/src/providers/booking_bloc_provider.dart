import 'package:autobuff/src/blocs/booking_bloc.dart';
import 'package:flutter/material.dart';

import '../blocs/notification_bloc.dart';

class BookingBlocProvider extends InheritedWidget {
  final BookingBloc _bookingBloc = BookingBloc();
  final NotificationBloc notificationBloc = NotificationBloc();

  BookingBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static BookingBloc getBookingBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BookingBlocProvider)
              as BookingBlocProvider)
          ._bookingBloc;

  static NotificationBloc getNotificaionBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BookingBlocProvider)
              as BookingBlocProvider)
          .notificationBloc;
}

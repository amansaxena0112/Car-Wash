import 'package:autobuff/src/blocs/service_bloc.dart';
import 'package:autobuff/src/blocs/support_bloc.dart';
import 'package:flutter/material.dart';

import '../blocs/notification_bloc.dart';

class SupportBlocProvider extends InheritedWidget {
  final SupportBloc _supportBloc = SupportBloc();
  final NotificationBloc notificationBloc = NotificationBloc();

  SupportBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static SupportBloc getSupportBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SupportBlocProvider)
              as SupportBlocProvider)
          ._supportBloc;

  static NotificationBloc getNotificaionBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SupportBlocProvider)
              as SupportBlocProvider)
          .notificationBloc;
}

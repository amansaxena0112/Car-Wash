import 'package:autobuff/src/blocs/service_bloc.dart';
import 'package:flutter/material.dart';

import '../blocs/notification_bloc.dart';

class ServiceBlocProvider extends InheritedWidget {
  final ServiceBloc _serviceBloc = ServiceBloc();
  final NotificationBloc notificationBloc = NotificationBloc();

  ServiceBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static ServiceBloc getServiceBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ServiceBlocProvider)
              as ServiceBlocProvider)
          ._serviceBloc;

  static NotificationBloc getNotificaionBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ServiceBlocProvider)
              as ServiceBlocProvider)
          .notificationBloc;
}

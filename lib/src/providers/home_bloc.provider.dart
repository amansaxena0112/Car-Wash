import 'package:autobuff/src/blocs/home_bloc.dart';
import 'package:flutter/material.dart';

import '../blocs/user_bloc.dart';
import '../blocs/notification_bloc.dart';

class HomeBlocProvider extends InheritedWidget {
  final UserBloc _userBloc = UserBloc();
  final HomeBloc _homeBloc = HomeBloc();
  final NotificationBloc notificationBloc = NotificationBloc();

  HomeBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static UserBloc getUserBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomeBlocProvider)
              as HomeBlocProvider)
          ._userBloc;

  static HomeBloc getHomeBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomeBlocProvider)
              as HomeBlocProvider)
          ._homeBloc;

  static NotificationBloc getNotificaionBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomeBlocProvider)
              as HomeBlocProvider)
          .notificationBloc;
}

import 'package:flutter/material.dart';

import '../blocs/user_bloc.dart';
import '../blocs/notification_bloc.dart';

class UserBlocProvider extends InheritedWidget {
  final UserBloc _userBloc = UserBloc();
  final NotificationBloc notificationBloc = NotificationBloc();

  UserBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static UserBloc getUserBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(UserBlocProvider)
              as UserBlocProvider)
          ._userBloc;

  static NotificationBloc getNotificaionBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(UserBlocProvider)
              as UserBlocProvider)
          .notificationBloc;
}

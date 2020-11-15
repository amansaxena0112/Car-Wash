import 'package:autobuff/src/models/auto_complete_location.dart';
import 'package:flutter/material.dart';

import '../blocs/auto_complete_bloc.dart';

class AutoCompleteBlocProvider extends InheritedWidget {
  final AutoCompleteBloc _autoCompleteBloc;
  final BuildContext context;
  final TextEditingController controller;
  final AutoCompleteLocationResponse response;
  final Function(AutoCompleteLocationResponse) onChanged;
  final Function() onRemove;

  AutoCompleteBlocProvider(
      {Key key,
      Widget child,
      @required this.controller,
      @required this.response,
      @required this.context,
      this.onChanged,
      this.onRemove})
      : _autoCompleteBloc = AutoCompleteBloc(
            context: context,
            controller: controller,
            response: response,
            onChanged: onChanged,
            onRemove: onRemove),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(Widget oldWidget) => false;

  static AutoCompleteBloc getAutoCompleteBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AutoCompleteBlocProvider)
              as AutoCompleteBlocProvider)
          ._autoCompleteBloc;
}

import 'package:autobuff/src/models/auto_complete_location.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:flutter/material.dart';

import '../providers/auto_complete_bloc_provider.dart';
import '../blocs/auto_complete_bloc.dart';

class AutoComplete extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final AutoCompleteLocationResponse response;
  final Function(AutoCompleteLocationResponse) onChanged;
  final Function() onRemove;

  AutoComplete(this.hintText, this.controller, this.response,
      {this.onChanged, this.onRemove})
      : super();

  @override
  Widget build(BuildContext context) {
    return AutoCompleteBlocProvider(
      child: AutoCompleteBase(hintText),
      controller: controller,
      response: response,
      context: context,
      onChanged: onChanged,
      onRemove: onRemove,
    );
  }
}

class AutoCompleteBase extends StatelessWidget {
  final hintText;

  AutoCompleteBase(this.hintText) : super();

  @override
  Widget build(BuildContext context) {
    final AutoCompleteBloc _autoCompleBloc =
        AutoCompleteBlocProvider.getAutoCompleteBloc(context);
    CommonUtil _commonUtil = CommonUtil();
    return IntrinsicWidth(
      child: CompositedTransformTarget(
        link: _autoCompleBloc.layerLink,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: StreamBuilder(
                  stream: _commonUtil.autoCompleteText,
                  builder: (BuildContext context,
                      AsyncSnapshot<String> autoCompleteText) {
                    if (autoCompleteText.hasData &&
                        autoCompleteText.data != null &&
                        autoCompleteText.data.isNotEmpty) {
                      _autoCompleBloc.controller.text = autoCompleteText.data;
                    }
                    return StreamBuilder(
                        stream: _autoCompleBloc.autoComplete,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: hintText,
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 5.0),
                              ),
                              style: TextStyle(
                                height: 1.2,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              onTap: () {
                                _autoCompleBloc.controller.clear();
                              },
                              controller: _autoCompleBloc.controller,
                              onChanged: _autoCompleBloc.valueChanged,
                              onSubmitted: _autoCompleBloc.onSubmitted,
                            ),
                          );
                        });
                  }),
            ),
            // GestureDetector(
            //   child: Padding(
            //     padding: EdgeInsets.only(right: 0.0),
            //     child: Icon(
            //       Icons.cancel,
            //       size: 20.0,
            //     ),
            //   ),
            //   onTap: () {
            //     _autoCompleBloc.clearAutoComple();
            //     _autoCompleBloc.fireEvents();
            //   },
            // )
          ],
        ),
      ),
    );
  }
}

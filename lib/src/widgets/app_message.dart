import 'package:flutter/material.dart';

class AppMessage {
  final message;

  AppMessage(this.message);

  get snackBar => SnackBar(
        duration: Duration(
          seconds: 6,
        ),
        content: Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(23, 23, 23, 1.0),
      );
}

import 'package:flutter/material.dart';

class AppLoader {
  final message;

  AppLoader(this.message);

  Widget get loader => Dialog(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                width: 25.0,
              ),
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      message,
                      style: TextStyle(fontSize: 16.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

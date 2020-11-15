import 'package:flutter/material.dart';

import './app_routes.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return AutoBuff();
  }
}

class AutoBuff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: AppRoutes.routes,
      theme: new ThemeData(
        fontFamily: "MetropolisMedium",
        primaryColor: Colors.blue[900],
        primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white)),
        primaryIconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}

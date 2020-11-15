import 'package:autobuff/src/screens/booking_screen.dart';
import 'package:flutter/material.dart';

import '../src/screens/splash_screen.dart';
import '../src/screens/login_screen.dart';
import '../src/screens/signup_screen.dart';
import '../src/screens/home_screen.dart';
import '../src/screens/forget_password_screen.dart';
import '../src/screens/edit_profile_screen.dart';
import '../src/screens/booking_screen.dart';
import '../src/screens/support_screen.dart';
import '../src/screens/services_screen.dart';
import '../src/screens/booking_confirmation_screen.dart';
import '../src/screens/otp_screen.dart';
import '../src/screens/booking_success_screen.dart';
import '../src/screens/loader_screen.dart';
import '../src/screens/date_time_screen.dart';

class AppRoutes {
  static Route routes(RouteSettings settings) {
    String name = settings.name;

    switch (name) {
      case '/':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return SplashScreen();
          },
        );
        break;
      case '/home':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return HomeScreen();
          },
        );
        break;
      case '/login':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginScreen();
          },
        );
        break;
      case '/signup':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return SignUpScreen();
          },
        );
        break;
      case '/otp':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return OTPScreen();
          },
        );
        break;
      // case '/splash':
      //   return MaterialPageRoute(
      //     builder: (BuildContext context) {
      //       return SplashScreen();
      //     },
      //   );
      //   break;
      case '/forget':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return ForgetPasswordScreen();
          },
        );
        break;
      case '/profile':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return ProfileScreen();
          },
        );
        break;
      case '/booking':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return BookingScreen();
          },
        );
        break;
      case '/support':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return SupportScreen();
          },
        );
        break;
      case '/service':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return ServiceScreen();
          },
        );
        break;
      case '/booking-confirmation':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return BookingConfirmationScreen();
          },
        );
        break;
      case '/success':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return BookingSuccessScreen();
          },
        );
        break;
      case '/date-time':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return DateTimeScreen();
          },
        );
        break;
      default:
        return null;
    }
  }
}

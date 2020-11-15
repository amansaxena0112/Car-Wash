import 'package:autobuff/src/blocs/booking_bloc.dart';
import 'package:autobuff/src/utils/prefs_util.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

import '../utils/navigator_util.dart';
import '../utils/constants.dart';
import '../utils/network_util.dart';
import '../utils/common_util.dart';
import '../models/user_model.dart';

class AppMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CommonUtil _commonUtil = CommonUtil();
    _commonUtil.updateAppDetails();
    List<Widget> versionInfo = <Widget>[];
    if (!NetworkUtil().isProduction) {
      versionInfo.add(Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(
          Constants.hostDev,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ));
    }
    versionInfo.add(
      Text(
        'v${_commonUtil.appVersion}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          header(context, _commonUtil.user),
          menuItems(context),
          Container(
            color: Color.fromRGBO(20, 13, 29, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 5.0, right: 10.0),
                    child: Row(children: versionInfo))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItems(BuildContext context) {
    List<Widget> items = [
      profile(context),
      myBookings(context),
      support(context),
      terms(context),
      privacy(context),
      share(context),
      logOut(context)
    ];
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: items,
        ),
      ),
    );
  }

  Widget profile(BuildContext context) {
    return ListTile(
      onTap: () {
        //showLogoutPopup(context);
        NavigatorUtil navigatorUtil = NavigatorUtil();
        navigatorUtil.navigateToScreen(context, '/profile');
      },
      leading: Icon(
        Icons.person,
        color: Colors.blue[900],
      ),
      title: Text(
        'Profile',
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget myBookings(BuildContext context) {
    return ListTile(
      onTap: () {
        //showLogoutPopup(context);
        BookingBloc().updateisRepeatBooking(false);
        NavigatorUtil navigatorUtil = NavigatorUtil();
        navigatorUtil.navigateToScreen(context, '/booking');
      },
      leading: Icon(
        Icons.event,
        color: Colors.blue[900],
      ),
      title: Text(
        'My Bookings',
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget support(BuildContext context) {
    return ListTile(
      onTap: () {
        //showLogoutPopup(context);
        NavigatorUtil navigatorUtil = NavigatorUtil();
        navigatorUtil.navigateToScreen(context, '/support');
      },
      leading: Icon(
        Icons.call,
        color: Colors.blue[900],
      ),
      title: Text(
        'Support',
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget terms(BuildContext context) {
    return ListTile(
      onTap: () {
        //showLogoutPopup(context);
      },
      leading: Icon(
        Icons.assignment,
        color: Colors.blue[900],
      ),
      title: Text(
        'Terms & Conditions',
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget privacy(BuildContext context) {
    return ListTile(
      onTap: () {
        //showLogoutPopup(context);
      },
      leading: Icon(
        Icons.security,
        color: Colors.blue[900],
      ),
      title: Text(
        'Privacy Policy',
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget share(BuildContext context) {
    return ListTile(
      onTap: () {
        //showLogoutPopup(context);
        StoreRedirect.redirect(androidAppId: "com.example.autobuff");
      },
      leading: Icon(
        Icons.share,
        color: Colors.blue[900],
      ),
      title: Text(
        'Share',
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget logOut(BuildContext context) {
    return ListTile(
      onTap: () {
        showLogoutPopup(context);
      },
      leading: Icon(
        Icons.exit_to_app,
        color: Colors.blue[900],
      ),
      title: Text(
        'Logout',
        style: TextStyle(
          color: Colors.blue[900],
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget header(BuildContext context, UserModel user) {
    ImageProvider imageChild = AssetImage(
      'assets/avatar.png',
    );
    if (user.profile != null && user.profile.isNotEmpty) {
      imageChild = NetworkImage(user.profile);
    }
    print(user.name);
    return Container(
      color: Color.fromRGBO(62, 60, 64, 1.0),
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Color.fromRGBO(62, 60, 64, 1.0),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage: imageChild,
        ),
        accountName: Text(
          user != null && user.name != null ? user.name : '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        accountEmail: Text(
          user != null && user.email != null ? user.email : '',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }

  void showLogoutPopup(BuildContext context) {
    NavigatorUtil _navigatorUtil = NavigatorUtil();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        //InitBloc _initBloc = InitBlocProvider.getInitBloc(context);
        return AlertDialog(
          title: Text('Confirm Sign Out'),
          content: Text('Do you really want to sign out?'),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => _navigatorUtil.pop(context),
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              color: Colors.redAccent,
            ),
            RaisedButton(
              onPressed: () async {
                PrefsUtil _prefsUtil = PrefsUtil();
                _prefsUtil.prefs.setString(Constants.ACCESS_TOKEN, null);
                _navigatorUtil.navigateToSignInScreen(context);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlue[300],
            ),
          ],
        );
      },
    );
  }
}

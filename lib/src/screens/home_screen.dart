import 'dart:async';
import 'dart:math';

import 'package:autobuff/src/blocs/auto_complete_bloc.dart';
import 'package:autobuff/src/blocs/booking_bloc.dart';
import 'package:autobuff/src/blocs/home_bloc.dart';
import 'package:autobuff/src/blocs/service_bloc.dart';
import 'package:autobuff/src/blocs/user_bloc.dart';
import 'package:autobuff/src/providers/auto_complete_bloc_provider.dart';
import 'package:autobuff/src/providers/home_bloc.provider.dart';
import 'package:autobuff/src/utils/common_util.dart';
import 'package:autobuff/src/utils/snackbar_util.dart';
import 'package:autobuff/src/widgets/auto_complete.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_places_autocomplete/flutter_places_autocomplete.dart';

import '../utils/navigator_util.dart';
import '../widgets/app_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeBlocProvider(
      child: HomeScreenDetails(),
    );
  }
}

class HomeScreenDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = HomeBlocProvider.getUserBloc(context);
    _userBloc.addPreferredLocation();
    HomeBloc _homeBloc = HomeBlocProvider.getHomeBloc(context);
    NavigatorUtil navigatorUtil = NavigatorUtil();
    CommonUtil _commonUtil = CommonUtil();
    SnackbarUtil _snackbarUtil = SnackbarUtil();
    _snackbarUtil.buildContextHome = context;
    _commonUtil.updateUser = _userBloc.userModelValue;
    _commonUtil.initCurrentLocation();
    // print(_commonUtil.user.name);
    // print(_userBloc.userModelValue.name);
    return Scaffold(
      drawer: AppMenu(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1.0,
        title: Text('Hi!${_userBloc.userNameValue}'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0, right: 10.0),
        child: FloatingActionButton(
          onPressed: _homeBloc.movetoCurrentLocation,
          child: Icon(Icons.my_location),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: _commonUtil.latitude,
              builder: (BuildContext context, AsyncSnapshot<double> latitude) {
                // if (latitude.hasData && _homeBloc.controller != null) {
                //   _homeBloc.moveMarker();
                // }
                if (latitude.hasData && latitude.data != null) {
                  final CameraPosition _kGooglePlex = CameraPosition(
                    target: LatLng(latitude.data, _commonUtil.longitudeValue),
                    zoom: 14,
                  );
                  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
                  var markerIdVal = "1";
                  final MarkerId markerId = MarkerId(markerIdVal);

                  // creating a new MARKER
                  final Marker marker = Marker(
                    markerId: markerId,
                    position: LatLng(
                      latitude.data,
                      _commonUtil.longitudeValue,
                    ),
                    draggable: true,
                  );
                  markers[markerId] = marker;
                  return GoogleMap(
                    zoomControlsEnabled: false,
                    mapType: MapType.terrain,
                    initialCameraPosition: _kGooglePlex,
                    compassEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                    onMapCreated: (GoogleMapController controller) {
                      _homeBloc.controller = controller;
                    },
                    onCameraMove: (position) {
                      _commonUtil.updateLongitude(position.target.longitude);
                      _commonUtil.updateLatitude(position.target.latitude);
                      // _homeBloc.searchAddress(
                      //     position.target.latitude, position.target.longitude);
                    },
                    onCameraIdle: () {
                      _homeBloc.searchAddress(_commonUtil.latitudeValue,
                          _commonUtil.longitudeValue);
                    },
                  );
                } else {
                  return Container();
                }
              }),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 3.0,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          //child: Container(),
                          child: AutoComplete(
                            'Enter your location',
                            _userBloc.preferredLocationControllers[0],
                            _userBloc.autoCompleteResults[0],
                            onChanged: (res) {
                              _userBloc.updatePreferredLocationResult(0, res);
                            },
                            onRemove: () =>
                                _userBloc.deletePreferredLocation(0),
                          ),
                        ),
                        Container(
                          width: 70.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 3.0,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SimpleAutoCompleteTextField(
                            key: GlobalKey(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              hintText: 'Search your car',
                              border: InputBorder.none,
                            ),
                            controller: _homeBloc.carController,
                            suggestions: _homeBloc.suggestions,
                            textChanged: (text) {
                              print('111111');
                            },
                            clearOnSubmit: false,
                            textSubmitted: (text) {
                              _homeBloc.updateSelectedCarModel(text);
                              print(text);
                            },
                          ),
                        ),
                        Container(
                          width: 70.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 30.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      highlightColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                      child: new Text('Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )),
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        bool isValid = await _homeBloc.updateBookingModel();
                        if (isValid) {
                          ServiceBloc().updateIsNow(true);
                          navigatorUtil.navigateToScreen(context, '/service');
                        }
                      },
                    ),
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      highlightColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                      child: new Text('Book Later',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )),
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        bool isValid = await _homeBloc.updateBookingModel();
                        if (isValid) {
                          ServiceBloc().updateIsNow(false);
                          navigatorUtil.navigateToScreen(context, '/service');
                        }
                      },
                    ),
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                          // side: BorderSide(
                          //   width: 1.0,
                          //   color: Colors.black,
                          // ),
                          borderRadius: new BorderRadius.circular(30.0)),
                      highlightColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                      child: new Text('Repeat Service',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )),
                      color: Colors.lightBlueAccent,
                      onPressed: () {
                        // NavigatorUtil navigatorUtil = NavigatorUtil();
                        BookingBloc().updateisRepeatBooking(true);
                        navigatorUtil.navigateToScreen(context, '/booking');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}

class HomeBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('data');
  }
}

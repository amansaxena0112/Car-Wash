import 'dart:async';
import 'package:autobuff/src/blocs/home_bloc.dart';
import 'package:autobuff/src/models/auto_complete_location.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_maps_webservice/places.dart';

import '../utils/common_util.dart';
import '../utils/constants.dart';

class AutoCompleteBloc {
  AutoCompleteBloc(
      {@required this.context,
      @required this.controller,
      @required this.response,
      this.onChanged,
      this.onRemove}) {
    _autoComplete.listen((keyword) {
      if (keyword != null && keyword.trim().isNotEmpty) {
        doSearch(keyword);
      } else {
        updateSuggestions([]);
        updateNoResult([]);
      }
    });

    controller.addListener(() {
      if (controller.text == null || controller.text.trim().isEmpty) {
        clearAutoComple();
      }
    });

    _noResult.listen((noResult) {
      if (noResult != null &&
          noResult.length > 0 &&
          controller.text != null &&
          controller.text.trim().isNotEmpty) {
        if (_emptyOverlayEntry == null) {
          _emptyOverlayEntry = _createNoResultOverlay();
          Overlay.of(context).insert(_emptyOverlayEntry);
        }
      } else {
        if (_emptyOverlayEntry != null) {
          _emptyOverlayEntry.remove();
          _emptyOverlayEntry = null;
        }
      }
    });
    _suggestions.listen((suggestions) {
      if (suggestions != null &&
          suggestions.length > 0 &&
          controller.text != null &&
          controller.text.trim().isNotEmpty) {
        if (_overlayEntry == null) {
          _overlayEntry = _createOverlayEntry();
          Overlay.of(context).insert(_overlayEntry);
        }
      } else {
        if (_overlayEntry != null) {
          _overlayEntry.remove();
          _overlayEntry = null;
        }
      }
    });
  }

  CommonUtil commonUtil = CommonUtil();
  TextEditingController controller;
  OverlayEntry _overlayEntry;
  OverlayEntry _emptyOverlayEntry;
  BuildContext context;
  Function(AutoCompleteLocationResponse) onChanged;
  Function() onRemove;
  LayerLink layerLink = LayerLink();
  List<String> placeIds = [];
  AutoCompleteLocationResponse response;
  bool isFocused;

  final GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: bool.fromEnvironment('dart.vm.product')
          ? Constants.GOOGLE_KEY_PROD
          : Constants.GOOGLE_KEY_DEV);
  final BehaviorSubject<String> _autoComplete =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<List<String>> _suggestions =
      BehaviorSubject<List<String>>.seeded([]);
  final BehaviorSubject<List<String>> _noResult =
      BehaviorSubject<List<String>>.seeded([]);
  final BehaviorSubject<String> _currentValue = BehaviorSubject<String>();

  Stream<String> get autoComplete => _autoComplete.stream;
  String get autoCompleteLastValue => _autoComplete.value;
  Function(String) get updateAutoComplete => _autoComplete.sink.add;
  Stream<List<String>> get suggestions => _suggestions.stream;
  List<String> get suggestionsLastValue => _suggestions.value;
  Function(List<String>) get updateSuggestions => _suggestions.sink.add;
  Stream<String> get currentValue => _currentValue.stream;
  Function(String) get updateCurrentValue => _currentValue.sink.add;
  Stream<List<String>> get noResult => _noResult.stream;
  Function(List<String>) get updateNoResult => _noResult.sink.add;

  void dispose() {
    _suggestions.close();
    _currentValue.close();
    _noResult.close();
  }

  void doSearch(String keyword) async {
    placeIds = [];
    PlacesAutocompleteResponse resp = await _places.autocomplete(
      keyword,
      radius: 20,
      location: Location(
        commonUtil.currentLocation.latitude,
        commonUtil.currentLocation.longitude,
      ),
    );
    if (resp.isOkay) {
      List<String> suggestions = [];
      resp.predictions.forEach((prediction) {
        suggestions.add(prediction.description);
        placeIds.add(prediction.placeId);
      });
      updateSuggestions(suggestions);
      updateNoResult([]);
    } else {
      updateSuggestions([]);
      updateNoResult(['No result']);
    }
  }

  void valueChanged(String text) {
    updateAutoComplete(text);
  }

  void selectLocation(int index) async {
    String placeId = placeIds[index];
    PlacesDetailsResponse res = await _places.getDetailsByPlaceId(placeId);
    String currentValue;
    if (res.isOkay) {
      currentValue = res.result.formattedAddress;
    } else {
      currentValue = _suggestions.value[index];
    }
    response = AutoCompleteLocationResponse(res.result.formattedAddress,
        res.result.geometry.location.lat, res.result.geometry.location.lng);
    updateCurrentValue(currentValue);
    commonUtil.updateLatitude(res.result.geometry.location.lat);
    commonUtil.updateLongitude(res.result.geometry.location.lng);
    commonUtil.updateAutoCompleteText(currentValue);
    HomeBloc().moveMarker();
    controller.text = currentValue;
    updateSuggestions([]);
    placeIds = [];
    restorePreviousIfPresent();
  }

  OverlayEntry _createNoResultOverlay() {
    RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;
    return OverlayEntry(
      builder: (BuildContext _context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(1, 255, 246, 246),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: .5,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 5.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          _noResult.value[0],
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: restorePreviousIfPresent,
              ),
            ),
          ),
        );
      },
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;
    return OverlayEntry(
      builder: (BuildContext _context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              child: StreamBuilder(
                stream: suggestions,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(1, 255, 246, 246),
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: .5,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 5.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.place),
                                SizedBox(
                                  width: 7.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    snapshot.data[index],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () => selectLocation(index),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  clearAutoComple() {
    response = AutoCompleteLocationResponse(null, null, null);
    controller.clear();
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
    if (_emptyOverlayEntry != null) {
      _emptyOverlayEntry.remove();
      _emptyOverlayEntry = null;
    }
  }

  void fireEvents() {
    if (onRemove != null) {
      onRemove();
    } else if (onChanged != null) {
      onChanged(response);
    }
  }

  restorePreviousIfPresent() {
    if (_emptyOverlayEntry != null) {
      _emptyOverlayEntry.remove();
      _emptyOverlayEntry = null;
    }
    if (response.address != null) {
      controller.text = response.address;
    }
    if (onChanged != null) {
      onChanged(response);
    }
  }

  void onSubmitted(String val) {
    if (response == null ||
        response.address == null ||
        response.address.trim().isEmpty) {
      controller.clear();
    }
  }
}

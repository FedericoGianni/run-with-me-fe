import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:runwithme/providers/event.dart';

import 'dart:convert';
import '../widgets/custom_alert_dialog.dart';

class LocationHelper with ChangeNotifier {
  var context;
  bool searchingForLocation = false;
  bool keepBackgroundThreadAlive = false;
  late Map<String, Object> _place;
  String kPLACES_API_KEY = "***REMOVED***";

  Position _lastKnownPosition = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );
  Position? _defaultUserPosition;
  Position? _currentUserPosition;
  LocationHelper();

  void setDefaultUserPosition(Position userPosition) {
    print("Setting default user location");

    _defaultUserPosition = userPosition;
    if (_lastKnownPosition.latitude == 0.0 &&
        _lastKnownPosition.longitude == 0.0) {
      print("Setting last known user location to default user location");
      _lastKnownPosition = userPosition;
    }
  }

  bool isInitialized() {
    if (_currentUserPosition == null) {
      return false;
    }

    if (_currentUserPosition!.latitude == 0.0 &&
        _currentUserPosition!.longitude == 0.0) {
      return false;
    }

    return true;
  }

  Position? _getDefaultUserLocation() {
    print("Using default user location");
    _lastKnownPosition = _defaultUserPosition!;
    return _defaultUserPosition;
  }

  @visibleForTesting
  Position? getDefaultUserLocation() {
    return _getDefaultUserLocation();
  }

  @visibleForTesting
  Future<void> showMyDialog(title, message, onAccept, onDismiss) {
    return _showMyDialog(
        title: title,
        message: message,
        onAccept: onAccept,
        onDismiss: onDismiss);
  }

  Future<void> _showMyDialog({
    context,
    required String title,
    required String message,
    required Function onAccept,
    required Function onDismiss,
  }) async {
    // var settings = Provider.of<UserSettings>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          message: message,
          onAccept: () => onAccept(),
          onDismiss: () => onDismiss(),
        );
      },
    );
  }

  Future<void> start() async {
    print("Starting background location thread");
    keepBackgroundThreadAlive = true;
    while (keepBackgroundThreadAlive) {
      print("Searching for user location in the background");
      await Future.delayed(Duration(seconds: 30));
      determinePosition(LocationAccuracy.best, context);
    }
    print("Closing background location thread");
  }

  Future<Position?> determinePosition(
      LocationAccuracy accuracy, var context) async {
    bool serviceEnabled;
    LocationPermission permission;
    // Here I check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // If not, the corresponding alert dialog is triggered
    if (!serviceEnabled) {
      // But only the first time
      await _showMyDialog(
          context: context,
          title: "No GPS data",
          message:
              "Location services are disabled but are needed for the app to work at its best.\nDo you want to turn them on now?",
          onAccept: () {
            Geolocator.openLocationSettings();
            // all again this function that will attewmpt 10 check before closing itself too
            determinePosition(LocationAccuracy.best, context);
            // For the time being lets use the default user position, hoping for the best in the future
            return _getDefaultUserLocation();
          },
          onDismiss: () {
            // Disable background gps
            keepBackgroundThreadAlive = false;
            // If user selected no, default user position is going to be used instead
            return _getDefaultUserLocation();
          });
      print('Location services are disabled.');
      return _getDefaultUserLocation();
    }
    // If after 10 tries the user still hasnt turned on the location, the default location is used instead

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // If location permissions are denied the used is asked to allow them
      await _showMyDialog(
          context: context,
          title: "No GPS permission",
          message:
              "Location services are used to search for events near you.\n\nDo you want to allow them now?",

          // If he says yes, he is promted again with the default android permission manager
          onAccept: () async {
            permission = await Geolocator.requestPermission();
          },
          onDismiss: () {
            keepBackgroundThreadAlive = false;

            // If user selected no, default user position is going to be used instead
            return _getDefaultUserLocation();
          });
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return _getDefaultUserLocation();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      keepBackgroundThreadAlive = false;
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return _getDefaultUserLocation();
    }
    print("Getting Location");
    _currentUserPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 20));

    _lastKnownPosition = _currentUserPosition!;
    print("Location acquired");
    notifyListeners();
    return _currentUserPosition;
  }

  double getDistanceBetween(
      {startLatitude, startLongitude, endLatitude, endLongitude}) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  Position getLastKnownPosition() {
    return _lastKnownPosition;
  }

  Position getLastKnownPositionAndUpdate() {
    determinePosition(LocationAccuracy.best, context).then((value) {
      _currentUserPosition = value;
      _lastKnownPosition = value!;
    });
    return _lastKnownPosition;
  }

  Future<Map<String, Object>> getPlaceDetails({
    required String placeId,
    required String sessionToken,
  }) async {
    String detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kPLACES_API_KEY&sessiontoken=$sessionToken';

    final request = Uri.parse(detailsUrl);
    var response = await http.get(request);
    if (response.statusCode == 200) {
      if (true) {
        var result = json.decode(response.body);
        _place = {
          'name': result['result']['formatted_address'],
          'latitude': result['result']['geometry']['location']['lat'],
          'longitude': result['result']['geometry']['location']['lng'],
          'place_id': result['result']['place_id']
        };
        print(_place);
        return _place;
      }
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<List> getSuggestion({
    required String input,
    required String sessionToken,
  }) async {
    String type = '(regions)';

    String placesUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$kPLACES_API_KEY&sessiontoken=$sessionToken';

    final request = Uri.parse(placesUrl);
    var response = await http.get(request);
    if (response.statusCode == 200) {
      List _placeList = json.decode(response.body)['predictions'];
      return _placeList;
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}

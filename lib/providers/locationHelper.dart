import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationHelper with ChangeNotifier {
  late Position _lastKnownPosition;

  Future<Position> determinePosition(LocationAccuracy accuracy) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print("Getting Location");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    _lastKnownPosition = position;
    print("Location acquired");
    notifyListeners();
    return position;
  }

  double getDistanceBetween(
      {startLatitude, startLongitude, endLatitude, endLongitude}) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  Position getLastKnownPosition() {
    return _lastKnownPosition;
  }
}

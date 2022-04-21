import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runwithme/providers/location_helper.dart';

void main() {
  LocationHelper locationHelper = LocationHelper();
  Position fakePosition = Position(
    longitude: 0.0,
    latitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );

  group('[LOCATION HELPER]', () {
    test('user position is set correctly', () {
      locationHelper.setDefaultUserPosition(fakePosition);
      expect(locationHelper.getLastKnownPosition(), fakePosition);
    });

    test('user position isInitialized should be false', () {
      expect(locationHelper.isInitialized(), false);
    });
  });
}

import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:runwithme/providers/locationHelper.dart';

class MockLocationProvider extends Mock implements LocationHelper {
  @override
  Position? getDefaultUserLocation() {
    return Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  @override
  Future<Position?> determinePosition(
      LocationAccuracy accuracy, context) async {
    return Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  @override
  Future<void> start() async {
    return;
  }

  @override
  Position getLastKnownPosition() {
    return Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  @override
  Future<void> showMyDialog(title, message, onAccept, onDismiss) async {
    return;
  }

  @override
  bool isInitialized() {
    return true;
  }

  @override
  double getDistanceBetween(
      {startLatitude, startLongitude, endLatitude, endLongitude}) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}

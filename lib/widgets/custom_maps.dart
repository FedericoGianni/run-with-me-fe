import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../dummy_data/dummy_events.dart';
import 'custom_info_window.dart';
import 'default_appbar.dart';
import '../models/map_style.dart';
import '../classes/markers.dart';

class CustomMaps extends StatelessWidget {
  late GoogleMapController mapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final LatLng _center = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _customInfoWindowController.googleMapController = controller;
    // mapController.setMapStyle(_mapThemes[5]['style']);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onTap: (_center) => {_customInfoWindowController.hideInfoWindow!()},
          onMapCreated: _onMapCreated,
          onCameraMove: (position) {
            _customInfoWindowController.onCameraMove!();
          },
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: true,
          markers: Set<Marker>.of(
              markerGenerator(dummy, _customInfoWindowController).values),
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 5.0,
          ),
        ),
        CustomInfoWindow(
          controller: _customInfoWindowController,
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.7,
          offset: 60.0,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/themes/custom_colors.dart';

import '../providers/settings_manager.dart';
import 'custom_info_window.dart';
import 'default_appbar.dart';
import '../models/map_style.dart';
import '../classes/markers.dart';
import '../methods/custom_alert_dialog.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class CustomMapsEvent extends StatelessWidget {
  late GoogleMapController mapController;
  late Set<Marker> markers;
  late UserSettings settings;

  Event event;

  CustomMapsEvent({required this.event});

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  final LatLng _center = const LatLng(0, 0);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    customInfoWindowController.googleMapController = controller;
    mapController.setMapStyle(settings.settings.mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<UserSettings>(context, listen: false);

    return GoogleMap(
      onTap: (_center) => {},
      onMapCreated: _onMapCreated,
      onCameraMove: (position) {
        customInfoWindowController.onCameraMove!();
      },
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: true,
      markers: Set<Marker>.of(
          markerGenerator([event], customInfoWindowController, context).values),
      initialCameraPosition: CameraPosition(
        target: LatLng(event.startingPintLat, event.startingPintLong),
        zoom: 13.0,
      ),
    );
  }
}

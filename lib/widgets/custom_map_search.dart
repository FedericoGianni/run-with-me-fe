///{@category Widgets}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/events.dart';
import '../providers/location_helper.dart';
import 'custom_info_window.dart';
import 'default_appbar.dart';
import '../models/map_style.dart';
import '../classes/markers.dart';

class CustomMapsSearch extends StatelessWidget {
  late GoogleMapController mapController;
  late Set<Marker> markers;

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  //TODO change _center with the user city

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    customInfoWindowController.googleMapController = controller;
    // mapController.setMapStyle(_mapThemes[5]['style']);
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<Events>(context);
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);
    final Position userPosition = locationHelper.getLastKnownPosition();
    final LatLng _center =
        LatLng(userPosition.latitude, userPosition.longitude);

    return Stack(
      children: [
        GoogleMap(
          onTap: (_center) => {customInfoWindowController.hideInfoWindow!()},
          onMapCreated: _onMapCreated,
          onCameraMove: (position) {
            customInfoWindowController.onCameraMove!();
          },
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: true,
          markers: Set<Marker>.of(markerGenerator(
                  events.suggestedEvents, customInfoWindowController, context)
              .values),
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 12.0,
          ),
        ),
        CustomInfoWindow(
          controller: customInfoWindowController,
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.7,
          offset: 60.0,
        ),
      ],
    );
  }
}

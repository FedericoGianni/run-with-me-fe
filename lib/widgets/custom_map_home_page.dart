///{@category Widgets}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/page_index.dart';

import '../providers/location_helper.dart';
import 'custom_info_window.dart';
import '../classes/markers.dart';
import 'package:provider/provider.dart';

class CustomMapsHome extends StatefulWidget {
  @override
  State<CustomMapsHome> createState() => _CustomMapsHomeState();
}

class _CustomMapsHomeState extends State<CustomMapsHome> {
  GoogleMapController? mapController;
  late Set<Marker> markers;

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  final LatLng _center = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    customInfoWindowController.googleMapController = controller;
    // mapController.setMapStyle(_mapThemes[5]['style']);
  }

  @override
  void didChangeDependencies() {
    setState(() {
      mapController?.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              Provider.of<LocationHelper>(context, listen: false)
                  .getLastKnownPosition()
                  .latitude,
              Provider.of<LocationHelper>(context, listen: false)
                  .getLastKnownPosition()
                  .longitude),
          zoom: 13.0,
        ),
      ));
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Position userPosition =
        Provider.of<LocationHelper>(context).getLastKnownPosition();

    final pageIndex = Provider.of<PageIndex>(context, listen: false);

    // create a fakeEvent to have a marker displaying current user position
    Event fakeEvent = Event(
        id: -1,
        createdAt: DateTime.now(),
        name: "Your Position",
        date: DateTime.now(),
        startingPintLat: userPosition.latitude,
        startingPintLong: userPosition.longitude,
        difficultyLevel: 5.0,
        averagePaceMin: 0,
        averagePaceSec: 0,
        averageDuration: 0,
        averageLength: 0,
        adminId: -1,
        currentParticipants: 0,
        maxParticipants: 0);

    return GoogleMap(
      // TODO
      // switch to serach page and set view to map_view
      onTap: (_center) => {pageIndex.setPage(Screens.SEARCH.index)},
      onMapCreated: _onMapCreated,
      onCameraMove: (position) {
        customInfoWindowController.onCameraMove!();
      },
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: true,
      markers: Set<Marker>.of(
          markerGenerator([fakeEvent], customInfoWindowController, context)
              .values),
      initialCameraPosition: CameraPosition(
        target: LatLng(userPosition.latitude, userPosition.longitude),
        zoom: 13.0,
      ),
    );
  }
}

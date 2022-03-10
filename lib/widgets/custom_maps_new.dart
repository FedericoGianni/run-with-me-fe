import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runwithme/themes/custom_colors.dart';

import '../dummy_data/dummy_events.dart';
import 'custom_info_window.dart';
import 'default_appbar.dart';
import '../models/map_style.dart';
import '../classes/markers.dart';
import '../methods/custom_alert_dialog.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class CustomMapsNew extends StatefulWidget {
  LatLng markerPosition;
  LatLng centerPosition;

  CustomMapsNew(
      {Key? key, required this.markerPosition, required this.centerPosition})
      : super(key: key);

  @override
  State<CustomMapsNew> createState() => _CustomMapsNewState();
}

class _CustomMapsNewState extends State<CustomMapsNew> {
  late GoogleMapController mapController;
  late Set<Marker> markers = {};

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    customInfoWindowController.googleMapController = controller;
  }

  void _handleTap(LatLng point) {
    setState(() {
      widget.markerPosition = const LatLng(0, 0);
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'Starting Position',
            snippet: 'Press to delete',
            onTap: () {
              setState(() {
                widget.markerPosition = const LatLng(0, 0);
                markers.clear();
              });
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
        ),
      );
    });
  }

// Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  @override
  Widget build(BuildContext context) {
    if (widget.markerPosition != const LatLng(0, 0)) {
      _handleTap(widget.markerPosition);
    }
    final colors = Provider.of<CustomColorScheme>(context);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onTap: (_center) => {customInfoWindowController.hideInfoWindow!()},
            onMapCreated: _onMapCreated,
            onLongPress: _handleTap,
            onCameraMove: (position) {
              customInfoWindowController.onCameraMove!();
            },
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: widget.centerPosition,
              zoom: 14.0,
            ),
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.7,
            offset: 60.0,
          ),
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: colors.secondaryTextColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                    color: colors.onPrimary,
                    border: Border.all(color: colors.onPrimary),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 20,
                          color: colors.secondaryTextColor,
                        ),
                        Expanded(
                          child: Text(
                            'Search',
                            style: TextStyle(color: colors.secondaryTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 30,
                    color: colors.primaryColor,
                  ),
                  onPressed: () {
                    if (markers.length == 1) {
                      Navigator.pop(context, markers.first.position);
                    } else {
                      customAlertDialog(
                          context,
                          Text(
                            'Attention!',
                            style: TextStyle(color: colors.errorColor),
                          ),
                          [
                            Text(
                              'You must select a starting point before confirming.',
                              style: TextStyle(color: colors.primaryTextColor),
                            ),
                            Text(
                              '\nTo do so, long press on the map.',
                              style:
                                  TextStyle(color: colors.secondaryTextColor),
                            ),
                          ]);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

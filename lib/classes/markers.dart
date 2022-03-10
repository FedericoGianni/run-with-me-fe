import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_info_window.dart';
import '../providers/event.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/event_card_text_only.dart';

Map<String, Marker> markerGenerator(List<Event> eventList,
    CustomInfoWindowController _customInfoWindowController, ctx) {
  Map<String, Marker> _markers = {};
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarkerWithHue(197);
  final colors = Provider.of<CustomColorScheme>(ctx);

  for (var i = 0; i < eventList.length; i++) {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            'assets/icons/icon.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    Event event = eventList[i];
    String markerId = event.id.toString();
    Marker marker = Marker(
      markerId: MarkerId(markerId),
      icon: pinLocationIcon,
      position: LatLng(event.startingPintLat, event.startingPintLong),
      infoWindow: InfoWindow.noText,
      onTap: () {
        _customInfoWindowController.addInfoWindow!(
          Stack(
            children: [
              Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: colors.onPrimary,
                  ),
                  child: EventItem(event, i, eventList.length)),
              Positioned(
                top: 5.0,
                left: 5.0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: colors.secondaryTextColor,
                  ),
                  onPressed: () {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                ),
              ),
            ],
          ),
          LatLng(eventList[i].startingPintLat, eventList[i].startingPintLong),
        );
      },
    );

    _markers[markerId] = marker;
  }
  return _markers;
}

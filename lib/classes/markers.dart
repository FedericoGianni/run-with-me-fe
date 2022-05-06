import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_info_window.dart';
import '../providers/event.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/event_card_text_only.dart';

Map<String, Marker> markerGenerator(
    List<Event> resultEventList,
    List<Event> suggestedEventList,
    CustomInfoWindowController _customInfoWindowController,
    ctx) {
  Map<String, Marker> _markers = {};
  BitmapDescriptor pinLocationIcon = BitmapDescriptor.defaultMarkerWithHue(84);
  final colors = Provider.of<CustomColorScheme>(ctx, listen: false);

  for (var i = 0; i < suggestedEventList.length; i++) {
    Event event = suggestedEventList[i];
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: colors.onPrimary,
                  ),
                  child: EventItem(
                    event,
                    i,
                    suggestedEventList.length,
                    1,
                    border: 0.0,
                  )),
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
          LatLng(suggestedEventList[i].startingPintLat,
              suggestedEventList[i].startingPintLong),
        );
      },
    );

    _markers[markerId] = marker;
  }
  // THIS IS VERY BAD, YOU SHOULD NEVER DO IT BUT I HAVE NO TIME TO DO ANYTHING BETTER SO IT WILL DO FOR NOW.
  pinLocationIcon = BitmapDescriptor.defaultMarkerWithHue(196);

  for (var i = 0; i < resultEventList.length; i++) {
    Event event = resultEventList[i];
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: colors.onPrimary,
                  ),
                  child: EventItem(
                    event,
                    i,
                    resultEventList.length,
                    1,
                    border: 0.0,
                  )),
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
          LatLng(resultEventList[i].startingPintLat,
              resultEventList[i].startingPintLong),
        );
      },
    );

    _markers[markerId] = marker;
  }
  return _markers;
}

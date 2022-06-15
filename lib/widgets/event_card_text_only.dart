import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:runwithme/providers/locationHelper.dart';
// import 'package:intl/intl.dart';
import '../classes/multi_device_support.dart';
import '../providers/events.dart';
import '../themes/custom_colors.dart';
import '../providers/event.dart';
import 'rating.dart';
import '../screens/event_details_screen.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class EventItem extends StatelessWidget {
  final Event event;
  final int index;
  final int view;
  final int totAmount;
  double border;

  EventItem(this.event, this.index, this.totAmount, this.view,
      {this.border = 4.0});

  String _getDistanceAsString(LocationHelper locationHelper) {
    double distance = locationHelper.getDistanceBetween(
      startLatitude: event.startingPintLat,
      startLongitude: event.startingPintLong,
      endLatitude: locationHelper.getLastKnownPosition().latitude,
      endLongitude: locationHelper.getLastKnownPosition().longitude,
    );

    if (distance < 1000) {
      return distance.toStringAsFixed(0) + " m away";
    } else {
      distance = distance / 1000;
      return distance.toStringAsFixed(0) + " km away";
    }
  }

  void selectEvent(BuildContext context) {
    // add this event to the recently viewed events

    Navigator.of(context).pushNamed(
      EventDetailsScreen.routeName,
      arguments: event,
    );
    Provider.of<Events>(context, listen: false).addRecentEvent(
      event,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    final double screenWidth = MediaQuery.of(context).size.width;

    Color colorGradient = (Color.lerp(colors.primaryColor,
        colors.secondaryColor, (index / 2).toDouble() / totAmount))!;
    String name = event.name;
    // name = name.replaceRange(5, name.length, '...');
    Color _participantsColor;
    if (event.currentParticipants < event.maxParticipants) {
      _participantsColor = colors.secondaryTextColor;
    } else {
      _participantsColor = colors.errorColor;
    }
    return InkWell(
      onTap: () => selectEvent(context),
      child: Card(
        color: colors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: border,
        margin: const EdgeInsets.all(0),
        child: Column(children: [
          // Title row
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.only(
                    left: 10.0 + multiDeviceSupport.tablet * 10, top: 10),
                // margin: EdgeInsets.only(right: 0),
                // width: screenWidth / ((2 + multiDeviceSupport.tablet) * view),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: multiDeviceSupport.h2,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  right: 10 + multiDeviceSupport.tablet * 10, top: 8),
              height: 15,
              child: Text(
                event.currentParticipants.toString() +
                    '/' +
                    event.maxParticipants.toString(),
                overflow: TextOverflow.ellipsis,
                key: const Key("participants"),
                style: event.currentParticipants == event.maxParticipants
                    ? TextStyle(
                        height: 0.3,
                        color: colors.errorColor,
                        fontWeight: FontWeight.w600,
                        fontSize: multiDeviceSupport.h4)
                    : TextStyle(
                        height: 0.3,
                        color: colorGradient,
                        fontWeight: FontWeight.w600,
                        fontSize: multiDeviceSupport.h4),
              ),
            )
          ]),
          // Date row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10 + multiDeviceSupport.tablet * 10,
                      vertical: 10),
                  height: 40 + multiDeviceSupport.tablet * 20,
                  // width: screenWidth / 3 - multiDeviceSupport.tablet * 80,
                  child: Text(
                    DateFormat.MEd()
                            .format(
                              DateTime.parse(event.date.toString()),
                            )
                            .toString() +
                        ' at ' +
                        DateFormat.Hm()
                            .format(
                              DateTime.parse(event.date.toString()),
                            )
                            .toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        height: 1,
                        color: colors.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: multiDeviceSupport.h4),
                  ),
                ),
              ),
            ],
          ),
          // DIstance and lenght row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10 + multiDeviceSupport.tablet * 10,
                      vertical: 0),
                  height: 15 + multiDeviceSupport.isLandscape == 1 ? 20 : 0,
                  child: Text(
                    _getDistanceAsString(locationHelper),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        height: 0.3,
                        color: colors.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: multiDeviceSupport.h4),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10 + multiDeviceSupport.tablet * 10,
                    vertical: 2 + multiDeviceSupport.isLandscape == 1 ? 20 : 0),
                child: Rating(
                  value: event.difficultyLevel,
                  color: colorGradient,
                  size: multiDeviceSupport.h4,
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 10 + multiDeviceSupport.tablet * 10,
                      top: 10,
                      right: 10 + multiDeviceSupport.tablet * 10),
                  height: 15 + multiDeviceSupport.isLandscape == 1 ? 20 : 0,
                  child: Text(
                    event.averageLength.toString() + ' km',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        height:
                            0.3 + multiDeviceSupport.isLandscape == 1 ? 1 : 0,
                        color: colors.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: multiDeviceSupport.h4),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

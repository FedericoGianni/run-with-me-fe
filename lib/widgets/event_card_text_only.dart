import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:runwithme/providers/locationHelper.dart';
// import 'package:intl/intl.dart';
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
  final int totAmount;
  double border;

  EventItem(this.event, this.index, this.totAmount, {this.border = 4.0});

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
      return distance.toStringAsFixed(2) + " km away";
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
    final locationHelper = Provider.of<LocationHelper>(context);

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
            Container(
              padding: const EdgeInsets.all(10.0),
              width: screenWidth / 3.5,
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10, top: 8),
              height: 15,
              child: Text(
                event.currentParticipants.toString() +
                    '/' +
                    event.maxParticipants.toString(),
                style: event.currentParticipants == event.maxParticipants
                    ? TextStyle(
                        height: 0.3,
                        color: colors.errorColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)
                    : TextStyle(
                        height: 0.3,
                        color: colorGradient,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
              ),
            )
          ]),
          // Date row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 30,
                width: 140,
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
                  style: TextStyle(
                      height: 1,
                      color: colors.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
            ],
            // trailing: SizedBox(
            //   height: double.infinity,
            //   child: Column(
            //     children: [
            //       Text(
            //         event.currentParticipants.toString() +
            //             '/' +
            //             event.maxParticipants.toString(),
            //         style: TextStyle(
            //           color: _participantsColor,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       const SizedBox(height: 10),
            //       Text(
            //         event.averageLength.toString() + ' km',
            //         style: TextStyle(
            //           color: colorGradient,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ),
          // DIstance and lenght row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                height: 15,
                child: Text(
                  _getDistanceAsString(locationHelper),
                  style: TextStyle(
                      height: 0.3,
                      color: colors.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Rating(
                  value: event.difficultyLevel,
                  color: colorGradient,
                  size: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                height: 15,
                child: Text(
                  event.averageLength.toString() + ' km',
                  style: TextStyle(
                      height: 0.3,
                      color: colors.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}



// Rating(
//                       value: event.difficultyLevel,
//                       color: colorGradient,
//                       size: 12,
//                     ),
//                   ],
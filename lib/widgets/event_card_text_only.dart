import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  const EventItem(this.event, this.index, this.totAmount);

  void selectEvent(BuildContext context) {
    // add this event to the recently viewed events
    Provider.of<Events>(context, listen: false).addRecentEvent(
      event,
    );

    Navigator.of(context).pushNamed(
      EventDetailsScreen.routeName,
      arguments: event,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        margin: const EdgeInsets.all(0),
        child: Column(children: [
          ListTile(
            // leading: SizedBox(
            //   height: double.infinity,
            //   child: CircleAvatar(radius: 10, backgroundColor: colorGradient),
            // ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
            title: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: colors.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900),
            ),
          ),
          ListTile(
            leading: SizedBox(
              height: double.infinity,
              width: 75,
              child: Column(
                children: [
                  Text(
                    DateFormat.MEd().format(
                      DateTime.parse(event.date.toString()),
                    ),
                    style: TextStyle(
                      color: colors.secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Rating(
                    value: event.difficultyLevel,
                    color: colorGradient,
                    size: 12,
                  ),
                ],
              ),
            ),
            contentPadding:
                const EdgeInsets.only(bottom: 0, top: 0, left: 10, right: 10),
            trailing: SizedBox(
              height: double.infinity,
              child: Column(
                children: [
                  Text(
                    event.currentParticipants.toString() +
                        '/' +
                        event.maxParticipants.toString(),
                    style: TextStyle(
                      color: _participantsColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.averageLength.toString() + ' km',
                    style: TextStyle(
                      color: colorGradient,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

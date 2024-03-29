import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import '../classes/multi_device_support.dart';
import '../classes/date_helper.dart';
import '../themes/custom_colors.dart';
import '../providers/event.dart';
import 'rating.dart';
import '../screens/event_details_screen.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';

// ignore: camel_case_types
class EventDetail extends StatelessWidget {
  EventDetail(this.event);
  final Event event;

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    // name = name.replaceRange(5, name.length, '...');
    return Column(
      children: [
        Card(
          color: colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: 10 + multiDeviceSupport.tablet * 10),
          child: Container(
            child: Column(
              children: [
                UserInfoFilling('Name', event.name),
                UserInfoFilling(
                    'Date',
                    event.date.day.toString() +
                        "/" +
                        event.date.month.toString() +
                        "/" +
                        event.date.year.toString()),
                UserInfoFilling(
                    'Time',
                    DateHelper.formatHourOrMinutes(event.date.hour.toString()) +
                        ":" +
                        DateHelper.formatHourOrMinutes(
                            event.date.minute.toString())),
                //UserInfoFilling('Email', "test" ?? ''),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        Card(
          color: colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: 10 + multiDeviceSupport.tablet * 10),
          child: Container(
            child: Column(
              children: [
                UserInfoFilling(
                    'Distance', event.averageLength.toString() + " kms"),
                UserInfoFilling(
                    'Duration', event.averageDuration.toString() + " mins"),
                UserInfoFilling(
                    'Average Pace',
                    event.averagePaceMin.toString() +
                        ":" +
                        event.averagePaceSec.toString() +
                        " min/km"),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        Card(
          color: colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: 10 + multiDeviceSupport.tablet * 10),
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "Difficulty Level",
                        style: TextStyle(
                            color: colors.primaryTextColor, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Rating(
                  value: event.difficultyLevel,
                  color: colors.primaryColor,
                  size: 12,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        Card(
          color: colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          margin: EdgeInsets.only(
              top: 10 + multiDeviceSupport.tablet * 10,
              bottom: 20 + multiDeviceSupport.tablet * 20),
          child: Container(
            child: Column(
              children: [
                UserInfoFilling(
                    'Current Participants',
                    event.currentParticipants.toString() +
                        " / " +
                        event.maxParticipants.toString()),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }
}

class UserInfoFilling extends StatelessWidget {
  final String title;
  final String description;

  const UserInfoFilling(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                title,
                style: TextStyle(color: colors.primaryTextColor, fontSize: 18),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                description,
                style:
                    TextStyle(color: colors.secondaryTextColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

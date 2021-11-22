import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import '../themes/custom_colors.dart';
import '../models/event.dart';

// ignore: camel_case_types
class EventItem extends StatelessWidget {
  final Event event;
  final int index;
  final double totAmount;

  EventItem(this.event, this.index, this.totAmount);

  @override
  Widget build(BuildContext context) {
    final colorGradient = Color.lerp(
        primaryColor, secondaryColor, (index / 2).toDouble() / totAmount);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 3,
      ),
      child: Column(children: [
        ListTile(
          leading: SizedBox(
            height: double.infinity,
            child: CircleAvatar(radius: 10, backgroundColor: colorGradient),
          ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
          title: Text(
            event.name,
            style: TextStyle(
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                Text(
                  event.date,
                  style: TextStyle(color: secondaryTextColor),
                ),
                const SizedBox(height: 10),
                Text(
                  // event.difficultyLevel.toString(),
                  '* * * * *',
                  style: TextStyle(color: secondaryTextColor),
                )
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
                  style: TextStyle(color: secondaryTextColor),
                ),
                const SizedBox(height: 10),
                Text(
                  event.averageLength.toString() + ' km',
                  style: TextStyle(color: colorGradient),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

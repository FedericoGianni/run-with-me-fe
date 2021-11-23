import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import '../themes/custom_colors.dart';
import '../models/event.dart';
import 'rating.dart';

// ignore: camel_case_types
class EventItem extends StatelessWidget {
  final Event event;
  final int index;
  final double totAmount;

  EventItem(this.event, this.index, this.totAmount);

  @override
  Widget build(BuildContext context) {
    Color colorGradient = (Color.lerp(
        primaryColor, secondaryColor, (index / 2).toDouble() / totAmount))!;
    String name = event.name;
    name = name.replaceRange(5, name.length, '...');

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
            name,
            style: TextStyle(
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: SizedBox(
            height: double.infinity,
            width: 75,
            child: Column(
              children: [
                Text(
                  event.date,
                  style: TextStyle(color: secondaryTextColor),
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

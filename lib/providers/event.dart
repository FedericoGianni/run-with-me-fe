///{@category Providers}

/// Object describing a general event in all its properties.
import 'package:flutter/cupertino.dart';

/// This is also a provider since an event can be modified by some other module.

class Event with ChangeNotifier {
  /// The unique id of the [Event]
  var id;

  /// The name of the [Event]
  final String name;

  /// The time when the [Event] was created
  final DateTime createdAt;

  /// The time when the [Event] will take place
  final DateTime date;

  /// The longitude of the starting point of the [Event]
  final double startingPintLong;

  /// The latitude of the starting point of the [Event]
  final double startingPintLat;

  /// The difficulty level of the [Event] from 0 to 5
  final double difficultyLevel;

  /// The average pace of the [Event], but only the minutes
  final int averagePaceMin;

  /// The average pace of the [Event], but only the seconds
  final int averagePaceSec;

  /// The foreseen average duration of the [Event] in minutes
  final int averageDuration;

  /// The lenght of the [Event] in km
  final int averageLength;

  /// The unique id of the creator of the [Event]
  final int adminId;

  /// The current number of participants to the [Event]
  final int currentParticipants;

  /// The maximum number of participants to the [Event]
  final int maxParticipants;

  /// Bool that tells whether the current user is subscribed to the [Event] or not.
  final bool userBooked;

  Event(
      {required this.id,
      required this.createdAt,
      required this.name,
      required this.date,
      required this.startingPintLat,
      required this.startingPintLong,
      required this.difficultyLevel,
      required this.averagePaceMin,
      required this.averagePaceSec,
      required this.averageDuration,
      required this.averageLength,
      required this.adminId,
      required this.currentParticipants,
      required this.maxParticipants,
      this.userBooked = false});
}

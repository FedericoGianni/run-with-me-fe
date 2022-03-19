import 'package:flutter/cupertino.dart';

class Event with ChangeNotifier {
  var id;
  final String name;
  final DateTime createdAt;
  final DateTime date;
  final double startingPintLong;
  final double startingPintLat;
  final double difficultyLevel;
  final int averagePaceMin;
  final int averagePaceSec;
  final int averageDuration;
  final int averageLength;
  final int adminId;
  final int currentParticipants;
  final int maxParticipants;
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

import 'package:flutter/cupertino.dart';

class Event with ChangeNotifier {
  final int id;
  final String createdAt;
  final String name;
  final String date;
  final double startingPintLong;
  final double startingPintLat;
  final double difficultyLevel;
  final double averagePace;
  final int averageDuration;
  final int averageLength;
  final int adminId;
  final int currentParticipants;
  final int maxParticipants;

  Event(
      {required this.id,
      required this.createdAt,
      required this.name,
      required this.date,
      required this.startingPintLat,
      required this.startingPintLong,
      required this.difficultyLevel,
      required this.averagePace,
      required this.averageDuration,
      required this.averageLength,
      required this.adminId,
      required this.currentParticipants,
      required this.maxParticipants});
}

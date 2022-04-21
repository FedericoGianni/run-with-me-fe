///{@category Classes}
///A module to precompute the statistics that are presented to the user in the home screen.
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/classes/date_helper.dart';
import 'package:runwithme/providers/events.dart';

import 'date_helper.dart';

class StatsHelper {
  late BuildContext _context;
  static const int lastDaysStats = 7;

  StatsHelper(context) {
    _context = context;
  }

  /// Computes the user total weekly run distance in kilometers
  int calcWeeklyKms() {
    int kms = 0;
    //_pastBookedEvents is reduced to 2 events only, for stats purposes i need full booked events, but only in the past
    Provider.of<Events>(_context, listen: false)
        .bookedEvents
        .where((element) => element.date.isBefore(DateTime.now()))
        .toList()
        .forEach((event) {
      if (DateHelper.diffInDays(event.date, DateTime.now()) <= lastDaysStats) {
        kms += event.averageLength;
      }
    });
    return kms;
  }

  /// Computes the user total weekly run distance in minutes
  int calcWeeklyMins() {
    int mins = 0;
    //_pastBookedEvents is reduced to 2 events only, for stats purposes i need full booked events, but only in the past
    Provider.of<Events>(_context, listen: false)
        .bookedEvents
        .where((element) => element.date.isBefore(DateTime.now()))
        .toList()
        .forEach((event) {
      if (DateHelper.diffInDays(event.date, DateTime.now()) <= lastDaysStats) {
        mins += event.averageDuration;
      }
    });
    return mins;
  }

  /// Computes the user average weekly pace.
  List<int> calcWeeklyAvgPace() {
    int distance = calcWeeklyKms();
    int minutes = calcWeeklyMins();

    List<int> avgPace = [];
    int avgPaceMin;
    int avgPaceSec;

    int totalSeconds = minutes * 60;
    double secondsPerKm = totalSeconds.toDouble() / distance.toDouble();

    avgPaceMin = (secondsPerKm / 60).toInt();
    avgPaceSec = (secondsPerKm - (avgPaceMin * 60)).toInt();

    avgPace.add(avgPaceMin);
    avgPace.add(avgPaceSec);

    return avgPace;
  }

  /// Computes the user average weekly pace based on total [distance] and [minutes] run.
  List<int> calcWeeklyAvgPaceParams(int distance, int minutes) {
    List<int> avgPace = [];
    int avgPaceMin;
    int avgPaceSec;

    if (distance == 0 || minutes == 0) {
      avgPace.add(0);
      avgPace.add(0);
      return avgPace;
    }

    int totalSeconds = minutes * 60;
    double secondsPerKm = totalSeconds.toDouble() / distance.toDouble();

    avgPaceMin = (secondsPerKm / 60).toInt();
    avgPaceSec = (secondsPerKm - (avgPaceMin * 60)).toInt();

    avgPace.add(avgPaceMin);
    avgPace.add(avgPaceSec);

    return avgPace;
  }
}

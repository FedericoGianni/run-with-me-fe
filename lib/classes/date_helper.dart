///{@category Classes}
/// A class to help with date and time management and formatting
import 'package:intl/intl.dart';

class DateHelper {
  /// Determines if the time is to be expressed in hours or minutes.
  static String formatHourOrMinutes(String input) {
    return input.toString().length < 2
        ? "0" + input.toString()
        : input.toString();
  }

  /// Computes the number of days between two dates.
  static int diffInDays(DateTime date1, DateTime date2) {
    return ((date1.difference(date2) -
                    Duration(hours: date1.hour) +
                    Duration(hours: date2.hour))
                .inHours /
            24)
        .round();
  }

  // +1 tomorrow
  // 0 today
  // -1 yesterday
  static int calculateDifference(DateTime? date) {
    if (date != null) {
      DateTime now = DateTime.now();
      return DateTime(date.year, date.month, date.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
    }
    // TODO shouldn't return this as it's bad to debug, but i need to use DateTime? instead of DateTime
    return -99999;
  }

  ///Return formatted datetime as string.
  static String formatDateTime(DateTime dateTime) {
    return dateTime.day.toString() +
        "/" +
        dateTime.month.toString() +
        "/" +
        dateTime.year.toString();
  }

  /// Returns the day of the week as a String for tomorrow
  static String dayOfWeekAfterTomorrow() {
    DateTime dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
    return DateFormat('EEEE').format(dayAfterTomorrow);
  }

  /// Returns the day of the week as a String for [x] days from today
  static String dayOfWeekAfterXdays(int x) {
    if (x != null) {
      DateTime day = DateTime.now().add(Duration(days: x));
      return DateFormat('EEEE').format(day);
    }

    return "";
  }
}

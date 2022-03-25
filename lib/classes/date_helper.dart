import 'package:intl/intl.dart';

class DateHelper {
  static String formatHourOrMinutes(String input) {
    return input.toString().length < 2
        ? "0" + input.toString()
        : input.toString();
  }

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

  static String formatDateTime(DateTime dateTime) {
    return dateTime.day.toString() +
        "/" +
        dateTime.month.toString() +
        "/" +
        dateTime.year.toString();
  }

  static String dayOfWeekAfterTomorrow() {
    DateTime dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
    return DateFormat('EEEE').format(dayAfterTomorrow);
  }
}

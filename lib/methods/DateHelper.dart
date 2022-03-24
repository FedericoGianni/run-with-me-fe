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
}

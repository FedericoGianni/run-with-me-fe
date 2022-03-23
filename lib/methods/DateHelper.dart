class DateHelper {
  static String formatHourOrMinutes(String input) {
    return input.toString().length < 2
        ? "0" + input.toString()
        : input.toString();
  }
}

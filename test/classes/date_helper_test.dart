import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/classes/date_helper.dart';

void main() {
  DateTime today = DateTime.now();

  //friday
  DateTime friday = DateTime.parse("2021-12-31");
  DateTime saturday = DateTime.parse("2022-1-01");
  List<String> weekDays = [];
  weekDays.addAll(
      ["Monday, Thuesday,  Wednesday, Thursday, Friday, Saturday, Sunday"]);

  group('[DATE HELPER]', () {
    test('day of week after tomorrow returns a string', () {
      expect(DateHelper.dayOfWeekAfterTomorrow().isNotEmpty, true);
    });

    test('diff in days', () {
      expect(DateHelper.diffInDays(friday, saturday), 1);
    });
  });
}

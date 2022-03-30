import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/classes/date_helper.dart';

void main() {
  DateTime today = DateTime.now();

  //friday
  DateTime friday = DateTime.parse("2021-12-31");
  List<String> weekDays = [];
  weekDays.addAll(
      ["Monday, Thuesday,  Wednesday, Thursday, Friday, Saturday, Sunday"]);

  group('[DATE HELPER]', () {
    test('', () {
      expect(DateHelper.dayOfWeekAfterTomorrow().isNotEmpty, true);
    });
  });
}

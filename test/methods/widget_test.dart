import 'package:test/test.dart';

void main() {
  group('Test Group', () {
    test('value should start at 0', () {
      expect(0, 0);
    });

    test('value should be incremented', () {
      int counter = 0;
      counter++;
      expect(counter, 1);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/providers/user.dart';

void main() {
  User user = User();
  group('[USER]', () {
    // needed for suggested events for non-logged users
    test('fitness level should have a default value', () {
      expect(user.fitnessLevel, user.defaultFitnessLevel);
    });
  });
}

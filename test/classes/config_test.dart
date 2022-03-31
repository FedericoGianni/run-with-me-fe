import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/classes/config.dart';

void main() {
  group('[CONFIG]', () {
    test('baseUrl test', () {
      Pattern urlPattern = RegExp(r'http');
      expect(Config.baseUrl.startsWith(urlPattern), true);
    });
  });
}

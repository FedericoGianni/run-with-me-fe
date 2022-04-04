import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/classes/config.dart';

void main() {
  group('[CONFIG]', () {
    test('baseUrl test', () {
      Config config = Config();
      String baseUrl = config.getBaseUrl();
      Pattern urlPattern = RegExp(r'http');
      expect(baseUrl.startsWith(urlPattern), true);

      int apiTimeOut = config.getApiTimeout();
      expect(apiTimeOut >= 0, true);
    });
  });
}

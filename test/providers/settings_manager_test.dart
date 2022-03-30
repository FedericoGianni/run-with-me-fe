import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/settings_manager.dart';

void main() {
  UserSettings userSettings = UserSettings();
  CustomColorScheme colorScheme = CustomColorScheme();

  group('[SETTINGS MANAGER]', () {
    test('isLoggedIn should be false', () {
      expect(userSettings.settings.isLoggedIn, false);

      colorScheme.setDarkMode();
      userSettings.setColorScheme(colorScheme);
    });

    test('settings should change color scheme', () {
      colorScheme.setDarkMode();
      userSettings.setColorScheme(colorScheme);
      expect(userSettings.colors.currentMode, 'dark');

      colorScheme.setLightMode();
      userSettings.setColorScheme(colorScheme);
      expect(userSettings.colors.currentMode, 'light');
    });
  });
}

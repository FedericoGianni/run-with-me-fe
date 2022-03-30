import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:runwithme/providers/color_scheme.dart';
//import 'package:provider/provider.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  //MockBuildContext _mockContext;
  CustomColorScheme colorScheme = CustomColorScheme();

  group('[COLOR SCHEME]', () {
    test('light color test', () {
      colorScheme.setLightMode();
      expect(colorScheme.currentMode, 'light');
    });
    test('dark color test', () {
      colorScheme.setDarkMode();
      expect(colorScheme.currentMode, 'dark');
    });
  });
}

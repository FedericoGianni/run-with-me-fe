import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/custom_slider.dart';
import 'package:runwithme/widgets/custom_snackbar.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  testWidgets('[CUSTOM SLIDER TEST]', (WidgetTester tester) async {
    void setScreenSize({required int width, required int height}) {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue =
          Size(width * dpi, height * dpi);
    }

    MockBuildContext _mockContext = MockBuildContext();

    // used because deafult test widget env is 400x600 so it overflows
    //setScreenSize(width: 1080, height: 2000);

    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<CustomColorScheme>.value(
              value: CustomColorScheme()),
          ChangeNotifierProvider<Events>.value(value: Events()),
          ChangeNotifierProvider<LocationHelper>.value(
            value: LocationHelper(),
          ),
          ChangeNotifierProvider<UserSettings>.value(
            value: UserSettings(),
          ),
          ChangeNotifierProvider<PageIndex>.value(
            value: PageIndex(),
          ),
          ChangeNotifierProvider<User>.value(
            value: User(),
          ),
        ],
        child: MaterialApp(
          home: Material(
              child: SingleChildScrollView(
            child: CustomSlider(sliderValue: 1.0, onSliderMove: (double d) {}),
          )),
        )));

    expect(find.byType(SliderTheme), findsOneWidget);

    SliderTheme widget =
        find.byType(SliderTheme).first.evaluate().single.widget as SliderTheme;
    expect(widget.data.runtimeType, SliderThemeData);
    expect(widget.data.showValueIndicator, ShowValueIndicator.never);
  });
}

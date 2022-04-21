import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/location_helper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/gradient_appbar.dart';

void main() {
  testWidgets('[GRADIENT APP BAR]', (WidgetTester tester) async {
    void setScreenSize({required int width, required int height}) {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue =
          Size(width * dpi, height * dpi);
    }

    // used because deafult test widget env is 400x600 so it overflows
    //setScreenSize(width: 1080, height: 2000);

    List<Widget> _widgetList = [];

    await tester.pumpWidget(
      MultiProvider(
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
            child: GradientAppBar(200, _widgetList),
          ))),
    );

    expect(find.byType(Container), findsOneWidget);
  });
}

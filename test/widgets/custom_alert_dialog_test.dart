import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/location_helper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/custom_alert_dialog.dart';

void main() {
  testWidgets('[CUSTOM ALERT DIALOG TEST]', (WidgetTester tester) async {
    void setScreenSize({required int width, required int height}) {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue =
          Size(width * dpi, height * dpi);
    }

    // used because deafult test widget env is 400x600 so it overflows
    setScreenSize(width: 1080, height: 1920);

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
          child: CustomAlertDialog(
            title: '',
            message: '',
            onAccept: () {},
            onDismiss: () {},
          ),
        ))));

    expect(find.byType(Text), findsWidgets);
    expect(find.byType(TextButton), findsWidgets);
  });
}

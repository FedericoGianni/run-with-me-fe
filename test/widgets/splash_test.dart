import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/classes/multi_device_support.dart';
import 'package:runwithme/main.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/location_helper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/screens/add_event_screen.dart';
import 'package:runwithme/screens/booked_events_screen.dart';
import 'package:runwithme/screens/event_details_screen.dart';
import 'package:runwithme/screens/home_screen.dart';
import 'package:runwithme/screens/search_screen.dart';
import 'package:runwithme/screens/tabs_screen.dart';
import 'package:runwithme/screens/user_screen.dart';
import 'package:runwithme/themes/custom_theme.dart';
import 'package:runwithme/widgets/custom_loading_animation.dart';
import 'package:runwithme/widgets/custom_sort_by_button.dart';
import 'package:runwithme/widgets/permissions_message.dart';
import 'package:runwithme/widgets/sort_by.dart';
import 'package:runwithme/widgets/splash.dart';

void main() {
  testWidgets('[SPLASH]', (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(providers: [
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
    ], child: const MaterialApp(home: SplashScreen())));

    // expected to find text and image
    expect(find.text('DIMA Project 2021'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    Image image = find.byType(Image).first.evaluate().single.widget as Image;

    // image width should be at least 180 (+ multiDeviceSupport.tablet * 90)
    expect(image.width! >= 180, true);

    expect(find.byType(Container), findsOneWidget);

    Container container =
        find.byType(Container).first.evaluate().single.widget as Container;

    // expected to find 30 padding inside container
    expect(container.padding, const EdgeInsets.all(30));
  });
}

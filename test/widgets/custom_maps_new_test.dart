import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/custom_info_window.dart';
import 'package:runwithme/widgets/custom_maps_new.dart';

void main() {
  testWidgets('[CUSTOM MAPS NEW TEST]', (WidgetTester tester) async {
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
          child: CustomMapsNew(
            centerPosition: const LatLng(0.0, 0.0),
            markerPosition: const LatLng(1.0, 1.0),
          ),
        ))));

    expect(find.byType(GoogleMap), findsOneWidget);
    expect(find.byType(CustomInfoWindow), findsOneWidget);

    CustomMapsNewState state =
        tester.state<CustomMapsNewState>(find.byType(CustomMapsNew));

    // if marker position != 0,0 it weilll call handle tap, so markers set shouldn't be empty
    expect(state.markers.isNotEmpty, true);
  });

  // instead if marker position = 0,0 markers set should be empty
  testWidgets('[CUSTOM MAPS NEW TEST 2]', (WidgetTester tester) async {
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
          child: CustomMapsNew(
            centerPosition: const LatLng(0, 0),
            markerPosition: const LatLng(0, 0),
          ),
        ))));

    expect(find.byType(GoogleMap), findsOneWidget);
    expect(find.byType(CustomInfoWindow), findsOneWidget);

    CustomMapsNewState state =
        tester.state<CustomMapsNewState>(find.byType(CustomMapsNew));

    state = tester.state<CustomMapsNewState>(find.byType(CustomMapsNew));
    expect(state.markers.isEmpty, true);
  });
}

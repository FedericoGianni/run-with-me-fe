import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/main.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/locationHelper.dart';
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
import 'package:runwithme/widgets/user_info_card.dart';

void main() {
  User _fakeUser = User();

  testWidgets('[USER INFO CARD]', (WidgetTester tester) async {
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
            home: SingleChildScrollView(child: UserInfo(_fakeUser)))));

    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Height'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Sex'), findsOneWidget);
    expect(find.text('Fitness Level'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Default location'), findsOneWidget);
  });
}

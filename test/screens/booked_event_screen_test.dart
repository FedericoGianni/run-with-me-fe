import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/location_helper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/screens/booked_events_screen.dart';
import 'package:runwithme/widgets/custom_loading_animation.dart';
import 'package:runwithme/widgets/permissions_message.dart';

// MOCK PROVIDERS
import '../providers/mock_events_provider.dart';
import '../providers/mock_user_settings_provider.dart';

void main() {
  MockEventsProvider mockEventsProvider = MockEventsProvider();
  MockUserSettingsProvider mockUserSettingsProvider =
      MockUserSettingsProvider();
  testWidgets('[BOOKED EVENTS SCREEN]', (WidgetTester tester) async {
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
        ChangeNotifierProvider<Events>.value(value: mockEventsProvider),
        ChangeNotifierProvider<LocationHelper>.value(
          value: LocationHelper(),
        ),
        ChangeNotifierProvider<UserSettings>.value(
          value: mockUserSettingsProvider,
        ),
        ChangeNotifierProvider<PageIndex>.value(
          value: PageIndex(),
        ),
        ChangeNotifierProvider<User>.value(
          value: User(),
        ),
      ],
      child: MaterialApp(
          home: SingleChildScrollView(
        child: Material(
          child: SizedBox(
              height: 1080,
              width: 1920,
              child: MediaQuery(
                  // to avoid render flex overflow in testing phase
                  data: const MediaQueryData(textScaleFactor: 0.5),
                  child: BookedEventsScreen())),
        ),
      )),
    ));

    // getting widget and context in case we need for testing purposes
    BookedEventsScreen bookedEventsScreen = find
        .byType(BookedEventsScreen)
        .first
        .evaluate()
        .single
        .widget as BookedEventsScreen;

    final BuildContext context = tester
        .state<BookedEventsScreenState>(find.byType(BookedEventsScreen))
        .context;

    // settings isloggedin should be false so it should show permission message
    expect(mockUserSettingsProvider.isLoggedIn(), false);

    // expect CustomLoadingAnimation widget
    expect(find.byType(CustomLoadingAnimation), findsOneWidget);

    // now if we rebuild the UI we should have permission message page cause we are not loddeg in
    await tester.pump();
    expect(find.byType(PermissionMessage), findsOneWidget);

    // now let's set isLoggedIn to true, rebuild UI and expect to not find permission message anymore
    mockUserSettingsProvider.setisLoggedIn(true);
    expect(mockUserSettingsProvider.isLoggedIn(), true);

    tester
        .state<BookedEventsScreenState>(find.byType(BookedEventsScreen))
        .setState(() {});
    await tester.pump();

    expect(find.byType(PermissionMessage), findsNothing);
    expect(find.byKey(const Key("booked_events")), findsOneWidget);
    expect(find.byKey(const Key("past_events")), findsOneWidget);

    // now since i created the widget it should have fetched booked events
    expect(mockEventsProvider.bookedEvents.isNotEmpty, true);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/screens/booked_events_screen.dart';
import 'package:runwithme/screens/event_details_screen.dart';
import 'package:runwithme/widgets/event_card_text_only.dart';

// MOCK PROVIDERS
import '../providers/mock_events_provider.dart';
import '../providers/mock_user_settings_provider.dart';

class MockBuildContext extends Mock implements BuildContext {
  Navigator navigator = const Navigator();
}

void main() {
  MockEventsProvider mockEventsProvider = MockEventsProvider();
  MockUserSettingsProvider mockUserSettingsProvider =
      MockUserSettingsProvider();

  testWidgets('[EVENT DETAIL SCREEN]', (WidgetTester tester) async {
    void setScreenSize({required int width, required int height}) {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue =
          Size(width * dpi, height * dpi);
    }

    MockBuildContext _mockContext = MockBuildContext();
    // used because deafult test widget env is 400x600 so it overflows
    setScreenSize(width: 1080, height: 1920);

    Event _fakeEvent = Event(
        id: -1,
        createdAt: DateTime.now(),
        name: "Your Position",
        date: DateTime.now(),
        startingPintLat: 0.0,
        startingPintLong: 0.0,
        difficultyLevel: 5.0,
        averagePaceMin: 0,
        averagePaceSec: 0,
        averageDuration: 0,
        averageLength: 0,
        adminId: -1,
        currentParticipants: 0,
        maxParticipants: 0);

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
        child: MaterialApp(onGenerateRoute: (settings) {
          return MaterialPageRoute(
            settings:
                // event detail gets event from route settings.arguments
                RouteSettings(arguments: _fakeEvent),
            builder: (context) {
              return const EventDetailsScreen();
            },
          );
        })));

    // getting widget and context in case we need for testing purposes
    EventDetailsScreen eventDetailsScreen = find
        .byType(EventDetailsScreen)
        .first
        .evaluate()
        .single
        .widget as EventDetailsScreen;

    final BuildContext context = tester
        .state<EventDetailsScreenState>(find.byType(EventDetailsScreen))
        .context;

    // settings isloggedin should be false so I should see login to subscribe button
    expect(mockUserSettingsProvider.isLoggedIn(), false);
    expect(find.byKey(const Key("loginToSubscribe")), findsOneWidget);

    // now let's set login to true and rebiuld the widget tree
    mockUserSettingsProvider.setisLoggedIn(true);
    expect(mockUserSettingsProvider.isLoggedIn(), true);
    tester
        .state<EventDetailsScreenState>(find.byType(EventDetailsScreen))
        .setState(() {});
    await tester.pump();
    expect(find.byKey(const Key("loginToSubscribe")), findsNothing);

    expect(find.byType(Text), findsWidgets);

    // the event inside detail screen should be _fakeEvent found in settings.argument
    Event detailEvent = tester
        .state<EventDetailsScreenState>(find.byType(EventDetailsScreen))
        .event;
    expect(detailEvent.id, -1);
    expect(detailEvent.adminId, -1);
  });
}

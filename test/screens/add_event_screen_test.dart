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
import 'package:runwithme/screens/add_event_screen.dart';
import 'package:runwithme/widgets/permissions_message.dart';

// MOCK PROVIDERS
import '../providers/mock_events_provider.dart';
import '../providers/mock_user_settings_provider.dart';

void main() {
  MockEventsProvider mockEventsProvider = MockEventsProvider();
  MockUserSettingsProvider mockUserSettingsProvider =
      MockUserSettingsProvider();
  testWidgets('[ADD EVENT SCREEN]', (WidgetTester tester) async {
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
          child: AddEventScreen(),
        ),
      )),
    ));

    // getting widget and context in case we need for testing purposes
    AddEventScreen addEventScreen = find
        .byType(AddEventScreen)
        .first
        .evaluate()
        .single
        .widget as AddEventScreen;

    final BuildContext context =
        tester.state<AddEventScreenState>(find.byType(AddEventScreen)).context;

    // editedEvent should be initialized
    expect(
        tester
            .state<AddEventScreenState>(find.byType(AddEventScreen))
            .editedEvent
            .currentParticipants,
        0);

    // settings isloggedin should be false so it should show permission message
    expect(mockUserSettingsProvider.isLoggedIn(), false);
    expect(find.byType(PermissionMessage), findsOneWidget);

    // now let's fake login, isLoggedIn should be true so the ui will not render permission message
    mockUserSettingsProvider.setisLoggedIn(true);
    expect(mockUserSettingsProvider.isLoggedIn(), true);

    // rebuild the ui with settings.isLoggedIn now true
    tester
        .state<AddEventScreenState>(find.byType(AddEventScreen))
        .setState(() {});
    await tester.pump();

    // now it should show add event form instead of permission message
    expect(find.byType(Form), findsOneWidget);

    // let's try to add form text name
    await tester.enterText(find.byKey(const Key('name')), "test");
    TextFormField name =
        find.byKey(const Key('name')).evaluate().single.widget as TextFormField;
    name.onSaved!("test");

    tester.state<AddEventScreenState>(find.byType(AddEventScreen)).saveForm();
    expect(
        tester
            .state<AddEventScreenState>(find.byType(AddEventScreen))
            .editedEvent
            .name,
        "test");

    // let's try to add form distance
    await tester.enterText(find.byKey(const Key('distance')), "10");
    TextFormField distance = find
        .byKey(const Key('distance'))
        .evaluate()
        .single
        .widget as TextFormField;
    distance.onSaved!("10");

    tester.state<AddEventScreenState>(find.byType(AddEventScreen)).saveForm();
    expect(
        tester
            .state<AddEventScreenState>(find.byType(AddEventScreen))
            .editedEvent
            .averageLength,
        10);

    // let's try to add invalid duration
    await tester.enterText(find.byKey(const Key('distance')), "300");
    TextFormField duration = find
        .byKey(const Key('duration'))
        .evaluate()
        .single
        .widget as TextFormField;
    expect(duration.validator!("300"),
        "Duration should be less than 200 minutes.");

    // let's try to add valid duration
    await tester.enterText(find.byKey(const Key('duration')), "30");
    duration.onSaved!("30");

    tester.state<AddEventScreenState>(find.byType(AddEventScreen)).saveForm();
    expect(
        tester
            .state<AddEventScreenState>(find.byType(AddEventScreen))
            .editedEvent
            .averageDuration,
        30);

    // marker position should be initialized
    expect(
        tester
            .state<AddEventScreenState>(find.byType(AddEventScreen))
            .markerPosition,
        const LatLng(0, 0));

    // adding event to the mockEventProvider
    mockEventsProvider.addEvent(tester
        .state<AddEventScreenState>(find.byType(AddEventScreen))
        .editedEvent);

    // expect that the event is actually added to the event list
    expect(
        mockEventsProvider.dummyEvents.contains(tester
            .state<AddEventScreenState>(find.byType(AddEventScreen))
            .editedEvent),
        true);
  });
}

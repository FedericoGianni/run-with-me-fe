import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/screens/booked_events_screen.dart';
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
          child:
              SizedBox(height: 2000, width: 2000, child: BookedEventsScreen()),
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

    // tester
    //     .state<BookedEventsScreenState>(find.byType(BookedEventsScreen))
    //     .didChangeDependencies();

    // settings isloggedin should be false so it should show permission message
    expect(mockUserSettingsProvider.isLoggedIn(), false);
    print(mockUserSettingsProvider.isLoggedIn());

    //expect(find.byType(PermissionMessage), findsOneWidget);

    // // now let's fake login, isLoggedIn should be true so the ui will not render permission message
    // mockUserSettingsProvider.setisLoggedIn(true);
    // expect(mockUserSettingsProvider.isLoggedIn(), true);

    // // // rebuild the ui with settings.isLoggedIn now true
    // // tester
    // //     .state<BookedEventsScreenState>(find.byType(BookedEventsScreen))
    // //     .setState(() {});
    // // await tester.pump();

    // // now it should show add event form instead of permission message
    // // expect(find.byType(RefreshIndicator), findsOneWidget);
  });
}

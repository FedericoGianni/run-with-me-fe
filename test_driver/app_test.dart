import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:runwithme/providers/color_scheme.dart';
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
import 'package:runwithme/widgets/permissions_message.dart';

// MOCK PROVIDERS
import '../test/providers/mock_events_provider.dart';
import '../test/providers/mock_location_provider.dart';
import '../test/providers/mock_user_provider.dart';
import '../test/providers/mock_user_settings_provider.dart';

MockEventsProvider mockEventsProvider = MockEventsProvider();
MockUserSettingsProvider mockUserSettingsProvider = MockUserSettingsProvider();
MockLocationProvider mockLocationProvider = MockLocationProvider();
MockUser mockUser = MockUser();

class MockBuildContext extends Mock implements BuildContext {
  Navigator navigator = const Navigator();
}

void main() {
  group('end-to-end test', () {
    testWidgets('app', (WidgetTester tester) async {
      // MOCK CONTEXT
      MockBuildContext _mockContext = MockBuildContext();

      // SCREEN SIZE ADJUSTMENT
      void setScreenSize({required int width, required int height}) {
        final dpi = tester.binding.window.devicePixelRatio;
        tester.binding.window.physicalSizeTestValue =
            Size(width * dpi, height * dpi);
      }

      // used because deafult test widget env is 400x600 so it overflows
      setScreenSize(width: 1080, height: 1920);

      // MOCK MAIN cause I need to put mock providers inside
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CustomColorScheme>.value(
                value: CustomColorScheme()),
            ChangeNotifierProvider<Events>.value(value: mockEventsProvider),
            ChangeNotifierProvider<LocationHelper>.value(
              value: mockLocationProvider,
            ),
            ChangeNotifierProvider<UserSettings>.value(
              value: mockUserSettingsProvider,
            ),
            ChangeNotifierProvider<PageIndex>.value(
              value: PageIndex(),
            ),
            ChangeNotifierProvider<User>.value(
              value: mockUser,
            ),
          ],
          child: MaterialApp(
              initialRoute: '/', // default is '/'
              routes: {
                '/': (ctx) => TabsScreen(),
                AddEventScreen.routeName: (ctx) => AddEventScreen(),
                BookedEventsScreen.routeName: (ctx) => BookedEventsScreen(),
                UserScreen.routeName: (ctx) => UserScreen(),
                HomeScreen.routeName: (ctx) => HomeScreen(),
                EventDetailsScreen.routeName: (ctx) =>
                    const EventDetailsScreen(),
                SearchScreen.routeName: (ctx) => const EventDetailsScreen(),
              },
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  settings:
                      // event detail gets event from route settings.arguments
                      const RouteSettings(),
                  builder: (context) {
                    return Material(
                        child: MediaQuery(
                            data: const MediaQueryData(textScaleFactor: 0.5),
                            child: HomeScreen()));
                  },
                );
              }),
        ),
      );

      // user should not be logged
      expect(mockUserSettingsProvider.isLoggedIn(), false);

      // TABS SCREEN
      // now the app is first set to tabs screen
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      TabsScreen tabsScreen =
          find.byType(TabsScreen).first.evaluate().single.widget as TabsScreen;

      // SEARCH SCREEN
      // now let's switch to search screen
      tester
          .state<TabsScreenState>(find.byType(TabsScreen))
          .selectPage(Screens.SEARCH.index);

      await tester.pump();
      expect(find.byType(SearchScreen), findsOneWidget);

      // BOOKED EVENTS SCREEN
      // now let's switch to booked event screen
      tester
          .state<TabsScreenState>(find.byType(TabsScreen))
          .selectPage(Screens.EVENTS.index);

      await tester.pump();
      expect(find.byType(BookedEventsScreen), findsOneWidget);

      // since we are not logged in we should find Permission Message
      await tester.pump();
      expect(find.byType(PermissionMessage), findsOneWidget);

      // ADD EVENT SCREEN
      // now let's switch to add event screen
      tester
          .state<TabsScreenState>(find.byType(TabsScreen))
          .selectPage(Screens.NEW.index);

      await tester.pump();
      expect(find.byType(AddEventScreen), findsOneWidget);

      // since we are not logged in we should find Permission Message
      await tester.pump();
      expect(find.byType(PermissionMessage), findsOneWidget);

      // USER SCREEN
      // now let's switch to user screen
      tester
          .state<TabsScreenState>(find.byType(TabsScreen))
          .selectPage(Screens.USER.index);

      await tester.pump();
      expect(find.byType(UserScreen), findsOneWidget);

      // now let's set login to true and rebuild everything
      mockUserSettingsProvider.setisLoggedIn(true);
      expect(mockUserSettingsProvider.isLoggedIn(), true);
      await tester.pump();

      // BOOKED EVENTS SCREEN (+login)
      // now let's switch to booked event screen while logged in
      tester
          .state<TabsScreenState>(find.byType(TabsScreen))
          .selectPage(Screens.EVENTS.index);

      await tester.pump();
      expect(find.byType(BookedEventsScreen), findsOneWidget);

      // }
    });
  });
}

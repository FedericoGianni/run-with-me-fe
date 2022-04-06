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
import 'package:runwithme/screens/tabs_screen.dart';
import 'package:runwithme/widgets/event_card_text_only.dart';

// MOCK PROVIDERS
import '../providers/mock_events_provider.dart';
import '../providers/mock_location_provider.dart';
import '../providers/mock_user_settings_provider.dart';

class MockBuildContext extends Mock implements BuildContext {
  Navigator navigator = const Navigator();
}

void main() {
  MockEventsProvider mockEventsProvider = MockEventsProvider();
  MockUserSettingsProvider mockUserSettingsProvider =
      MockUserSettingsProvider();
  MockLocationProvider mockLocationProvider = MockLocationProvider();

  testWidgets('[TABS SCREEN]', (WidgetTester tester) async {
    void setScreenSize({required int width, required int height}) {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue =
          Size(width * dpi, height * dpi);
    }

    MockBuildContext _mockContext = MockBuildContext();
    // used because deafult test widget env is 400x600 so it overflows
    setScreenSize(width: 1080, height: 1920);

    await tester.pumpWidget(MultiProvider(
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
            value: User(),
          ),
        ],
        child: MaterialApp(onGenerateRoute: (settings) {
          return MaterialPageRoute(
            settings:
                // event detail gets event from route settings.arguments
                const RouteSettings(),
            builder: (context) {
              return TabsScreen();
            },
          );
        })));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}

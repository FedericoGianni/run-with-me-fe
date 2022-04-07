import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:runwithme/main.dart' as app;
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/screens/home_screen.dart';

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
              value: mockUser,
            ),
          ],
          child: MaterialApp(onGenerateRoute: (settings) {
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
          })));
    });
  });
}

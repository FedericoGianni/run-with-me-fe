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

void main() {
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
          home: SingleChildScrollView(
        child: Material(
          child: AddEventScreen(),
        ),
      )),
    ));

    expect(
        tester
            .state<AddEventScreenState>(find.byType(AddEventScreen))
            .editedEvent
            .currentParticipants,
        0);

    AddEventScreen addEventScreen = find
        .byType(AddEventScreen)
        .first
        .evaluate()
        .single
        .widget as AddEventScreen;

    // settings isloggedin is false so it should show permission message
    expect(find.byType(PermissionMessage), findsOneWidget);

    final BuildContext context =
        tester.state<AddEventScreenState>(find.byType(AddEventScreen)).context;
    var userSettings = Provider.of<UserSettings>(context, listen: false);

    tester.state<AddEventScreenState>(find.byType(AddEventScreen)).setState(() {
      userSettings.setisLoggedIn(true);
    });

    expect(userSettings.isLoggedIn(), true);

    expect(
        tester
            .state<AddEventScreenState>(find.byType(AddEventScreen))
            .markerPosition,
        const LatLng(0, 0));
  });
}

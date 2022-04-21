import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/classes/multi_device_support.dart';
import 'package:runwithme/main.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/event.dart';
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
import 'package:runwithme/themes/custom_theme.dart';
import 'package:runwithme/widgets/custom_loading_animation.dart';
import 'package:runwithme/widgets/custom_sort_by_button.dart';
import 'package:runwithme/widgets/permissions_message.dart';
import 'package:runwithme/widgets/search_button.dart';
import 'package:runwithme/widgets/search_event_bottomsheet.dart';
import 'package:runwithme/widgets/sort_by.dart';
import 'package:runwithme/widgets/splash.dart';
import 'package:runwithme/widgets/user_info_card.dart';

void main() {
  Map<String, dynamic> _formValues;
  _formValues = {
    'show_full': false,
    'slider_value': 0.0,
    'city_name': '',
    'city_lat': '',
    'city_long': ''
  };
  final Function(Map<String, dynamic>) _onFormAccept = (p0) => false;

  testWidgets('[SEARCH BUTTON]', (WidgetTester tester) async {
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
          child: SingleChildScrollView(
            child: SearchButton(Icon(IconData(1)), Text("A"),
                formValues: _formValues, onSubmitting: _onFormAccept),
          ),
        ),
      )),
    ));
    // for(widget in tester.allWidgets){
    //   w
    // }

    GestureDetector gestureDetector = find
        .byType(GestureDetector)
        .first
        .evaluate()
        .single
        .widget as GestureDetector;

    expect(find.byType(GestureDetector), findsOneWidget);

    expect(find.byType(Container), findsOneWidget);
  });
}

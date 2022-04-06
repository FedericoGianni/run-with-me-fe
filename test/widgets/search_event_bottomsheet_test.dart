import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/classes/multi_device_support.dart';
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

  testWidgets('[SEARCH EVENT BOTTOM SHEET]', (WidgetTester tester) async {
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
            child: SearchEventBottomSheet(
                formValues: _formValues, onFormAccept: _onFormAccept),
          ),
        ),
      )),
    ));

    // expected to find text
    expect(find.text('Search for an event'), findsOneWidget);

    // try form validator expecting an error message telling you need to provide city value
    _formValues = {
      'show_full': true,
      'slider_value': 0.0,
      'city_name': '',
      'city_lat': '0.0',
      'city_long': '0.0'
    };

    Form form = find.byType(Form).first.evaluate().single.widget as Form;

    FormField formField = form.child as FormField;
    expect(
        formField.validator?.call(form).toString(), 'Please provide a value.');

    // now put a value inside city and expect not to get an error message
    _formValues = {
      'show_full': true,
      'slider_value': 0.0,
      'city_name': 'Milano',
      'city_lat': '0.0',
      'city_long': '0.0'
    };

    // rebuild widget with different form values
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
      //child: MediaQuery(
      //data: MediaQueryData(textScaleFactor: 0.5),
      child: MaterialApp(
          home: SingleChildScrollView(
        child: Material(
          child: SingleChildScrollView(
            child: SearchEventBottomSheet(
                formValues: _formValues, onFormAccept: _onFormAccept),
          ),
        ),
      )),
    ));

    // now form validator should return null since we provided a city value
    expect(formField.validator?.call(form), null);
  });
}

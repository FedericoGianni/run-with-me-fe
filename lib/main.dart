import 'package:flutter/material.dart';

import 'themes/custom_theme.dart';
import 'widgets/event_card_text_only.dart';
import 'dummy_data/dummy_events.dart';
import 'screens/events_result_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/user_screen.dart';
import 'screens/booked_events_screen.dart';
import 'screens/event_details_screen.dart';
import 'screens/home_screen.dart';
import '../widgets/slide.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run With Me',
      theme: CustomTheme.lightTheme,
      initialRoute: '/', // default is '/'
      routes: {
        '/': (ctx) => TabsScreen(),
        EventsScreen.routeName: (ctx) => EventsScreen(),
        AddEventScreen.routeName: (ctx) => AddEventScreen(),
        BookedEventsScreen.routeName: (ctx) => const BookedEventsScreen(),
        UserScreen.routeName: (ctx) => UserScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        EventDetailsScreen.routeName: (ctx) => const EventDetailsScreen(),
      },
      onGenerateRoute: (settings) {},
      // onUnknownRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (ctx) => CategoriesScreen(),
      //   );
      // },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/splash.dart';

import 'themes/custom_theme.dart';
import 'widgets/event_card_text_only.dart';
import 'screens/tabs_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/user_screen.dart';
import 'screens/home_screen.dart';
import 'screens/booked_events_screen.dart';
import 'screens/event_details_screen.dart';
import 'screens/search_screen.dart';
import 'widgets/custom_map_search.dart';
import 'providers/color_scheme.dart';
import 'providers/events.dart';
import 'providers/page_index.dart';
import 'providers/location_helper.dart';
import 'widgets/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool splash = true;
  var customColorScheme = CustomColorScheme();
  Widget routeWidget = const MaterialApp(
    // ignore: prefer_const_constructors
    home: SplashScreen(),
  );
  @override
  Widget build(BuildContext context) {
    var userSettings = UserSettings();
    var userInfo = User();
    var locationHelper = LocationHelper();
    userSettings.setUser(userInfo);
    userSettings.setColorScheme(customColorScheme);
    // customColorScheme.setDarkMode();

    if (splash == true) {
      userSettings.loadSettings().then((value) {
        if (value) {
          setState(() {
            splash = !value;
            // userSettings = userSettings; // No scusa in che senso ???
            routeWidget = MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: customColorScheme,
                ),
                ChangeNotifierProvider.value(
                  value: Events(),
                ),
                ChangeNotifierProvider.value(
                  value: userSettings,
                ),
                ChangeNotifierProvider.value(
                  value: PageIndex(),
                ),
                ChangeNotifierProvider.value(
                  value: userInfo,
                ),
                ChangeNotifierProvider.value(
                  value: locationHelper,
                ),
              ],
              child: MaterialApp(
                title: 'Run With Me',
                theme: CustomTheme.noTheme,
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
                onGenerateRoute: (settings) {},
                // onUnknownRoute: (settings) {
                //   return MaterialPageRoute(
                //     builder: (ctx) => CategoriesScreen(),
                //   );
                // },
              ),
            );
          });
        } else {
          print("Imma out of here");
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      });
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      child: routeWidget,
    );
    // theme: CustomTheme.lightTheme,
  }
}

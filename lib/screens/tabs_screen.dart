// ignore_for_file: unnecessary_const
///{@category Screens}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/themes/custom_colors.dart';
import '../classes/multi_device_support.dart';
import '../providers/event.dart';

// import '../widgets/main_drawer.dart';
// import './favorites_screen.dart';
import '../providers/location_helper.dart';
import '../providers/user.dart';
import 'add_event_screen.dart';
import 'user_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'booked_events_screen.dart';
import '../widgets/custom_map_search.dart';
import '../widgets/default_appbar.dart';
// import '../models/meal.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../providers/page_index.dart';

class TabsScreen extends StatefulWidget {
  @override
  TabsScreenState createState() => TabsScreenState();
}

@visibleForTesting
class TabsScreenState extends State<TabsScreen> {
  late List<Map> _pages;
  bool gotLocation = false;

  // ignore: prefer_typing_uninitialized_variables
  var _transitionStart;
  var _transitionEnd;

  @override
  void initState() {
    _pages = [
      {
        'title': 'Home',
        'page': HomeScreen(),
        'appbar': const SizedBox.shrink(),
      },
      {
        'title': 'Events',
        'page': SearchScreen(),
        'appbar': const SizedBox.shrink(),
      },
      {
        'title': 'My Events',
        'page': AddEventScreen(),
        'appbar': const AddEventAppbar(),
      },
      {
        'title': 'Booked Events',
        'page': BookedEventsScreen(),
        'appbar': const SizedBox.shrink(),
      },
      {
        'title': 'My Events',
        'page': UserScreen(),
        'appbar': const SizedBox.shrink(),
      },
    ];
    super.initState();
  }

  @visibleForTesting
  void selectPage(int index) {
    _selectPage(index);
  }

  void _selectPage(int index) {
    final pageIndex = Provider.of<PageIndex>(context, listen: false);

    setState(() {
      pageIndex.setPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);
    final pageIndex = Provider.of<PageIndex>(context);
    final user = Provider.of<User>(context, listen: false);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    locationHelper.setDefaultUserPosition(
      Position(
        longitude: user.cityLong ?? 0.0,
        latitude: user.cityLat ?? 0.0,
        timestamp: user.createdAt,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      ),
    );

    if (!gotLocation) {
      // We dont want locationHelper to look for user location everytime its rebuild, just the first one
      locationHelper.determinePosition(LocationAccuracy.best, context);
      // And we absolutely dont want to start an ever living thread each  time
      locationHelper.start().then((value) => null);
      gotLocation = true;
    }
    print("Rebuilding Tabs Screen");
    return WillPopScope(
      onWillPop: () async {
        if (pageIndex.index == 0) {
          return true;
        } else {
          _selectPage(0);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: PreferredSize(
          child: _pages[pageIndex.index]['appbar'],
          preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
        ),
        body: _pages[pageIndex.index]['page'],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: colors.onPrimary,
          unselectedItemColor: colors.secondaryTextColor,
          selectedItemColor: colors.primaryColor,
          currentIndex: pageIndex.index,
          type: BottomNavigationBarType.fixed,
          elevation: 4,
          iconSize: 20 + multiDeviceSupport.tablet * 20,
          items: [
            BottomNavigationBarItem(
              backgroundColor: colors.primaryColor,
              icon: const Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: colors.primaryColor,
              icon: const Icon(Icons.search),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              backgroundColor: colors.primaryColor,
              icon: const Icon(Icons.add_box_outlined),
              label: 'New',
            ),
            BottomNavigationBarItem(
              backgroundColor: colors.primaryColor,
              icon: const Icon(Icons.event_outlined),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              backgroundColor: colors.primaryColor,
              icon: const Icon(Icons.person_outline),
              label: 'User',
            )
          ],
        ),
      ),
    );
  }
}

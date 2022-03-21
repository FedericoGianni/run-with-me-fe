// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/themes/custom_colors.dart';
import '../providers/event.dart';

// import '../widgets/main_drawer.dart';
// import './favorites_screen.dart';
import '../providers/locationHelper.dart';
import '../providers/user.dart';
import 'events_result_screen.dart';
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
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
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
        'appbar': const DefaultAppbar(),
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
        'page': const BookedEventsScreen(),
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
      locationHelper.determinePosition(LocationAccuracy.best, context);
      gotLocation = true;
    }

    return Scaffold(
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
        elevation: 2,
        items: [
          BottomNavigationBarItem(
            backgroundColor: colors.primaryColor,
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: colors.primaryColor,
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            backgroundColor: colors.primaryColor,
            icon: Icon(Icons.add_box_outlined),
            label: 'New',
          ),
          BottomNavigationBarItem(
            backgroundColor: colors.primaryColor,
            icon: Icon(Icons.event_outlined),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            backgroundColor: colors.primaryColor,
            icon: Icon(Icons.person_outline),
            label: 'User',
          )
        ],
      ),
    );
  }
}

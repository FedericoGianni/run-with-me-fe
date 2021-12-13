// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:runwithme/themes/custom_colors.dart';
import '../providers/event.dart';

// import '../widgets/main_drawer.dart';
// import './favorites_screen.dart';
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

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map> _pages;
  int _selectedPageIndex = 0;
  int _prevSelectedPageIndex = -1;
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
        'appbar': const UserAppbar(),
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: PreferredSize(
        child: _pages[_selectedPageIndex]['appbar'],
        preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: colors.onPrimary,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: colors.primaryColor,
        currentIndex: _selectedPageIndex,
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
          ),
        ],
      ),
    );
  }
}

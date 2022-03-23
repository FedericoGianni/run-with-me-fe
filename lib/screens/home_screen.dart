import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/themes/custom_colors.dart';

import '../providers/color_scheme.dart';
import '../providers/events.dart';
import '../providers/locationHelper.dart';
import '../providers/page_index.dart';
import '../widgets/custom_loading_animation.dart';
import '../widgets/gradientAppbar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Position userPosition =
          Provider.of<LocationHelper>(context).getLastKnownPosition();

      Provider.of<Events>(context)
          .fetchAndSetSuggestedEvents(
              userPosition.latitude,
              userPosition.longitude,
              5,
              //Provider.of<UserSettings>(context, listen: false).isLoggedIn())
              false)
          .then((_) {
        setState(() {
          _isLoading = false;
          print("fetching events for home_screen");
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<Null> _handleRefresh() async {
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CustomLoadingAnimation();
    } else {
      return Center(child: Text("Welcome Back"));
    }
  }
}

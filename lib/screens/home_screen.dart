import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/themes/custom_colors.dart';

import '../providers/color_scheme.dart';
import '../providers/events.dart';
import '../providers/locationHelper.dart';
import '../providers/page_index.dart';
import '../providers/settings_manager.dart';
import '../providers/user.dart';
import '../widgets/custom_loading_animation.dart';
import '../widgets/custom_scroll_behavior.dart';
import '../widgets/gradientAppbar.dart';
import '../widgets/user_info_card.dart';

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
    final colors = Provider.of<CustomColorScheme>(context);
    final user = Provider.of<User>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return const CustomLoadingAnimation();
    } else {
      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: colors.background,
                height: screenHeight - 56,
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: CustomScrollView(
                    // This is needed to avoid overflow
                    shrinkWrap: true,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            bottom: 0, top: 40, left: 20, right: 20),
                        sliver: SliverToBoxAdapter(
                            child: Text(
                          'User info',
                          style: TextStyle(
                              color: colors.primaryTextColor, fontSize: 22),
                        )),
                      ),
                      // Actual list of cards with user infos
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            bottom: 0, top: 20, left: 20, right: 20),
                        sliver: SliverToBoxAdapter(child: UserInfo(user)),
                      ),
                      // Grey line
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            bottom: 0, top: 40, left: 50, right: 50),
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: colors.onPrimary,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

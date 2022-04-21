///{@category Screens}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runwithme/providers/location_helper.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/widgets/custom_loading_animation.dart';
import 'package:runwithme/widgets/custom_scroll_behavior.dart';
import 'package:runwithme/widgets/sort_by.dart';
import 'package:runwithme/widgets/splash.dart';

import '../classes/multi_device_support.dart';
import '../providers/events.dart';
import '../providers/settings_manager.dart';
import '../providers/user.dart';
import '../widgets/event_card_text_only.dart';
import '../widgets/gradient_appbar.dart';
// import '../themes/custom_colors.dart';
import '../widgets/custom_map_search.dart';
import '../widgets/search_event_bottomsheet.dart';
import '../widgets/search_button.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_sort_by_button.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  bool _sortMenu = false;
  SortButton _currentSortButton = SortButton.none;
  Map<String, dynamic> formValues = {
    'show_full': false,
    'slider_value': 0.0,
    'city_name': '',
    'city_lat': 0.0,
    'city_long': 0.0
  };

  List<Event> _suggestedEvents = [];
  List<Event> _recentEvents = [];
  List<Event> _resultEvents = [];

  // @visibleForTesting
  // List<Event> get suggestedEvents {
  //   return _suggestedEvents;
  // }

  // @visibleForTesting
  // List<Event> get recentEvents {
  //   return _recentEvents;
  // }

  // @visibleForTesting
  // List<Event> get resultEvents {
  //   return _resultEvents;
  // }

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

@visibleForTesting
class SearchScreenState extends State<SearchScreen> {
  int _view = 2;
  double _aspectRatio = 1.4;
  Color _rowColor = Colors.deepOrange.shade900;
  Color _gridColor = Colors.deepOrange.shade900;
  Color _mapColor = Colors.deepOrange.shade900;

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
              Provider.of<UserSettings>(context, listen: false).isLoggedIn())
          .then((_) {
        setState(() {
          _isLoading = false;
          print("fetching events for search_screen");
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<Null> _handleRefresh() async {
    widget._sortMenu = false;
    widget._currentSortButton = SortButton.none;

    final events = Provider.of<Events>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    // the if check is to avoid when a refresh of the screen is made but there are no previous parameters of fetchAndSetResultEvents available
    // for suggestedEvents is not a problem since there will always be an automatic request when building the first time

    if (events.lastResultMaxDistKm == -1 ||
        events.lastResultLat == -1 ||
        events.lastResultLong == -1) {
      events.fetchAndSetResultEvents(
          events.lastResultLat,
          events.lastResultLong,
          events.lastResultMaxDistKm,
          Provider.of<UserSettings>(context, listen: false).isLoggedIn());
      widget._resultEvents = events.resultEvents;
    }

    events.fetchAndSetSuggestedEvents(
        events.lastSuggestedLat,
        events.lastSuggestedLong,
        events.lastSuggestedMaxDistKm,
        Provider.of<UserSettings>(context, listen: false).isLoggedIn());
    widget._suggestedEvents = events.suggestedEvents
        .where((element) =>
            (element.difficultyLevel < user.fitnessLevel! + 1) &&
            (element.difficultyLevel > user.fitnessLevel! - 1))
        .toList();

    setState(() {});
    return null;
  }

  void __selectListView(colors) {
    setState(() {
      _view = 1;
      _aspectRatio = 3;
      _rowColor = colors.primaryColor;
      _gridColor = colors.secondaryTextColor;
      _mapColor = colors.secondaryTextColor;
    });
  }

  void __selectGridView(colors) {
    setState(() {
      _view = 2;
      _aspectRatio = 1.4;
      _gridColor = colors.primaryColor;
      _rowColor = colors.secondaryTextColor;
      _mapColor = colors.secondaryTextColor;
    });
  }

  void __selectMapView(colors) {
    setState(() {
      _view = 3;
      _gridColor = colors.secondaryTextColor;
      _rowColor = colors.secondaryTextColor;
      _mapColor = colors.primaryColor;
    });
  }

  List<Widget> _buildContent(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    print("Rebuilding content");
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    // suggested events taken from Events provider, re-fetch the suggested events every time there is an update in the widget tree

    //print("suggestedEvents: " + _suggestedEvents.toString());
    //print("Search_Screen printing suggestedEvents ID...");

    if (_rowColor == Colors.deepOrange.shade900) {
      __selectGridView(colors);
    }

    return [
      if (widget._resultEvents.length > 0)
        SliverPadding(
          padding: EdgeInsets.only(
              bottom: 0,
              top: 20,
              left: 20 + multiDeviceSupport.tablet * 30,
              right: 20 + multiDeviceSupport.tablet * 30),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Results",
                  style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: multiDeviceSupport.h0,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ),
      if (widget._resultEvents.length > 0)
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: 40,
            top: 20,
            left: 20 + multiDeviceSupport.tablet * 30,
            right: 20 + multiDeviceSupport.tablet * 30,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: _aspectRatio,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              maxCrossAxisExtent:
                  (400 + multiDeviceSupport.tablet * 80) / _view,
              mainAxisExtent: 115 + multiDeviceSupport.tablet * 35,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (widget._resultEvents.length > index) {
                  return EventItem(
                    widget._resultEvents[index],
                    index,
                    widget._resultEvents.length,
                    _view,
                  );
                }
              },
              childCount: widget._resultEvents.length,
            ),
          ),
        ),
      SliverPadding(
        padding: EdgeInsets.only(
          bottom: 0,
          top: 20,
          left: 20 + multiDeviceSupport.tablet * 30,
          right: 20 + multiDeviceSupport.tablet * 30,
        ),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Suggested",
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h0,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.only(
          bottom: 40,
          top: 20,
          left: 20 + multiDeviceSupport.tablet * 30,
          right: 20 + multiDeviceSupport.tablet * 30,
        ),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: _aspectRatio,
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 15.0,
            maxCrossAxisExtent: (400 + multiDeviceSupport.tablet * 80) / _view,
            mainAxisExtent: 115 + multiDeviceSupport.tablet * 35,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return EventItem(
                widget._suggestedEvents[index],
                index,
                widget._suggestedEvents.length,
                _view,
              );
            },
            childCount: widget._suggestedEvents.length,
          ),
        ),
      ),
      // Next, create a SliverList
      SliverPadding(
        padding: EdgeInsets.only(
          bottom: 20,
          top: 20,
          left: 20 + multiDeviceSupport.tablet * 30,
          right: 20 + multiDeviceSupport.tablet * 30,
        ),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recently viewed",
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h0,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.only(bottom: 15),

          // margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
          height:
              ((380.0 + multiDeviceSupport.tablet * 80) / _view) / _aspectRatio,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            //itemCount: 10,
            itemCount: widget._recentEvents.length,
            itemBuilder: (context, index) {
              double startingMargin = 0.0;
              double endingMargin = 0.0;
              if (index == 0) {
                startingMargin = 10 + multiDeviceSupport.tablet * 30;
              } else {
                startingMargin = 0.0;
              }
              if (index == widget._recentEvents.length - 1) {
                endingMargin = 10 + multiDeviceSupport.tablet * 30;
              } else {
                endingMargin = 0.0;
              }

              return Container(
                margin: EdgeInsets.only(
                  left: startingMargin,
                  right: endingMargin,
                ),
                padding: EdgeInsets.only(left: 10, bottom: 5, right: 7),
                width: (370 + multiDeviceSupport.tablet * 110) / _view,
                child: EventItem(
                  widget._recentEvents[index],
                  index,
                  widget._recentEvents.length,
                  _view,
                ),
              );
            },
          ),
        ),
      ),
    ];
  }

  Widget _buildAppbar(BuildContext context) {
    final events = Provider.of<Events>(context);
    final colors = Provider.of<CustomColorScheme>(context);
    // final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double _flexibleSpaceBarHeight;
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    if (_rowColor == Colors.deepOrange.shade900) {
      __selectGridView(colors);
    }

    if (widget._sortMenu) {
      _flexibleSpaceBarHeight = screenHeight / 7.5;
    } else {
      _flexibleSpaceBarHeight = screenHeight / 20;
    }

    return SliverAppBar(
      stretch: false,
      toolbarHeight: screenHeight / 6 - multiDeviceSupport.tablet * 30,

      title: GradientAppBar(
        screenHeight / 6 - multiDeviceSupport.tablet * 30,
        [
          SizedBox(
            height: 10 + multiDeviceSupport.tablet * 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SearchButton(
                Icon(
                  Icons.search,
                  color: colors.secondaryTextColor,
                ),
                Text(
                  '    Search',
                  style: TextStyle(color: colors.secondaryTextColor),
                ),
                formValues: widget.formValues,
                onSubmitting: (value) async {
                  // print('SEARCH SCREEN: ' + value.toString());
                  widget.formValues = value;

                  await events.fetchAndSetResultEvents(
                      widget.formValues['city_lat'],
                      widget.formValues['city_long'],
                      widget.formValues['slider_value'].toInt() + 1 * 5,
                      Provider.of<UserSettings>(context, listen: false)
                          .isLoggedIn());
                  widget._resultEvents = events.resultEvents;

                  if (!widget.formValues['show_full']) {
                    widget._resultEvents = widget._resultEvents
                        .where((element) =>
                            element.maxParticipants !=
                            element.currentParticipants)
                        .toList();
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ],
          )
        ],
      ),

      titleSpacing: 0,
      expandedHeight: screenHeight / 6 -
          multiDeviceSupport.tablet * 30 +
          _flexibleSpaceBarHeight,
      backgroundColor: colors.background,

      // back up the list of items.
      floating: true,
      // Display a placeholder widget to visualize the shrinking size.
      pinned: true,
      snap: false,
      elevation: 4,
      flexibleSpace: FlexibleSpaceBar.createSettings(
        currentExtent: 100,
        child: FlexibleSpaceBar(
          title: Container(
            height: _flexibleSpaceBarHeight,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      height: screenHeight / 20,
                      width: 100 + multiDeviceSupport.tablet * 60,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: colors.background,
                            primary: colors.onPrimary,
                            textStyle:
                                TextStyle(fontSize: multiDeviceSupport.h5),
                            padding: const EdgeInsets.all(0)),
                        onPressed: () {
                          if (_view != 3) {
                            setState(() {
                              widget._sortMenu = !widget._sortMenu;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'Sort by',
                              style: widget._sortMenu
                                  ? TextStyle(
                                      color: colors.secondaryColor,
                                      fontSize: multiDeviceSupport.h2)
                                  : TextStyle(
                                      color: colors.secondaryTextColor,
                                      fontSize: multiDeviceSupport.h2),
                            ),
                            Icon(
                              widget._sortMenu
                                  ? Icons.keyboard_arrow_right_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: widget._sortMenu
                                  ? colors.secondaryColor
                                  : colors.secondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      widget._resultEvents.length.toString() + " results",
                      style: TextStyle(
                          color: colors.secondaryTextColor,
                          fontSize: multiDeviceSupport.h3),
                    ),
                    Container(
                      width: 100 + multiDeviceSupport.tablet * 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.map_outlined,
                              size: multiDeviceSupport.icons,
                            ),
                            color: _mapColor,
                            onPressed: () {
                              __selectMapView(colors);
                            },
                            padding: EdgeInsets.only(
                                right: multiDeviceSupport.tablet * 20),
                            constraints: const BoxConstraints(),
                            splashRadius: 10,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.table_rows_outlined,
                              size: multiDeviceSupport.icons,
                            ),
                            color: _rowColor,
                            onPressed: () {
                              __selectListView(colors);
                            },
                            padding: EdgeInsets.only(
                                right: multiDeviceSupport.tablet * 20),
                            constraints: const BoxConstraints(),
                            splashRadius: 10,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.grid_view_outlined,
                              size: multiDeviceSupport.icons,
                            ),
                            color: _gridColor,
                            onPressed: () {
                              __selectGridView(colors);
                            },
                            padding: EdgeInsets.only(
                                right: multiDeviceSupport.tablet * 30),
                            constraints: const BoxConstraints(),
                            splashRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                widget._sortMenu
                    ? SortByRow(
                        currentSortButton: widget._currentSortButton,
                        eventLists: [
                          widget._resultEvents,
                          widget._suggestedEvents
                        ],
                        onTap: (activeSortButton, eventLists) {
                          setState(() {
                            print(widget._suggestedEvents[0].name);
                            widget._currentSortButton = activeSortButton;
                            widget._resultEvents = eventLists[0];
                            widget._suggestedEvents = eventLists[1];
                          });
                          print(widget._currentSortButton.toString());
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ),
          titlePadding: const EdgeInsets.only(left: 5, right: 5),
        ),
      ),
      // Make the initial height of the SliverAppBar larger than normal.
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding Page");
    final colors = Provider.of<CustomColorScheme>(context);
    final events = Provider.of<Events>(context);
    final user = Provider.of<User>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    double _flexibleSpaceBarHeight;
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    if (widget._sortMenu) {
      _flexibleSpaceBarHeight = screenHeight / 7.5;
    } else {
      _flexibleSpaceBarHeight = screenHeight / 20;
    }

    if (_isLoading) {
      return const CustomLoadingAnimation();
    } else {
      // This if statement is used to avoid reloading resultEvents on setState when sorting events
      // So basically here events are fetched only the first time.. in the future events will be fetched at reload
      if (widget._suggestedEvents.length == 0) {
        widget._resultEvents = events.resultEvents;
        widget._suggestedEvents = events.suggestedEvents
            .where((element) =>
                (element.difficultyLevel < user.fitnessLevel! + 1) &&
                (element.difficultyLevel > user.fitnessLevel! - 1))
            .toList();
        print("Got events from provider");
      }
      widget._recentEvents = events.recentEvents;

      if (_view == 3) {
        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: screenHeight / 6 +
                    _flexibleSpaceBarHeight -
                    multiDeviceSupport.tablet * 12,
                child: CustomScrollView(
                  slivers: [
                    _buildAppbar(
                      context,
                      //_newEventList.length,
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: CustomMapsSearch(),
                width: double.infinity,
                height: screenHeight -
                    screenHeight / 6 -
                    _flexibleSpaceBarHeight -
                    58,
              ),
            ],
          ),
        );
      } else {
        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: CustomScrollView(
              slivers: [_buildAppbar(context), ..._buildContent(context)],
            ),
          ),
        );
      }
    }
  }
}

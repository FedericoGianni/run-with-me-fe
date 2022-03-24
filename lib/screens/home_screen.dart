import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/widgets/custom_loading_animation.dart';
import 'package:runwithme/widgets/custom_map_home_page.dart';
import 'package:runwithme/widgets/permissions_message.dart';
import 'package:runwithme/widgets/splash.dart';

import '../providers/events.dart';
import '../providers/locationHelper.dart';
import '../providers/page_index.dart';
import '../providers/user.dart';
import '../widgets/custom_maps_event_detail.dart';
import '../widgets/custom_scroll_behavior.dart';
import '../widgets/event_card_text_only.dart';
import '../widgets/gradientAppbar.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_sort_by_button.dart';
import '../widgets/sort_by.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/event';

  bool _sortMenu = false;
  SortButton _currentSortButton = SortButton.none;
  List<Event> _bookedEvents = [];
  List<Event> _futureBookedEvents = [];
  List<Event> _pastBookedEvents = [];
  //List<Event> _suggestedEvents = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _view = 2;
  double _aspectRatio = 1.4;
  Color _rowColor = Colors.deepOrange.shade900;
  Color _gridColor = Colors.deepOrange.shade900;
  var _isInit = true;
  var _isLoading = false;
  static const int MAX_LENGTH = 2;

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

      // 1. fetch suggested events

      // Position userPosition =
      //     Provider.of<LocationHelper>(context).getLastKnownPosition();
      // Provider.of<Events>(context).fetchAndSetSuggestedEvents(
      //     userPosition.latitude,
      //     userPosition.longitude,
      //     5,
      //     Provider.of<UserSettings>(context, listen: false).isLoggedIn());

      // 2. fetch booked events and divide past/future events

      int userId = Provider.of<User>(context).userId ?? -1;
      Provider.of<Events>(context).fetchAndSetBookedEvents(userId).then((_) {
        setState(() {
          _isLoading = false;
          print("fetching events for home");
          _buildPage();
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void __selectListView(colors) {
    setState(() {
      _view = 1;
      _aspectRatio = 3;
      _rowColor = colors.primaryColor;
      _gridColor = colors.secondaryTextColor;
    });
  }

  void __selectGridView(colors) {
    setState(() {
      _view = 2;
      _aspectRatio = 1.4;
      _gridColor = colors.primaryColor;
      _rowColor = colors.secondaryTextColor;
    });
  }

  List<Event> _sortAndReduce(List<Event> events, int max) {
    events.sort((a, b) => a.date.compareTo(b.date));
    if (events.length >= max) {
      events = events.sublist(0, max);
    }
    return events;
  }

  Future<Null> _handleRefresh() async {
    widget._sortMenu = false;
    widget._currentSortButton = SortButton.none;

    // 1. update booked events
    final user = Provider.of<User>(context, listen: false);
    int userId = user.userId ?? -1;
    final events = Provider.of<Events>(context, listen: false);
    events.fetchAndSetBookedEvents(userId);
    widget._bookedEvents = events.bookedEvents;
    widget._futureBookedEvents = widget._bookedEvents
        .where((element) => element.date.isAfter(DateTime.now()))
        .toList();

    widget._futureBookedEvents =
        _sortAndReduce(widget._futureBookedEvents, MAX_LENGTH);

    widget._pastBookedEvents = widget._bookedEvents
        .where((element) => element.date.isBefore(DateTime.now()))
        .toList();

    widget._pastBookedEvents =
        _sortAndReduce(widget._pastBookedEvents, MAX_LENGTH);

    // 2. update suggested events

    // events.fetchAndSetSuggestedEvents(
    //     events.lastSuggestedLat,
    //     events.lastSuggestedLong,
    //     events.lastSuggestedMaxDistKm,
    //     Provider.of<UserSettings>(context, listen: false).isLoggedIn());
    // widget._suggestedEvents = events.suggestedEvents
    //     .where((element) =>
    //         (element.difficultyLevel < user.fitnessLevel! + 1) &&
    //         (element.difficultyLevel > user.fitnessLevel! - 1))
    //     .toList();

    // widget._suggestedEvents =
    //     _sortAndReduce(widget._suggestedEvents, MAX_LENGTH);

    setState(() {});
    return null;
  }

  List<Widget> _buildPage() {
    final colors = Provider.of<CustomColorScheme>(context);
    final user = Provider.of<User>(context, listen: false);
    final pageIndex = Provider.of<PageIndex>(context, listen: false);

    return [
      SliverPadding(
        padding:
            const EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Welcome back, " + user.name.toString(),
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
      // Grey line
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 20, top: 0, left: 50, right: 50),
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
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 10, top: 0, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "Search for an event nearby",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  ),
                  color: _gridColor,
                  onPressed: () {
                    pageIndex.setPage(Screens.SEARCH.index);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding:
            const EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "You are here",
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    size: 30,
                  ),
                  color: _gridColor,
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding:
            const EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Card(
            color: colors.onPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 4,
            margin: const EdgeInsets.all(0),
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 3,
              child: CustomMapsHome(),
            ),
          ),
        ),
      ),
      // Grey line
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 0, top: 0, left: 50, right: 50),
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
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your upcoming events",
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding:
            const EdgeInsets.only(bottom: 40, top: 20, left: 20, right: 20),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: _aspectRatio,
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 15.0,
            maxCrossAxisExtent: 400 / _view,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return EventItem(
                widget._futureBookedEvents[index],
                index,
                widget._futureBookedEvents.length,
              );
            },
            childCount: widget._futureBookedEvents.length,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 30, top: 0, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "See all booked events",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: IconButton(
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 30,
                  ),
                  color: _gridColor,
                  onPressed: () {
                    pageIndex.setPage(Screens.EVENTS.index);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      // Grey line
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 0, top: 0, left: 50, right: 50),
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
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your past events",
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding:
            const EdgeInsets.only(bottom: 40, top: 20, left: 20, right: 20),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: _aspectRatio,
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 15.0,
            maxCrossAxisExtent: 400 / _view,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return EventItem(
                widget._pastBookedEvents[index],
                index,
                widget._pastBookedEvents.length,
              );
            },
            childCount: widget._pastBookedEvents.length,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 30, top: 0, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "See all past events",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: IconButton(
                  icon: const Icon(
                    Icons.auto_graph,
                    size: 30,
                  ),
                  color: _gridColor,
                  onPressed: () {
                    pageIndex.setPage(Screens.EVENTS.index);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context, listen: false);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final events = Provider.of<Events>(context);

    if (widget._bookedEvents.length == 0) {
      widget._bookedEvents = events.bookedEvents;

      widget._futureBookedEvents = widget._bookedEvents
          .where((element) => element.date.isAfter(DateTime.now()))
          .toList();

      widget._futureBookedEvents =
          _sortAndReduce(widget._futureBookedEvents, MAX_LENGTH);

      widget._pastBookedEvents = widget._bookedEvents
          .where((element) => element.date.isBefore(DateTime.now()))
          .toList();

      widget._pastBookedEvents =
          _sortAndReduce(widget._pastBookedEvents, MAX_LENGTH);
    }

    double _flexibleSpaceBarHeight;

    if (widget._sortMenu) {
      _flexibleSpaceBarHeight = screenHeight / 7.5;
    } else {
      _flexibleSpaceBarHeight = screenHeight / 20;
    }

    if (_rowColor == Colors.deepOrange.shade900) {
      __selectGridView(colors);
    }

    if (_isLoading) {
      return const CustomLoadingAnimation();
    } else {
      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                stretch: false,
                toolbarHeight: screenHeight / 6,
                title: Container(
                  color: colors.onPrimary,
                  height: screenHeight / 6,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 50,
                    bottom: 20,
                  ),
                  child: Image.asset(
                    "assets/icons/logo_gradient.png",
                    width: 130,
                  ),
                ),

                titleSpacing: 0,
                expandedHeight: screenHeight / 6 + _flexibleSpaceBarHeight,
                backgroundColor: colors.background,

                // back up the list of items.
                floating: true,
                // Display a placeholder widget to visualize the shrinking size.
                pinned: true,
                snap: false,
                elevation: 4,
                flexibleSpace: FlexibleSpaceBar.createSettings(
                  currentExtent: 100,
                  child: settings.isLoggedIn()
                      ? FlexibleSpaceBar(
                          title: Container(
                            height: _flexibleSpaceBarHeight,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      height: screenHeight / 20,
                                      width: 80,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: colors.background,
                                            primary: colors.onPrimary,
                                            textStyle:
                                                const TextStyle(fontSize: 10),
                                            padding: const EdgeInsets.all(0)),
                                        onPressed: () {
                                          setState(() {
                                            widget._sortMenu =
                                                !widget._sortMenu;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Sort by',
                                              style: widget._sortMenu
                                                  ? TextStyle(
                                                      color:
                                                          colors.secondaryColor,
                                                      fontSize: 16)
                                                  : TextStyle(
                                                      color: colors
                                                          .secondaryTextColor,
                                                      fontSize: 16),
                                            ),
                                            Icon(
                                              widget._sortMenu
                                                  ? Icons
                                                      .keyboard_arrow_right_rounded
                                                  : Icons
                                                      .keyboard_arrow_down_rounded,
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
                                      widget._futureBookedEvents.length
                                              .toString() +
                                          " results",
                                      style: TextStyle(
                                          color: colors.secondaryTextColor,
                                          fontSize: 14),
                                    ),
                                    Container(
                                      width: 75,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.table_rows_outlined,
                                              size: 30,
                                            ),
                                            color: _rowColor,
                                            onPressed: () {
                                              __selectListView(colors);
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            splashRadius: 10,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.grid_view_outlined,
                                              size: 30,
                                            ),
                                            color: _gridColor,
                                            onPressed: () {
                                              __selectGridView(colors);
                                            },
                                            padding: EdgeInsets.zero,
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
                                        currentSortButton:
                                            widget._currentSortButton,
                                        eventLists: [
                                          widget._futureBookedEvents,
                                          widget._pastBookedEvents
                                        ],
                                        onTap: (activeSortButton, eventLists) {
                                          setState(() {
                                            // print(widget._suggestedEvents[0].name);
                                            widget._currentSortButton =
                                                activeSortButton;
                                            widget._futureBookedEvents =
                                                eventLists[0];
                                            widget._pastBookedEvents =
                                                eventLists[1];
                                          });
                                          // print(widget._currentSortButton.toString());
                                        },
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),

                          titlePadding:
                              const EdgeInsets.only(left: 5, right: 5),

                          // Make the initial height of the SliverAppBar larger than normal.
                        )
                      : const SizedBox(),
                ),
              ),
              if (settings.isLoggedIn())
                ..._buildPage()
              else
                SliverPadding(
                  padding:
                      EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      height: screenHeight / 1.3,
                      width: screenWidth,
                      child: PermissionMessage(),
                    ),
                    // Next, create a SliverList
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }
}

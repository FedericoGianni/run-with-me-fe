import 'package:flutter/material.dart';
import 'package:runwithme/classes/date_helper.dart';
import 'package:runwithme/classes/stats_helper.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/widgets/custom_loading_animation.dart';
import 'package:runwithme/widgets/custom_map_home_page.dart';
import 'package:runwithme/widgets/custom_weather.dart';

import '../classes/multi_device_support.dart';
import '../providers/events.dart';
import '../providers/locationHelper.dart';
import '../providers/page_index.dart';
import '../providers/user.dart';
import '../widgets/custom_scroll_behavior.dart';
import '../widgets/event_card_text_only.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/event';
  //bool _hideWeather = false;
  //bool _hideMap = false;

  List<Event> _bookedEvents = [];
  List<Event> _futureBookedEvents = [];
  List<Event> _pastBookedEvents = [];

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
    if (events.isNotEmpty) {
      events.sort((a, b) => a.date.compareTo(b.date));
      if (events.length >= max) {
        events = events.sublist(0, max);
      }
    }
    return events;
  }

  Future<void> _handleRefresh() async {
    // 1. update booked events
    final user = Provider.of<User>(context, listen: false);
    int userId = user.userId ?? -1;
    final events = Provider.of<Events>(context, listen: false);

    // 1.1 fetch booked events for user
    events.fetchAndSetBookedEvents(userId);
    widget._bookedEvents = events.bookedEvents;

    // 1.2 separate future booked events and reduce list length
    widget._futureBookedEvents = widget._bookedEvents
        .where((element) => element.date.isAfter(DateTime.now()))
        .toList();
    widget._futureBookedEvents =
        _sortAndReduce(widget._futureBookedEvents, MAX_LENGTH);

    // 1.3 separate past booked events and reduce list length
    widget._pastBookedEvents = widget._bookedEvents
        .where((element) => element.date.isBefore(DateTime.now()))
        .toList();
    widget._pastBookedEvents =
        _sortAndReduce(widget._pastBookedEvents, MAX_LENGTH);

    // DEPRECATED should we display suggested events in homepage?
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
  }

  List<Widget> _buildPage() {
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    final pageIndex = Provider.of<PageIndex>(context, listen: false);
    final settings = Provider.of<UserSettings>(context, listen: false);
    LocationHelper locationHelper =
        Provider.of<LocationHelper>(context, listen: false);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    // WEEKLY STATS
    // they will be rebuilt automatically on changes because of booked events listening for changes
    StatsHelper statsHelper = StatsHelper(context);

    int weeklyDistance = statsHelper.calcWeeklyKms();
    int weeklyDuration = statsHelper.calcWeeklyMins();
    List<int> weeklyAvgPace =
        statsHelper.calcWeeklyAvgPaceParams(weeklyDistance, weeklyDuration);
    int weeklyAvgPaceMin = 0;
    int weeklyAvgPaceSec = 0;
    if (weeklyAvgPace.isNotEmpty) {
      weeklyAvgPaceMin = weeklyAvgPace[0];
      weeklyAvgPaceSec = weeklyAvgPace[1];
    }

    return [
      // DATE
      SliverPadding(
        padding: EdgeInsets.only(
            bottom: 0,
            top: 10,
            left: 20 + multiDeviceSupport.tablet * 30,
            right: 20 + multiDeviceSupport.tablet * 30),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateHelper.formatDateTime(DateTime.now()),
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h1,
                    fontWeight: FontWeight.w900),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Icon(
                Icons.calendar_month,
                color: colors.secondaryTextColor,
                size: multiDeviceSupport.icons,
              ),
            ],
          ),
        ),
      ),

      // WELCOME PHRASE
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                bottom: 20,
                top: 10,
                left: 20 + multiDeviceSupport.tablet * 30,
                right: 20 + multiDeviceSupport.tablet * 30,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome back, " + user.name.toString(),
                      key: const Key("welcome_logged"),
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h0,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 10,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome",
                      key: const Key("welcome_not_logged"),
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h1,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
      // Grey line
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20 + multiDeviceSupport.tablet * 10,
                  top: 0 + multiDeviceSupport.tablet * 10,
                  left: 50 + multiDeviceSupport.tablet * 30,
                  right: 50 + multiDeviceSupport.tablet * 30),
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
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
            ),

      // UPCOMING EVENTS
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 0 + multiDeviceSupport.tablet * 10,
                  top: 0,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your upcoming events ",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h0,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      settings.isLoggedIn()
          ? SliverPadding(
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
                    return EventItem(
                      widget._futureBookedEvents[index],
                      index,
                      widget._futureBookedEvents.length,
                      _view,
                    );
                  },
                  childCount: widget._futureBookedEvents.length,
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),

      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                bottom: 30,
                top: 0,
                left: 20 + multiDeviceSupport.tablet * 30,
                right: 0 + multiDeviceSupport.tablet * 30,
              ),
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
                            fontSize: multiDeviceSupport.h1,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: IconButton(
                        icon: Icon(
                          Icons.calendar_view_month,
                          size: multiDeviceSupport.icons,
                        ),
                        color: colors.primaryColor,
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
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      // Grey line
      SliverPadding(
        padding: EdgeInsets.only(
            bottom: 0,
            top: 0,
            left: 50 + multiDeviceSupport.tablet * 30,
            right: 50 + multiDeviceSupport.tablet * 30),
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

      // WEATHER
      locationHelper.isInitialized()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 20 + multiDeviceSupport.tablet * 10,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weather",
                          style: TextStyle(
                              color: colors.primaryTextColor,
                              fontSize: multiDeviceSupport.h0,
                              fontWeight: FontWeight.w900),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        WeatherWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Enable GPS to view Weather forecasts",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: colors.primaryTextColor,
                            fontSize: multiDeviceSupport.h1,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      // Grey line
      SliverPadding(
        padding: EdgeInsets.only(
            bottom: 20 + multiDeviceSupport.tablet * 10,
            top: 0 + multiDeviceSupport.tablet * 10,
            left: 50 + multiDeviceSupport.tablet * 30,
            right: 50 + multiDeviceSupport.tablet * 30),
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

      // EVENT SEARCH
      locationHelper.isInitialized()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 10 + multiDeviceSupport.tablet * 10,
                  top: 0,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
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
                            fontSize: multiDeviceSupport.h0,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: multiDeviceSupport.icons,
                        ),
                        color: colors.primaryColor,
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
            )
          : SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Enable GPS to view your current location",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: colors.primaryTextColor,
                            fontSize: multiDeviceSupport.h1,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      // MAP WITH CURRENT POS
      locationHelper.isInitialized()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Card(
                  color: colors.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 4,
                  margin: const EdgeInsets.all(0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 4,
                    child: CustomMapsHome(),
                  ),
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),

      SliverPadding(
        padding: EdgeInsets.only(
            bottom: 20,
            top: 10,
            left: 20 + multiDeviceSupport.tablet * 30,
            right: 20 + multiDeviceSupport.tablet * 30),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "You are here",
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h1,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: IconButton(
                  icon: Icon(
                    Icons.location_on,
                    size: multiDeviceSupport.icons,
                  ),
                  color: colors.secondaryTextColor,
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
      // Grey line
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 0 + multiDeviceSupport.tablet * 10,
                  top: 0 + multiDeviceSupport.tablet * 10,
                  left: 50 + multiDeviceSupport.tablet * 30,
                  right: 50 + multiDeviceSupport.tablet * 30),
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
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      // WEEKLY STATS
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 10,
                  top: 20,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Weekly Stats: ",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h0,
                          fontWeight: FontWeight.w900),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.auto_graph,
                        size: multiDeviceSupport.icons,
                      ),
                      color: colors.secondaryTextColor,
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 10,
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 0,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last 7 days",
                      style: TextStyle(
                          color: colors.secondaryTextColor,
                          fontSize: multiDeviceSupport.h4,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 0,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "You ran: ",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h2,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      weeklyDistance.toString() + " kms",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h2,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 0,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time running: ",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h2,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      weeklyDuration.toString() + " mins",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h2,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
            ),
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 20,
                  top: 0,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Avg pace: ",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h2,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      weeklyAvgPaceMin.toString() +
                          ":" +
                          weeklyAvgPaceSec.toString() +
                          " min/km",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h2,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      // Grey line
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 0 + multiDeviceSupport.tablet * 10,
                  top: 0 + multiDeviceSupport.tablet * 10,
                  left: 50 + multiDeviceSupport.tablet * 30,
                  right: 50 + multiDeviceSupport.tablet * 30),
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
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      // PAST EVENTS
      settings.isLoggedIn()
          ? SliverPadding(
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
                      "Your past events",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h0,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      settings.isLoggedIn()
          ? SliverPadding(
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
                    return EventItem(
                      widget._pastBookedEvents[index],
                      index,
                      widget._pastBookedEvents.length,
                      _view,
                    );
                  },
                  childCount: widget._pastBookedEvents.length,
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
                ),
              ),
            ),
      settings.isLoggedIn()
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 30 + multiDeviceSupport.tablet * 10,
                  top: 0,
                  left: 20 + multiDeviceSupport.tablet * 30,
                  right: 20 + multiDeviceSupport.tablet * 30),
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
                            fontSize: multiDeviceSupport.h1,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: IconButton(
                        icon: Icon(
                          Icons.book_rounded,
                          size: multiDeviceSupport.icons,
                        ),
                        color: colors.primaryColor,
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
            )
          : SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [],
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
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    if (widget._bookedEvents.isEmpty) {
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

    _flexibleSpaceBarHeight = screenHeight / 20;

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
                toolbarHeight:
                    screenHeight / 6 - multiDeviceSupport.tablet * 30,
                title: Container(
                  color: colors.onPrimary,
                  height: screenHeight / 6,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 50 + multiDeviceSupport.tablet * 10,
                    bottom: 20 + multiDeviceSupport.tablet * 20,
                  ),
                  child: Image.asset(
                    "assets/icons/logo_gradient.png",
                    width: 130,
                  ),
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
                  child: settings.isLoggedIn()
                      ? FlexibleSpaceBar(
                          title: Container(
                            height: _flexibleSpaceBarHeight + 2,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: SizedBox(
                                        width:
                                            70 + multiDeviceSupport.tablet * 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.table_rows_outlined,
                                                size: multiDeviceSupport.icons,
                                              ),
                                              color: _rowColor,
                                              onPressed: () {
                                                __selectListView(colors);
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
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
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              splashRadius: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
              ..._buildPage()
            ],
          ),
        ),
      );
    }
  }
}

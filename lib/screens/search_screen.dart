import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/widgets/custom_loading_animation.dart';
import 'package:runwithme/widgets/custom_scroll_behavior.dart';
import 'package:runwithme/widgets/splash.dart';

import '../providers/events.dart';
import '../providers/user.dart';
import '../widgets/event_card_text_only.dart';
import '../widgets/gradientAppbar.dart';
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
  int _currentSortButton = -1;
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
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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

      Provider.of<Events>(context)
          .fetchAndSetSuggestedEvents(46, 10, 100)
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

  void _sortEvents(String sortBy) {
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);

    if (sortBy == 'distance') {
      Position userPosition = locationHelper.getLastKnownPosition();

      widget._resultEvents.sort(
        (a, b) => LocationHelper()
            .getDistanceBetween(
              startLatitude: userPosition.latitude,
              startLongitude: userPosition.longitude,
              endLatitude: a.startingPintLat,
              endLongitude: a.startingPintLong,
            )
            .compareTo(
              LocationHelper().getDistanceBetween(
                startLatitude: userPosition.latitude,
                startLongitude: userPosition.longitude,
                endLatitude: b.startingPintLat,
                endLongitude: b.startingPintLong,
              ),
            ),
      );
      widget._suggestedEvents.sort(
        (a, b) => LocationHelper()
            .getDistanceBetween(
              startLatitude: userPosition.latitude,
              startLongitude: userPosition.longitude,
              endLatitude: a.startingPintLat,
              endLongitude: a.startingPintLong,
            )
            .compareTo(
              LocationHelper().getDistanceBetween(
                startLatitude: userPosition.latitude,
                startLongitude: userPosition.longitude,
                endLatitude: b.startingPintLat,
                endLongitude: b.startingPintLong,
              ),
            ),
      );
    } else if (sortBy == 'difficulty') {
      widget._resultEvents
          .sort((a, b) => a.difficultyLevel.compareTo(b.difficultyLevel));
      widget._suggestedEvents
          .sort((a, b) => a.difficultyLevel.compareTo(b.difficultyLevel));
    } else if (sortBy == 'lenght') {
      widget._resultEvents
          .sort((a, b) => a.averageLength.compareTo(b.averageLength));
      widget._suggestedEvents
          .sort((a, b) => a.averageLength.compareTo(b.averageLength));
    } else if (sortBy == 'duration') {
      widget._resultEvents
          .sort((a, b) => a.averageDuration.compareTo(b.averageDuration));
      widget._suggestedEvents
          .sort((a, b) => a.averageDuration.compareTo(b.averageDuration));
    } else if (sortBy == 'date') {
      widget._resultEvents.sort((a, b) => a.date.compareTo(b.date));
      widget._suggestedEvents.sort((a, b) => a.date.compareTo(b.date));
    }
  }

  Future<Null> _handleRefresh() async {
    final events = Provider.of<Events>(context, listen: false);
    events.fetchAndSetResultEvents(events.lastResultLat, events.lastResultLong,
        events.lastResultMaxDistKm);
    widget._resultEvents = events.resultEvents;

    events.fetchAndSetSuggestedEvents(events.lastSuggestedLat,
        events.lastSuggestedLong, events.lastSuggestedMaxDistKm);

    return null;
  }

  List<Widget> _buildContent(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    print("Rebuilding content");

    // suggested events taken from Events provider, re-fetch the suggested events every time there is an update in the widget tree

    //print("suggestedEvents: " + _suggestedEvents.toString());
    //print("Search_Screen printing suggestedEvents ID...");

    if (_rowColor == Colors.deepOrange.shade900) {
      __selectGridView(colors);
    }

    return [
      if (widget._resultEvents.length > 0)
        SliverPadding(
          padding:
              const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Results",
                  style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ),
      if (widget._resultEvents.length > 0)
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
                if (widget._resultEvents.length > index) {
                  return EventItem(
                    widget._resultEvents[index],
                    index,
                    widget._resultEvents.length,
                  );
                }
              },
              childCount: widget._resultEvents.length,
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
                "Suggested",
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
              return EventItem(widget._suggestedEvents[index], index,
                  widget._suggestedEvents.length);
            },
            childCount: widget._suggestedEvents.length,
          ),
        ),
      ),
      // Next, create a SliverList
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recently viewed",
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: 20,
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
          height: (380.0 / _view) / _aspectRatio,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            //itemCount: 10,
            itemCount: widget._recentEvents.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(left: 7, bottom: 5, right: 7),
                width: 370.0 / _view,
                height: (370 / _view) / _aspectRatio,
                child: EventItem(
                  widget._recentEvents[index],
                  index,
                  widget._recentEvents.length,
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

    double height = 123;
    if (_rowColor == Colors.deepOrange.shade900) {
      __selectGridView(colors);
    }
    return SliverAppBar(
      stretch: false,
      toolbarHeight: height,
      title: GradientAppBar(
        height,
        [
          Center(
            child: SearchButton(
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
                );
                widget._resultEvents = events.resultEvents;

                if (!widget.formValues['show_full']) {
                  widget._resultEvents = widget._resultEvents
                      .where((element) =>
                          element.maxParticipants !=
                          element.currentParticipants)
                      .toList();
                }
                setState(() {});
              },
            ),
          )
        ],
      ),

      titleSpacing: 0,
      expandedHeight: height + 60,
      backgroundColor: colors.background,

      // back up the list of items.
      floating: true,
      // Display a placeholder widget to visualize the shrinking size.
      pinned: true,
      snap: false,
      elevation: 4,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 0),
              height: 40,
              width: 75,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: colors.background,
                    primary: colors.onPrimary,
                    textStyle: const TextStyle(fontSize: 10),
                    padding: const EdgeInsets.all(0)),
                onPressed: () {
                  setState(() {
                    widget._sortMenu = !widget._sortMenu;
                  });
                },
                child: Text(
                  'Sort by',
                  style: widget._sortMenu
                      ? TextStyle(color: colors.secondaryColor, fontSize: 12)
                      : TextStyle(
                          color: colors.secondaryTextColor, fontSize: 12),
                ),
              ),
            ),
            Text(
              widget._resultEvents.length.toString() + " results",
              style: TextStyle(color: colors.secondaryTextColor, fontSize: 10),
            ),
            Container(
              width: 75,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.map_outlined,
                      size: 20,
                    ),
                    color: _mapColor,
                    onPressed: () {
                      __selectMapView(colors);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 10,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.table_rows_outlined,
                      size: 20,
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
                      size: 20,
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
        titlePadding: const EdgeInsets.only(left: 5, right: 5),
      ),
      // Make the initial height of the SliverAppBar larger than normal.
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding Page");
    final colors = Provider.of<CustomColorScheme>(context);
    final events = Provider.of<Events>(context);

    if (_isLoading) {
      return const CustomLoadingAnimation();
    } else {
      // This if statement is used to avoid reloading resultEvents on setState when sorting events
      if (widget._suggestedEvents.length == 0) {
        widget._resultEvents = events.resultEvents;
        print("Got events from provider");
      }
      widget._suggestedEvents = events.suggestedEvents;
      widget._recentEvents = events.recentEvents;

      if (_view == 3) {
        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 190,
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
                height: MediaQuery.of(context).size.height - 190 - 60,
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
              slivers: [
                _buildAppbar(context),
                widget._sortMenu
                    ? SliverToBoxAdapter(
                        child: Container(
                          color: colors.onPrimary,
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SortByButton(
                                title: 'Distance',
                                color: colors.secondaryColor,
                                id: 0,
                                activeId: widget._currentSortButton,
                                onPressed: () {
                                  _sortEvents('distance');
                                  setState(() {
                                    widget._currentSortButton = 0;
                                  });
                                },
                              ),
                              SortByButton(
                                title: 'Date',
                                color: Color.fromARGB(255, 102, 173, 97),
                                id: 1,
                                activeId: widget._currentSortButton,
                                onPressed: () {
                                  _sortEvents('date');
                                  setState(() {
                                    widget._currentSortButton = 1;
                                  });
                                },
                              ),
                              SortByButton(
                                title: 'Difficulty',
                                color: Color.fromARGB(255, 80, 159, 120),
                                id: 2,
                                activeId: widget._currentSortButton,
                                onPressed: () {
                                  _sortEvents('difficulty');
                                  setState(() {
                                    widget._currentSortButton = 2;
                                  });
                                },
                              ),
                              SortByButton(
                                title: 'Lenght',
                                color: Color.fromARGB(255, 59, 146, 143),
                                id: 3,
                                activeId: widget._currentSortButton,
                                onPressed: () {
                                  _sortEvents('lenght');
                                  setState(() {
                                    widget._currentSortButton = 3;
                                  });
                                },
                              ),
                              SortByButton(
                                title: 'Duration',
                                color: colors.primaryColor,
                                id: 4,
                                activeId: widget._currentSortButton,
                                onPressed: () {
                                  _sortEvents('duration');
                                  setState(() {
                                    widget._currentSortButton = 4;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: SizedBox(),
                      ),
                ..._buildContent(context)
              ],
            ),
          ),
        );
      }
    }
  }
}

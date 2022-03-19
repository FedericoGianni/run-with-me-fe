import 'package:flutter/material.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/widgets/custom_scroll_behavior.dart';

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
  int _currentSortButton = 0;
  Map<String, dynamic> formValues = {
    'show_full': false,
    'slider_value': 0.0,
    'city_name': '',
    'city_lat': 0.0,
    'city_long': 0.0
  };
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

  List<Widget> _buildContent(BuildContext context, List _eventList) {
    final colors = Provider.of<CustomColorScheme>(context);
    final events = Provider.of<Events>(context);

    // suggested events taken from Events provider, re-fetch the suggested events every time there is an update in the widget tree
    List<Event> _suggestedEvents = events.suggestedEvents;
    List<Event> _recentEvents = events.recentEvents;
    List<Event> _resultEvents = events.resultEvents;

    //print("suggestedEvents: " + _suggestedEvents.toString());
    //print("Search_Screen printing suggestedEvents ID...");
    for (int i = 0; i < _suggestedEvents.length; i++) {
      print(_suggestedEvents[i].id.toString());
    }

    if (_rowColor == Colors.deepOrange.shade900) {
      __selectGridView(colors);
    }

    _suggestedEvents.sort((a, b) => a.averageLength.compareTo(b.averageLength));
    return [
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
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
                  _suggestedEvents[index], index, _suggestedEvents.length);
            },
            childCount: _suggestedEvents.length,
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
              return EventItem(
                  _suggestedEvents[index], index, _suggestedEvents.length);
            },
            childCount: _suggestedEvents.length,
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
              // TextButton(
              //   style: TextButton.styleFrom(
              //       backgroundColor: colors.onPrimary,
              //       primary: colors.primaryColor,
              //       textStyle: const TextStyle(fontSize: 10),
              //       padding: const EdgeInsets.all(0)),
              //   onPressed: () => {},
              //   child: const Text('View all'),
              // ),
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
            itemCount: _recentEvents.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                width: 380.0 / _view,
                height: (370 / _view) / _aspectRatio,
                child: EventItem(
                  _recentEvents[index],
                  index,
                  _recentEvents.length,
                ),
              );
            },
          ),
        ),
      ),
    ];
  }

  Widget _buildAppbar(BuildContext context, int eventsQuantity) {
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
              onSubmitting: (value) {
                print('SEARCH SCREEN: ' + value.toString());
                setState(() {
                  widget.formValues = value;
                });
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
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 20,
              width: 50,
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
                      ? TextStyle(color: colors.secondaryColor)
                      : TextStyle(color: colors.secondaryTextColor),
                ),
              ),
            ),
            Text(
              eventsQuantity.toString() + " results",
              style: TextStyle(color: colors.secondaryTextColor, fontSize: 10),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.map_outlined),
                  color: _mapColor,
                  onPressed: () {
                    __selectMapView(colors);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.table_rows_outlined),
                  color: _rowColor,
                  onPressed: () {
                    __selectListView(colors);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.grid_view_outlined),
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
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      // Make the initial height of the SliverAppBar larger than normal.
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<Events>(context);
    final colors = Provider.of<CustomColorScheme>(context);

    if (_view == 3) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 190,
            child: CustomScrollView(
              slivers: [
                _buildAppbar(
                    context,
                    //_newEventList.length,
                    events.suggestedEvents.length),
              ],
            ),
          ),
          SizedBox(
            child: CustomMapsSearch(),
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 190 - 60,
          ),
        ],
      );
    } else {
      return ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: CustomScrollView(
          slivers: [
            _buildAppbar(context, events.suggestedEvents.length),
            widget._sortMenu
                ? SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SortByButton(
                            title: 'Distance',
                            color: colors.secondaryColor,
                            id: 0,
                            activeId: widget._currentSortButton,
                            onPressed: () {
                              setState(() {
                                widget._currentSortButton = 0;
                              });
                            },
                          ),
                          SortByButton(
                            title: 'Difficulty',
                            color: Color.fromARGB(255, 94, 168, 105),
                            id: 1,
                            activeId: widget._currentSortButton,
                            onPressed: () {
                              setState(() {
                                widget._currentSortButton = 1;
                              });
                            },
                          ),
                          SortByButton(
                            title: 'Lenght',
                            color: Color.fromARGB(255, 66, 150, 136),
                            id: 2,
                            activeId: widget._currentSortButton,
                            onPressed: () {
                              setState(() {
                                widget._currentSortButton = 2;
                              });
                            },
                          ),
                          SortByButton(
                            title: 'Duration',
                            color: colors.primaryColor,
                            id: 3,
                            activeId: widget._currentSortButton,
                            onPressed: () {
                              setState(() {
                                widget._currentSortButton = 3;
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
            ..._buildContent(context, events.suggestedEvents)
          ],
        ),
      );
    }
  }
}

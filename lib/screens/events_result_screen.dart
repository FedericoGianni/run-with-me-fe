import 'package:flutter/material.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/settings_manager.dart';

import '../widgets/event_card_text_only.dart';
import '../widgets/gradientAppbar.dart';
import '../themes/custom_colors.dart';
import '../widgets/custom_map_search.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  static const routeName = '/events';

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
  }

  var _isInit = true;
  var _isLoading = false;

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

  int _view = 2;
  double _aspectRatio = 1.4;
  late Color _rowColor;
  late Color _gridColor;
  late Color _mapColor;

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

  List<Widget> buildContent(BuildContext context, List _eventList) {
    final colors = Provider.of<CustomColorScheme>(context);
    final events = Provider.of<Events>(context);

    return [
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
              SizedBox(
                height: 30,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: colors.onPrimary,
                      primary: colors.primaryColor,
                      textStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      padding: const EdgeInsets.all(0)),
                  onPressed: () => {},
                  child: const Text('View all'),
                ),
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
                events.suggestedEvents[index],
                index,
                events.suggestedEvents.length,
              );
            },
            childCount: _eventList.length,
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
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: colors.onPrimary,
                    primary: colors.primaryColor,
                    textStyle: const TextStyle(fontSize: 10),
                    padding: const EdgeInsets.all(0)),
                onPressed: () => {},
                child: const Text('View all'),
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
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                width: 380.0 / _view,
                height: (370 / _view) / _aspectRatio,
                child: EventItem(
                  events.recentEvents[index],
                  index,
                  events.recentEvents.length,
                ),
              );
            },
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final events = Provider.of<Events>(context);

    if (_view == 3) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 150,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  stretch: false,
                  toolbarHeight: 103,
                  title: GradientAppBar(
                    105,
                    [
                      Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 10,
                          right: MediaQuery.of(context).size.width / 10,
                          top: 45,
                        ),
                        height: 45,
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: colors.onPrimary,
                          // set border width
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ), // set rounded corner radius
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle:
                                TextStyle(color: colors.secondaryTextColor),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: colors.secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  titleSpacing: 0,
                  expandedHeight: 150,
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
                                backgroundColor: colors.primaryColor,
                                primary: colors.onPrimary,
                                textStyle: const TextStyle(fontSize: 10),
                                padding: const EdgeInsets.all(0)),
                            onPressed: () => {},
                            child: const Text('Filter'),
                          ),
                        ),
                        Text(
                          events.suggestedEvents.length.toString() + " results",
                          style: TextStyle(
                              color: colors.secondaryTextColor, fontSize: 10),
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
                    titlePadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  // Make the initial height of the SliverAppBar larger than normal.
                ),
              ],
            ),
          ),
          SizedBox(
            child: CustomMapsSearch(),
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 150 - 60,
          ),
        ],
      );
    } else {
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: false,
            toolbarHeight: 103,
            title: GradientAppBar(
              105,
              [
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 10,
                    right: MediaQuery.of(context).size.width / 10,
                    top: 45,
                  ),
                  height: 45,
                  padding: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: colors.onPrimary,
                    // set border width
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ), // set rounded corner radius
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: colors.secondaryTextColor),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: colors.secondaryTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            titleSpacing: 0,
            expandedHeight: 150,
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
                          backgroundColor: colors.primaryColor,
                          primary: colors.onPrimary,
                          textStyle: const TextStyle(fontSize: 10),
                          padding: const EdgeInsets.all(0)),
                      onPressed: () => {},
                      child: const Text('Filter'),
                    ),
                  ),
                  Text(
                    events.suggestedEvents.length.toString() + " results",
                    style: TextStyle(
                        color: colors.secondaryTextColor, fontSize: 10),
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
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            // Make the initial height of the SliverAppBar larger than normal.
          ),
          ...buildContent(context, events.suggestedEvents)
        ],
      );
    }
  }
}

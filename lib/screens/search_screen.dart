import 'package:flutter/material.dart';
import 'package:runwithme/providers/event.dart';

import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';
import '../widgets/gradientAppbar.dart';
// import '../themes/custom_colors.dart';
import '../widgets/custom_map_search.dart';
import '../widgets/search_event_bottomsheet.dart';
import '../widgets/search_button.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _view = 2;
  double _aspectRatio = 1.4;
  Color _rowColor = Colors.deepOrange.shade900;
  Color _gridColor = Colors.deepOrange.shade900;
  Color _mapColor = Colors.deepOrange.shade900;

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
    if (_rowColor == Colors.deepOrange.shade900) {
      __selectGridView(colors);
    }
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
              // SizedBox(
              //   height: 30,
              //   child: TextButton(
              //     style: TextButton.styleFrom(
              //         backgroundColor: colors.onPrimary,
              //         primary: colors.primaryColor,
              //         textStyle: const TextStyle(
              //             fontSize: 12, fontWeight: FontWeight.w500),
              //         padding: const EdgeInsets.all(0)),
              //     onPressed: () => {},
              //     child: const Text('View all'),
              //   ),
              // ),
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
                _eventList[index],
                index,
                dummy.length,
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
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                width: 380.0 / _view,
                height: (370 / _view) / _aspectRatio,
                child: EventItem(
                  dummy[index],
                  index,
                  dummy.length,
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
                )),
          )

          // Container(
          //   margin: EdgeInsets.only(
          //     left: MediaQuery.of(context).size.width / 10,
          //     right: MediaQuery.of(context).size.width / 10,
          //     top: 45,
          //   ),
          //   height: 45,
          //   padding: const EdgeInsets.only(left: 5),
          //   decoration: const BoxDecoration(
          //     color: onPrimary,
          //     // set border width
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(10.0),
          //     ), // set rounded corner radius
          //   ),
          //   child: TextField(
          //     onTap: () {
          //       _openSearchMenu(context);
          //     },
          //     decoration: InputDecoration(
          //       hintText: 'Search',
          //       hintStyle: TextStyle(color: colors.secondaryTextColor),
          //       border: InputBorder.none,
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: colors.secondaryTextColor,
          //       ),
          //     ),
          //   ),
          // ),
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
                    backgroundColor: colors.primaryColor,
                    primary: colors.onPrimary,
                    textStyle: const TextStyle(fontSize: 10),
                    padding: const EdgeInsets.all(0)),
                onPressed: () => {},
                child: Text(
                  'Filter',
                  style: TextStyle(color: colors.primaryTextColor),
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
    var _newEventList = dummy.where((i) => i.difficultyLevel <= 3).toList();
    if (_view == 3) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 150,
            child: CustomScrollView(
              slivers: [
                _buildAppbar(
                  context,
                  _newEventList.length,
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
          _buildAppbar(context, _newEventList.length),
          ..._buildContent(context, _newEventList)
        ],
      );
    }
  }
}

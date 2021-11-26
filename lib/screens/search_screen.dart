import 'package:flutter/material.dart';
import 'package:runwithme/models/event.dart';

import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';
import '../widgets/gradientAppbar.dart';
import '../themes/custom_colors.dart';
import '../widgets/custom_maps.dart';
import '../widgets/search_event_bottomsheet.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _view = 2;
  double _aspectRatio = 1.4;
  Color _rowColor = secondaryTextColor;
  Color _gridColor = primaryColor;
  Color _mapColor = secondaryTextColor;

  void __selectListView() {
    setState(() {
      _view = 1;
      _aspectRatio = 3;
      _rowColor = primaryColor;
      _gridColor = secondaryTextColor;
      _mapColor = secondaryTextColor;
    });
  }

  void __selectGridView() {
    setState(() {
      _view = 2;
      _aspectRatio = 1.4;
      _gridColor = primaryColor;
      _rowColor = secondaryTextColor;
      _mapColor = secondaryTextColor;
    });
  }

  void __selectMapView() {
    setState(() {
      _view = 3;
      _gridColor = secondaryTextColor;
      _rowColor = secondaryTextColor;
      _mapColor = primaryColor;
    });
  }

  void _openSearchMenu(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius:
                const BorderRadius.vertical(top: const Radius.circular(15))),
        context: ctx,
        builder: (_) {
          return const SearchEventBottomSheet();
        });
  }

  List<Widget> _buildContent(BuildContext context, List _eventList) {
    return [
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
        sliver: SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Suggested",
                style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 30,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: onPrimary,
                      primary: primaryColor,
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
              const Text(
                "Recently viewed",
                style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: onPrimary,
                    primary: primaryColor,
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
    return SliverAppBar(
      stretch: false,
      toolbarHeight: 103,
      title: GradientAppBar(
        105,
        [
          GestureDetector(
            onTap: () {
              _openSearchMenu(context);
            },
            child: Container(
              margin: const EdgeInsets.only(
                // left: MediaQuery.of(context).size.width / 10,
                // right: MediaQuery.of(context).size.width / 10,
                top: 45,
              ),
              height: 45,
              width: MediaQuery.of(context).size.width / 1.5,
              padding: const EdgeInsets.only(left: 25),
              decoration: const BoxDecoration(
                color: onPrimary,
                // set border width
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ), // set rounded corner radius
              ),
              // set rounded corner radius
              child: Row(
                children: const [
                  Icon(
                    Icons.search,
                    color: secondaryTextColor,
                    size: 18,
                  ),
                  Text(
                    '   Search',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

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
          //       hintStyle: TextStyle(color: secondaryTextColor),
          //       border: InputBorder.none,
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: secondaryTextColor,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),

      titleSpacing: 0,
      expandedHeight: 150,
      backgroundColor: background,

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
                    backgroundColor: primaryColor,
                    primary: onPrimary,
                    textStyle: const TextStyle(fontSize: 10),
                    padding: const EdgeInsets.all(0)),
                onPressed: () => {},
                child: const Text('Filter'),
              ),
            ),
            Text(
              eventsQuantity.toString() + " results",
              style: const TextStyle(color: secondaryTextColor, fontSize: 10),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.map_outlined),
                  color: _mapColor,
                  onPressed: __selectMapView,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.table_rows_outlined),
                  color: _rowColor,
                  onPressed: __selectListView,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.grid_view_outlined),
                  color: _gridColor,
                  onPressed: __selectGridView,
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
            child: CustomMaps(),
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

import 'package:flutter/material.dart';
import 'package:runwithme/providers/event.dart';

import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';
import '../widgets/gradientAppbar.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class BookedEventsScreen extends StatefulWidget {
  static const routeName = '/event';

  const BookedEventsScreen({Key? key}) : super(key: key);

  @override
  State<BookedEventsScreen> createState() => _BookedEventsScreenState();
}

class _BookedEventsScreenState extends State<BookedEventsScreen> {
  int _view = 2;
  double _aspectRatio = 1.4;
  Color _rowColor = Colors.deepOrange.shade900;
  Color _gridColor = Colors.deepOrange.shade900;

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

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    if (_rowColor == Colors.deepOrange.shade900) {
      __selectGridView(colors);
    }
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          stretch: false,
          toolbarHeight: 123,
          title: Container(
            color: colors.onPrimary,
            height: 123,
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
          expandedHeight: 183,
          backgroundColor: colors.background,

          // back up the list of items.
          floating: true,
          // Display a placeholder widget to visualize the shrinking size.
          pinned: true,
          snap: false,
          elevation: 2,
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  dummy.length.toString() + " results",
                  style:
                      TextStyle(color: colors.secondaryTextColor, fontSize: 10),
                ),
                Row(
                  children: [
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
        SliverPadding(
          padding:
              const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booked events",
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
                List suggested =
                    dummy.where((i) => i.difficultyLevel <= 5).toList();
                return EventItem(
                  suggested[index],
                  index,
                  dummy.length,
                );
              },
              childCount:
                  dummy.where((i) => i.difficultyLevel <= 5).toList().length,
            ),
          ),
        ),
        // Next, create a SliverList
      ],
    );
  }
}

class BookedEventsAppbar extends StatelessWidget {
  const BookedEventsAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Container(
        height: 100,
        padding: EdgeInsets.only(
          top: 10 + MediaQuery.of(context).padding.top,
          bottom: 10,
        ),
        child: Image.asset(
          "assets/icons/logo_gradient.png",
          width: 130,
        ),
      ),
    );
  }
}

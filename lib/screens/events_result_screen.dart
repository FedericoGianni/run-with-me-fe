import 'package:flutter/material.dart';
import 'package:runwithme/models/event.dart';

import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';
import '../widgets/gradientAppbar.dart';
import '../themes/custom_colors.dart';

class EventsScreen extends StatefulWidget {
  static const routeName = '/events';

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _view = 2;
  double _aspectRatio = 1.4;
  Color _rowColor = secondaryTextColor;
  Color _gridColor = primaryColor;

  void __selectListView() {
    setState(() {
      _view = 1;
      _aspectRatio = 3;
      _rowColor = primaryColor;
      _gridColor = secondaryTextColor;
    });
  }

  void __selectGridView() {
    setState(() {
      _view = 2;
      _aspectRatio = 1.4;
      _gridColor = primaryColor;
      _rowColor = secondaryTextColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return GridView.builder(
    //   itemCount: dummy.length,
    //   padding: const EdgeInsets.all(25),
    //   itemBuilder: (BuildContext ctx, index) {
    //     return EventItem(
    //       dummy[index],
    //       index,
    //       dummy.length.toDouble(),
    //     );
    //   },
    //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    //     maxCrossAxisExtent: 200,
    //     childAspectRatio: 3 / 2.5,
    //     crossAxisSpacing: 20,
    //     mainAxisSpacing: 20,
    //   ),
    // );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          stretch: false,
          primary: true,
          toolbarHeight: 93,
          titleSpacing: 0,
          title: GradientAppBar(
            95,
            [
              const SizedBox(
                height: 40,
                width: double.infinity,
              ),
              Image.asset(
                "assets/icons/logo_white.png",
                width: 130,
              ),
            ],
          ),
          floating: false,
          pinned: false,
          snap: false,
        ),
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
                decoration: const BoxDecoration(
                  color: onPrimary,
                  // set border width
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ), // set rounded corner radius
                ),
                child: const TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
              ),
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
                  dummy.length.toString() + " results",
                  style:
                      const TextStyle(color: secondaryTextColor, fontSize: 10),
                ),
                Row(
                  children: [
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
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          // Make the initial height of the SliverAppBar larger than normal.
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
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
                List suggested =
                    dummy.where((i) => i.difficultyLevel <= 3).toList();
                return EventItem(
                  suggested[index],
                  index,
                  dummy.length.toDouble(),
                );
              },
              childCount:
                  dummy.where((i) => i.difficultyLevel <= 3).toList().length,
            ),
          ),
        ),
        // Next, create a SliverList
        SliverPadding(
          padding:
              const EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
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
                  padding: const EdgeInsets.only(left: 5),
                  width: 380.0 / _view,
                  height: (380 / _view) / _aspectRatio,
                  child: EventItem(
                    dummy[index],
                    index,
                    dummy.length.toDouble(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// class EventsAppbar extends StatelessWidget {
//   const EventsAppbar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GradientAppBar(
//       180,
//       [
//         SizedBox(
//           height: 10,
//         ),
//         Image.asset(
//           "assets/icons/logo_white.png",
//           width: MediaQuery.of(context).size.width / 3,
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height / 30,
//         ),
//         Container(
//           margin: EdgeInsets.only(
//             left: MediaQuery.of(context).size.width / 16,
//             right: MediaQuery.of(context).size.width / 6,
//           ),
//           height: 45,
//           // padding: EdgeInsets.only(left: 5),
//           decoration: BoxDecoration(
//             color: onPrimary,
//             // set border width
//             borderRadius: const BorderRadius.all(
//               Radius.circular(10.0),
//             ), // set rounded corner radius
//           ),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search',
//               hintStyle: TextStyle(color: secondaryTextColor),
//               border: InputBorder.none,
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: secondaryTextColor,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';
import '../widgets/gradientAppbar.dart';
import '../themes/custom_colors.dart';

class EventsScreen extends StatelessWidget {
  static const routeName = '/events';
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
        // Add the app bar to the CustomScrollView.
        SliverAppBar(
          // Provide a standard title.
          stretch: false,
          toolbarHeight: 100,
          title: GradientAppBar(
            100,
            [
              SizedBox(
                height: MediaQuery.of(context).size.height / 25,
              ),
              Image.asset(
                "assets/icons/logo_white.png",
                width: MediaQuery.of(context).size.width / 3,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height / 30,
              // ),
            ],
            end: 0.8,
          ),
          titleSpacing: 0,
          backgroundColor: background,
          stretchTriggerOffset: 10,
          // back up the list of items.
          floating: false,
          // Display a placeholder widget to visualize the shrinking size.
          pinned: false,
          snap: false,
          // Make the initial height of the SliverAppBar larger than normal.
        ),
        SliverAppBar(
          // Provide a standard title.
          stretch: false,
          toolbarHeight: 90,
          title: GradientAppBar(
            90,
            [
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 6,
                  right: MediaQuery.of(context).size.width / 6,
                  top: 30,
                ),
                height: 45,
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: onPrimary,
                  // set border width
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ), // set rounded corner radius
                ),
                child: TextField(
                  decoration: InputDecoration(
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
            start: -0.09,
            end: 0,
          ),
          titleSpacing: 0,
          expandedHeight: 150,
          backgroundColor: background,
          stretchTriggerOffset: 10,

          // back up the list of items.
          floating: true,
          // Display a placeholder widget to visualize the shrinking size.
          pinned: true,
          snap: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              children: [
                Icon(
                  Icons.table_rows_outlined,
                  color: primaryColor,
                ),
                Icon(
                  Icons.card_travel_outlined,
                  color: secondaryTextColor,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            collapseMode: CollapseMode.none,
          ),
          // Make the initial height of the SliverAppBar larger than normal.
        ),

        SliverPadding(
          padding: EdgeInsets.only(bottom: 40, top: 20, left: 10, right: 10),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.50,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return EventItem(
                  dummy[index],
                  index,
                  dummy.length.toDouble(),
                );
              },
              childCount: 16,
            ),
          ),
        )
        // Next, create a SliverList
      ],
    );
  }
}

class EventsAppbar extends StatelessWidget {
  const EventsAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(
      180,
      [
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        Image.asset(
          "assets/icons/logo_white.png",
          width: MediaQuery.of(context).size.width / 3,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30,
        ),
        Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 6,
            right: MediaQuery.of(context).size.width / 6,
          ),
          height: 45,
          padding: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            color: onPrimary,
            // set border width
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ), // set rounded corner radius
          ),
          child: TextField(
            decoration: InputDecoration(
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
    );
  }
}

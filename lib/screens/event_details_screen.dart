import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../themes/custom_colors.dart';
import '../providers/event.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_maps_event_detail.dart';

class EventDetailsScreen extends StatelessWidget {
  static const routeName = '/details';
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)?.settings.arguments as Event;
    final colors = Provider.of<CustomColorScheme>(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).padding.top + 60,
        ),
        child: Container(
          // ignore: prefer_const_constructors

          color: colors.onPrimary,
          width: double.infinity,
          margin: const EdgeInsets.only(
            top: 20,
          ),
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          child: Image.asset(
            "assets/icons/logo_gradient.png",
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding:
                const EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Posted on Wed, 03/20",
                      style: TextStyle(
                          color: colors.secondaryTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'ID: ' + event.id.toString(),
                      style: TextStyle(
                          color: colors.secondaryTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 0, left: 20, right: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      event.name,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 2,
                child: CustomMapsEvent(
                  event: event,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(bottom: 20, top: 0, left: 15, right: 15),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 160,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date:',
                            style: TextStyle(
                                color: colors.secondaryTextColor, fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              event.date,
                              style:
                                  TextStyle(color: colors.secondaryTextColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(bottom: 20, top: 50, left: 20, right: 20),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: colors.primaryColor,
                        primary: colors.onPrimary,
                        textStyle: const TextStyle(fontSize: 10),
                        padding: const EdgeInsets.all(0)),
                    onPressed: () => {},
                    child: Text(
                      'Subscribe',
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

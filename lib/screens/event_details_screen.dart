import 'package:flutter/material.dart';
import '../themes/custom_colors.dart';
import '../providers/event.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

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
                const EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
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
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
                bottom: 20, top: 500, left: 20, right: 20),
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
                          color: colors.onPrimary,
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

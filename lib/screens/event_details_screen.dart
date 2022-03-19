import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/screens/booked_events_screen.dart';
import 'package:runwithme/screens/search_screen.dart';
import 'package:runwithme/widgets/event_detail_card.dart';
import '../providers/user.dart';
import '../themes/custom_colors.dart';
import '../providers/event.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_alert_dialog.dart';
import '../widgets/custom_maps_event_detail.dart';

class EventDetailsScreen extends StatelessWidget {
  static const routeName = '/details';
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)?.settings.arguments as Event;
    final user = Provider.of<User>(context, listen: false);
    final events = Provider.of<Events>(context, listen: false);
    final colors = Provider.of<CustomColorScheme>(context);

    Future<void> _showMyDialog(String title, String msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(msg),
          );
        },
      );
    }

    void _addBookingToEvent(int eventId, int userId) async {
      if (await events.addBookingToEvent(event.id, user.userId ?? -1)) {
        _showMyDialog("AddBooking", "Successfully booked");
        // switch to booked events page
        // open new event detail screen
        Navigator.of(context).pushNamed(BookedEventsScreen.routeName);
      }
    }

    void _removeBookingFromEvent(int eventId, int userId) async {
      if (await events.delBookingFromEvent(event.id, user.userId ?? -1)) {
        _showMyDialog("delBooking", "Successfully deleted booking");
        // switch to booked events screen
        Navigator.of(context).pushNamed(BookedEventsScreen.routeName);
      }
    }

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
                      "Created: " +
                          event.createdAt.day.toString() +
                          "/" +
                          event.createdAt.month.toString() +
                          "/" +
                          event.createdAt.year.toString() +
                          " " +
                          event.createdAt.hour.toString() +
                          ":" +
                          event.createdAt.minute.toString(),
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
          //actual event details
          SliverPadding(
            padding:
                const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
            sliver: SliverToBoxAdapter(child: EventDetail(event)),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(bottom: 20, top: 50, left: 20, right: 20),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 40,
                  child: event.userBooked
                      ? TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: colors.errorColor,
                              primary: colors.onPrimary,
                              textStyle: const TextStyle(fontSize: 10),
                              padding: const EdgeInsets.all(0)),
                          onPressed: () => _removeBookingFromEvent(
                              event.id, user.userId ?? -1),
                          child: Text(
                            'Unsubscribe',
                            style: TextStyle(
                                color: colors.primaryTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      : TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: colors.primaryColor,
                              primary: colors.onPrimary,
                              textStyle: const TextStyle(fontSize: 10),
                              padding: const EdgeInsets.all(0)),
                          onPressed: () =>
                              _addBookingToEvent(event.id, user.userId ?? -1),
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

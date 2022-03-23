import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/screens/booked_events_screen.dart';
import 'package:runwithme/screens/search_screen.dart';
import 'package:runwithme/screens/tabs_screen.dart';
import 'package:runwithme/screens/user_screen.dart';
import 'package:runwithme/widgets/event_detail_card.dart';
import '../methods/DateHelper.dart';
import '../providers/settings_manager.dart';
import '../providers/user.dart';
import '../themes/custom_colors.dart';
import '../providers/event.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_alert_dialog.dart';
import '../widgets/custom_maps_event_detail.dart';
import '../widgets/custom_snackbar.dart';

class EventDetailsScreen extends StatefulWidget {
  static const routeName = '/details';
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)?.settings.arguments as Event;
    final user = Provider.of<User>(context, listen: false);
    final events = Provider.of<Events>(context, listen: false);
    final colors = Provider.of<CustomColorScheme>(context);
    final isLoggedIn = Provider.of<UserSettings>(context).isLoggedIn();
    final pageIndex = Provider.of<PageIndex>(context, listen: false);

    Future<Null> _handleRefresh() async {
      // reload page with updated event details
      Navigator.of(context).popAndPushNamed(
        EventDetailsScreen.routeName,
        arguments: await Provider.of<Events>(context, listen: false)
            .fetchEventById(event.id),
      );
      return null;
    }

    void _addBookingToEvent(int eventId, int userId) async {
      if (await events.addBookingToEvent(event.id)) {
        // show snackbar with addBookingToEvent result
        CustomSnackbarProvider snackbarProvider = CustomSnackbarProvider(
            ctx: context, message: "Successfully booked to event.");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackbarProvider.provide());
      } else {
        CustomSnackbarProvider snackbarProvider = CustomSnackbarProvider(
            ctx: context,
            message: "Error while trying to create booking to the event.");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackbarProvider.provide());
      }

      // reload booked events
      events.fetchAndSetBookedEvents(userId);

      // reload page with updated event details
      Navigator.of(context).popAndPushNamed(
        EventDetailsScreen.routeName,
        arguments: await Provider.of<Events>(context, listen: false)
            .fetchEventById(event.id),
      );
    }

    void _removeBookingFromEvent(int eventId, int userId) async {
      if (await events.delBookingFromEvent(event.id)) {
        // show snackbar with addBookingToEvent result
        CustomSnackbarProvider snackbarProvider = CustomSnackbarProvider(
            ctx: context, message: "Successfully unbooked from event.");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackbarProvider.provide());
      } else {
        CustomSnackbarProvider snackbarProvider = CustomSnackbarProvider(
            ctx: context, message: "Error while trying to unbook from event.");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackbarProvider.provide());
      }

      // reload booked events
      events.fetchAndSetBookedEvents(userId);

      // reload page with updated event details
      Navigator.of(context).popAndPushNamed(
        EventDetailsScreen.routeName,
        arguments: await Provider.of<Events>(context, listen: false)
            .fetchEventById(event.id),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Scaffold(
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
              padding: const EdgeInsets.only(
                  bottom: 20, top: 0, left: 20, right: 20),
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
                            DateHelper.formatHourOrMinutes(
                                event.createdAt.hour.toString()) +
                            ":" +
                            DateHelper.formatHourOrMinutes(
                                event.createdAt.minute.toString()),
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
              padding: const EdgeInsets.only(
                  bottom: 30, top: 0, left: 20, right: 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        event.name,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: colors.primaryTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: isLoggedIn
                          ? event.userBooked
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: colors.errorColor,
                                      primary: colors.primaryTextColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      textStyle: const TextStyle(fontSize: 10),
                                      padding: const EdgeInsets.all(0)),
                                  onPressed: () => _addBookingToEvent(
                                      event.id, user.userId ?? -1),
                                  child: Text(
                                    'Subscribe',
                                    style: TextStyle(
                                        color: colors.primaryTextColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                          : TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: colors.secondaryColor,
                                  primary: colors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  textStyle: const TextStyle(fontSize: 10),
                                  padding: const EdgeInsets.all(0)),
                              onPressed: () => {
                                Navigator.pop(context),
                                pageIndex.setPage(Screens.USER.index)
                              },
                              child: Text(
                                'Login to Subscribe',
                                style: TextStyle(
                                    color: colors.primaryTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.only(bottom: 0, top: 0, left: 20, right: 20),
              sliver: SliverToBoxAdapter(
                child: Card(
                  color: colors.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 4,
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 2,
                    child: CustomMapsEvent(
                      event: event,
                    ),
                  ),
                ),
              ),
            ),
            //actual event details
            SliverPadding(
              padding: const EdgeInsets.only(
                  bottom: 0, top: 10, left: 20, right: 20),
              sliver: SliverToBoxAdapter(child: EventDetail(event)),
            ),
          ],
        ),
      ),
    );
  }
}

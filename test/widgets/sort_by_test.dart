// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import 'package:runwithme/main.dart';
// import 'package:runwithme/providers/color_scheme.dart';
// import 'package:runwithme/providers/event.dart';
// import 'package:runwithme/providers/events.dart';
// import 'package:runwithme/providers/locationHelper.dart';
// import 'package:runwithme/providers/page_index.dart';
// import 'package:runwithme/providers/settings_manager.dart';
// import 'package:runwithme/providers/user.dart';
// import 'package:runwithme/screens/add_event_screen.dart';
// import 'package:runwithme/screens/booked_events_screen.dart';
// import 'package:runwithme/screens/event_details_screen.dart';
// import 'package:runwithme/screens/events_result_screen.dart';
// import 'package:runwithme/screens/home_screen.dart';
// import 'package:runwithme/screens/search_screen.dart';
// import 'package:runwithme/screens/tabs_screen.dart';
// import 'package:runwithme/screens/user_screen.dart';
// import 'package:runwithme/themes/custom_theme.dart';
// import 'package:runwithme/widgets/custom_loading_animation.dart';
// import 'package:runwithme/widgets/custom_sort_by_button.dart';
// import 'package:runwithme/widgets/permissions_message.dart';
// import 'package:runwithme/widgets/sort_by.dart';

void main() {
//   List<List<Event>> _fakeEventsListList = [];
//   List<Event> _fakeEventList = [];
//   SortButton _currentSortButton = SortButton.none;
//   Function(SortButton, List<List<Event>>) _onTap =
//       (_currentSortButton, _fakeEventsList) {};
//   CustomColorScheme colorScheme = CustomColorScheme();

//   for (int i = 0; i < 10; i++) {
//     _fakeEventsListList.add(_fakeEventList);
//     for (int j = 0; j < 10; j++) {
//       _fakeEventsListList[i].add(Event(
//           id: j,
//           createdAt: DateTime.now(),
//           name: "Your Position",
//           date: DateTime.now(),
//           startingPintLat: 0.0,
//           startingPintLong: 0.0,
//           difficultyLevel: 5.0,
//           averagePaceMin: 0,
//           averagePaceSec: 0,
//           averageDuration: 0,
//           averageLength: 0,
//           adminId: -1,
//           currentParticipants: 0,
//           maxParticipants: 0));
//     }
//   }

//   testWidgets('[SORT BY]', (WidgetTester tester) async {
//     BookedEventsScreen bookedEventsScreen;
//     await tester.pumpWidget(MultiProvider(providers: [
//       ChangeNotifierProvider<CustomColorScheme>.value(
//           value: CustomColorScheme()),
//       ChangeNotifierProvider<Events>.value(value: Events()),
//       ChangeNotifierProvider<LocationHelper>.value(
//         value: LocationHelper(),
//       ),
//       ChangeNotifierProvider<UserSettings>.value(
//         value: UserSettings(),
//       ),
//       ChangeNotifierProvider<PageIndex>.value(
//         value: PageIndex(),
//       ),
//       ChangeNotifierProvider<User>.value(
//         value: User(),
//       ),
//     ], child: MaterialApp(home: bookedEventsScreen = BookedEventsScreen())));

//     expect(
//         find.byWidget(
//           PermissionMessage(),
//         ),
//         findsOneWidget);

//     // final finder = find.byWidget(SortByRow(
//     //   onTap: _onTap,
//     //   currentSortButton: _currentSortButton,
//     //   eventLists: _fakeEventsListList,
//     // ));
//     // // shouldn't load SortByRow Widget by defaul, only when _sortMenu is true
//     // expect(finder, findsNothing);
//   });
}

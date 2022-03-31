import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/classes/markers.dart';
import 'package:runwithme/main.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/widgets/custom_info_window.dart';

// class MockBuildContext extends Mock implements BuildContext {}

class MockCustomInfoWindowController extends Mock
    implements CustomInfoWindowController {}

void main() {
  // MockBuildContext _mockContext = MockBuildContext();
  MockCustomInfoWindowController _mockCustomInfoWindowController =
      MockCustomInfoWindowController();

  List<Event> fakeEventsList = [];
  for (int i = 0; i < 10; i++) {
    fakeEventsList.add(Event(
        id: i,
        createdAt: DateTime.now(),
        name: "Your Position",
        date: DateTime.now(),
        startingPintLat: 0.0,
        startingPintLong: 0.0,
        difficultyLevel: 5.0,
        averagePaceMin: 0,
        averagePaceSec: 0,
        averageDuration: 0,
        averageLength: 0,
        adminId: -1,
        currentParticipants: 0,
        maxParticipants: 0));
  }

  Map<String, Marker> expectedMarkers = {};

  group('[MARKERS]', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      final BuildContext context = tester.element(find.byType(MyApp));

      // TODO not working because markerGenerator needs inside Provider of CustomColorScheme
      // expectedMarkers = markerGenerator(
      //     fakeEventsList, _mockCustomInfoWindowController, context);
      // expect(expectedMarkers.isNotEmpty, true);
    });
  });
}

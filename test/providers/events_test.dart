import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
//import 'package:provider/provider.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  //MockBuildContext _mockContext;
  Events events = Events();
  List<Event> fakeEventsList = [];

  for (int i = 0; i < events.MAX_RECENT_EVENTS_LENGTH + 1; i++) {
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

  Event fakeEvent = Event(
      id: -1,
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
      maxParticipants: 0);

  // setUp(() {
  //   _mockContext = MockBuildContext();
  //   //events = Provider.of<Events>(_mockContext, listen: false);
  //   //events = Events();
  // });

  group('[EVENTS]', () {
    test('recent events does not add the same event 2 times', () {
      for (int i = 0; i < events.MAX_RECENT_EVENTS_LENGTH; i++) {
        events.addRecentEvent(fakeEvent);
      }
      expect(events.recentEvents.length, 1);
    });
    test('recent events does not add more than MAX_RECENT_EVENTS_LENGTH events',
        () {
      for (int i = 0; i < events.MAX_RECENT_EVENTS_LENGTH + 1; i++) {
        events.addRecentEvent(fakeEventsList[i]);
      }

      expect(events.recentEvents.length, events.MAX_RECENT_EVENTS_LENGTH);
    });
  });
}

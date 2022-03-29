import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  Events? events;
  MockBuildContext _mockContext;
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

  setUp(() {
    _mockContext = MockBuildContext();
    events = Provider.of<Events>(_mockContext, listen: false);
  });

  // should we test API in unit tests?
  group('Events API test group', () {
    // TODO
  });
}

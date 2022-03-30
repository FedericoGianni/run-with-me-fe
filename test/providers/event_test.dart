import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/providers/event.dart';

void main() {
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

  group('[EVENT]', () {
    test('event is built correctly', () {
      expect(fakeEvent.id, -1);
      expect(fakeEvent.createdAt.day, DateTime.now().day);
      expect(fakeEvent.startingPintLat, 0.0);
      expect(fakeEvent.startingPintLong, 0.0);
      expect(fakeEvent.difficultyLevel, 5.0);
      expect(fakeEvent.averagePaceMin, 0);
      expect(fakeEvent.averagePaceSec, 0);
      expect(fakeEvent.averageDuration, 0);
      expect(fakeEvent.averageLength, 0);
      expect(fakeEvent.adminId, -1);
      expect(fakeEvent.currentParticipants, 0);
      expect(fakeEvent.maxParticipants, 0);
    });
  });
}

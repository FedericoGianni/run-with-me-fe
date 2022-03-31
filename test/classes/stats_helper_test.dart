import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:runwithme/classes/stats_helper.dart';
import 'package:runwithme/main.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  MockBuildContext _mockContext = MockBuildContext();
  StatsHelper statsHelper = StatsHelper(_mockContext);

  group('[STATS HELPER]', () {
    test('Avg Pace calc test', () {
      List<int> avgPace = [];
      avgPace.addAll([0, 0]);
      expect(statsHelper.calcWeeklyAvgPaceParams(0, 0), avgPace);

      avgPace = [];
      avgPace.addAll([5, 0]);
      expect(statsHelper.calcWeeklyAvgPaceParams(10, 50), avgPace);

      avgPace = [];
      avgPace.addAll([5, 0]);
      expect(statsHelper.calcWeeklyAvgPaceParams(20, 100), avgPace);
    });
  });
}

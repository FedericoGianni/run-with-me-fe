import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/events.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  Events events;
  MockBuildContext _mockContext;

  setUp(() {
    _mockContext = MockBuildContext();
    final events = Provider.of<Events>(_mockContext, listen: false);
  });

  test('me testing', () {
    // TODO
  });
}

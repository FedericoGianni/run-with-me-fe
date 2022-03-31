import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/classes/multi_device_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
//import 'package:provider/provider.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  MockBuildContext _mockContext = MockBuildContext();
  MultiDeviceSupport multiDeviceSupport = MultiDeviceSupport(_mockContext);
  group('[MULTI DEVICE SUPPORT]', () {
    test('', () {
      expect(multiDeviceSupport.screenHeight, 0.0);
      expect(multiDeviceSupport.screenWidth, 0.0);
    });
  });
}

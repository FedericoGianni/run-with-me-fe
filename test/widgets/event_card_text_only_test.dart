import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/location_helper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/event_card_text_only.dart';

void main() {
  Event _fakeEvent = Event(
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

  CustomColorScheme colorScheme = CustomColorScheme();

  testWidgets('[EVENT DETAIL CARD TEXT ONLY]', (WidgetTester tester) async {
    void setScreenSize({required int width, required int height}) {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue =
          Size(width * dpi, height * dpi);
    }

    // used because deafult test widget env is 400x600 so it overflows
    //setScreenSize(width: 1080, height: 2000);

    await tester.pumpWidget(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<CustomColorScheme>.value(
                value: CustomColorScheme()),
            ChangeNotifierProvider<Events>.value(value: Events()),
            ChangeNotifierProvider<LocationHelper>.value(
              value: LocationHelper(),
            ),
            ChangeNotifierProvider<UserSettings>.value(
              value: UserSettings(),
            ),
            ChangeNotifierProvider<PageIndex>.value(
              value: PageIndex(),
            ),
            ChangeNotifierProvider<User>.value(
              value: User(),
            ),
          ],
          child: MaterialApp(
              home: Material(
            child: SingleChildScrollView(
                child: Column(children: [
              EventItem(_fakeEvent, 1, 1, 1),
            ])),
          ))),
    );

    expect(find.byType(InkWell), findsOneWidget);

    // if current participants = max participants should display error color
    Text text = find
        .byKey(const Key("participants"))
        .first
        .evaluate()
        .single
        .widget as Text;

    expect(text.style!.color, colorScheme.errorColor);
  });
}

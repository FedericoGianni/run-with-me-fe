import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/custom_sort_by_button.dart';

void main() {
  testWidgets('[CUSTOM SORT BY BUTTON]', (WidgetTester tester) async {
    void setScreenSize({required int width, required int height}) {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue =
          Size(width * dpi, height * dpi);
    }

    // used because deafult test widget env is 400x600 so it overflows
    //setScreenSize(width: 1080, height: 2000);

    await tester.pumpWidget(MultiProvider(
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
            child: SortByButton(
              title: "",
              color: Colors.amber,
              id: SortButton.date,
              activeId: SortButton.difficulty,
              onPressed: () => {},
            ),
          )),
        )));

    SortByButton widget = find
        .byType(SortByButton)
        .first
        .evaluate()
        .single
        .widget as SortByButton;
    CustomColorScheme colors = CustomColorScheme();

    // id != active id so expect color to be secondary text color
    expect(widget.color, colors.secondaryTextColor);

    expect(find.byType(Container), findsOneWidget);
  });
}

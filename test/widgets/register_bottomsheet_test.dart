import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/register_bottomsheet.dart';
import 'package:runwithme/widgets/search_button.dart';

void main() {
  testWidgets('[REGISTER BOTTOMSHEET]', (WidgetTester tester) async {
    void setScreenSize({required int width, required int height}) {
      final dpi = tester.binding.window.devicePixelRatio;
      tester.binding.window.physicalSizeTestValue =
          Size(width * dpi, height * dpi);
    }

    // used because deafult test widget env is 400x600 so it overflows
    setScreenSize(width: 1080, height: 1920);

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
      child: const MaterialApp(
          home: SingleChildScrollView(
        child: Material(
          child: SingleChildScrollView(
            child: SubscribeBottomSheet(),
          ),
        ),
      )),
    ));
    // for(widget in tester.allWidgets){
    //   w
    // }

    expect(find.byType(Text), findsWidgets);
    expect(find.byType(TextFormField), findsWidgets);

    SubscribeBottomSheet subscribeBottomSheet = find
        .byType(SubscribeBottomSheet)
        .first
        .evaluate()
        .single
        .widget as SubscribeBottomSheet;

    TextFormField password =
        find.byKey(Key('password')).evaluate().single.widget as TextFormField;

    await tester.enterText(find.byKey(const Key('password')), "test1");

    var element = subscribeBottomSheet.createElement();
    final state = element.state as SubscribeBottomSheetState;
    expect(state.initValues.containsKey("password"), true);
    //print("password initial value: " + password.initialValue.toString());

    TextFormField password2 =
        find.byKey(Key('password')).evaluate().single.widget as TextFormField;

    await tester.enterText(find.byKey(Key('password2')), "test2");
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/providers/location_helper.dart';
import 'package:runwithme/providers/page_index.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';
import 'package:runwithme/widgets/login_form.dart';
import 'package:runwithme/widgets/register_bottomsheet.dart';

void main() {
  testWidgets('[LOGIN FORM]', (WidgetTester tester) async {
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
        child: const MaterialApp(home: Material(child: LoginForm())),
      ),
    );

    expect(find.byType(Form), findsOneWidget);

    expect(find.byType(SubscribeBottomSheet), findsNothing);

    await tester.enterText(find.byKey(const Key("usernameForm")), "user");
    await tester.enterText(find.byKey(const Key("passwordForm")), "password");

    GlobalKey<FormState> formState =
        (tester.state<LoginFormState>(find.byType(LoginForm)).form);
    formState.currentState!.save();
    // print(tester.state<LoginFormState>(find.byType(LoginForm)).initValues);

    expect(
        tester
            .state<LoginFormState>(find.byType(LoginForm))
            .initValues
            .values
            .first,
        "user");

    expect(
        tester
            .state<LoginFormState>(find.byType(LoginForm))
            .initValues
            .values
            .elementAt(1),
        "password");
  });
}

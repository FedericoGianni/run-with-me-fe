// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:runwithme/themes/custom_colors.dart';
import 'package:runwithme/widgets/search_button.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/gradientAppbar.dart';
import '../providers/settings_manager.dart';
import '../widgets/search_event_bottomsheet.dart';
import '../widgets/login_form.dart';
import '../widgets/search_button.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<bool> isSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);
    if (colors.currentMode == 'dark') {
      isSelected = [false, true];
    } else if (colors.currentMode == 'light') {
      isSelected = [true, false];
    }
    if (settings.settings.isLoggedIn) {
      return Column(
        children: [
          Center(child: Text('User Info Page')),
          Container(
            child: ToggleButtons(
              children: <Widget>[
                Icon(Icons.light_mode),
                Icon(Icons.dark_mode),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = !isSelected[buttonIndex];
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                  if (index == 0) {
                    settings.setThemeMode(CustomThemeMode.light);
                  } else {
                    settings.setThemeMode(CustomThemeMode.dark);
                  }
                });
              },
              isSelected: isSelected,
            ),
          ),
          Container(
            child: TextButton(
                onPressed: () {
                  settings.userLogout();
                },
                child: Text(
                  "logout",
                  style: TextStyle(color: colors.primaryColor),
                )),
          )
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        child: const Center(widthFactor: 0.5, child: LoginForm()),
      );
    }
  }
}

class UserAppbar extends StatelessWidget {
  const UserAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);

    return GradientAppBar(100, [
      settings.settings.isLoggedIn
          ? Container(
              child: Text(
                'User Profile',
                style: TextStyle(
                    color: colors.titleColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
              height: 100,
              padding: EdgeInsets.only(top: 25),
            )
          : Container(
              height: 100,
              child: Center(
                child: Image.asset(
                  "assets/icons/logo_white.png",
                  width: 130,
                ),
              ),
            ),
    ]);
  }
}

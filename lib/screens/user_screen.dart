import 'package:flutter/material.dart';
import 'package:runwithme/themes/custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/gradientAppbar.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<bool> isSelected = [false, false];

  void _setThemeMode(int index, CustomColorScheme colors) {
    if (index == 0) {
      colors.setLightMode();
    } else if (index == 1) {
      colors.setDarkMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    if (colors.currentMode == 'dark') {
      isSelected = [false, true];
    } else if (colors.currentMode == 'light') {
      isSelected = [true, false];
    }
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
                _setThemeMode(index, colors);
              });
            },
            isSelected: isSelected,
          ),
        ),
      ],
    );
  }
}

class UserAppbar extends StatelessWidget {
  const UserAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    return GradientAppBar(100, [
      Container(
        child: Text(
          'User Profile',
          style: TextStyle(
              color: colors.onPrimary,
              fontSize: 40,
              fontWeight: FontWeight.w700),
        ),
        height: 100,
        padding: EdgeInsets.only(top: 25),
      )
    ]);
  }
}

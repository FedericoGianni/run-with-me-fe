import '../themes/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomColorScheme with ChangeNotifier {
  Color titleColor = Colors.amber.shade900;
  Color primaryColor = Colors.amber.shade900;
  Color primaryColorLight = Colors.amber.shade900;
  Color secondaryColor = Colors.amber.shade900;
  Color primaryTextColor = Colors.amber.shade900;
  Color secondaryTextColor = Colors.amber.shade900;
  Color tertiaryTextColor = Colors.amber.shade900;
  Color onPrimary = Colors.amber.shade900;
  Color background = Colors.amber.shade900;
  Color errorColor = Colors.amber.shade900;
  String currentMode = '';

  void setDarkMode() {
    titleColor = const Color(MAGNOLIA);
    primaryColor = const Color(CG_BLUE_HEX);
    primaryColorLight = Color.fromARGB(255, 94, 183, 215);
    secondaryColor = const Color(YELLOW_GREEN);
    primaryTextColor = const Color(PLATINUM);
    secondaryTextColor = const Color(SILVER_CHALICE);
    tertiaryTextColor = const Color(PLATINUM_DARK);
    onPrimary = const Color(dark1);
    background = const Color(JET_BLACK_DARK);
    errorColor = const Color(ERROR);
    currentMode = 'dark';
    print("DarkMode");
    notifyListeners();
  }

  void setLightMode() {
    titleColor = const Color(MAGNOLIA);
    primaryColor = const Color(CG_BLUE_HEX);
    primaryColorLight = const Color(CG_BLUE_HEX_LIGHT);
    secondaryColor = const Color(YELLOW_GREEN);
    primaryTextColor = const Color(JET_BLACK);
    secondaryTextColor = const Color(SILVER_CHALICE);
    tertiaryTextColor = const Color(PLATINUM_DARK);
    onPrimary = const Color(MAGNOLIA);
    background = const Color(PLATINUM);
    errorColor = const Color(ERROR);
    currentMode = 'light';
    print("LightMode");

    notifyListeners();
  }
}

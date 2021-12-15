import '../themes/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomColorScheme with ChangeNotifier {
  Color primaryColor = Colors.amber.shade900;
  Color secondaryColor = Colors.amber.shade900;
  Color primaryTextColor = Colors.amber.shade900;
  Color secondaryTextColor = Colors.amber.shade900;
  Color tertiaryTextColor = Colors.amber.shade900;
  Color onPrimary = Colors.amber.shade900;
  Color background = Colors.amber.shade900;
  Color errorColor = Colors.amber.shade900;
  String currentMode = '';

  void setDarkMode() {
    primaryColor = Color(CG_BLUE_HEX);
    secondaryColor = Color(YELLOW_GREEN);
    primaryTextColor = Color(PLATINUM);
    secondaryTextColor = Color(SILVER_CHALICE);
    tertiaryTextColor = Color(PLATINUM_DARK);
    onPrimary = Color(dark1);
    background = Color(JET_BLACK_DARK);
    errorColor = Color(ERROR);
    currentMode = 'dark';
    print("DarkMode");
    notifyListeners();
  }

  void setLightMode() {
    primaryColor = Color(CG_BLUE_HEX);
    secondaryColor = Color(YELLOW_GREEN);
    primaryTextColor = Color(JET_BLACK);
    secondaryTextColor = Color(SILVER_CHALICE);
    tertiaryTextColor = Color(PLATINUM_DARK);
    onPrimary = Color(MAGNOLIA);
    background = Color(PLATINUM_LIGHT);
    errorColor = Color(ERROR);
    currentMode = 'light';
    print("LightMode");

    notifyListeners();
  }
}

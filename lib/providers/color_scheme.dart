import '../themes/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomColorScheme with ChangeNotifier {
  Color primaryColor = Color(CG_BLUE_HEX);
  Color secondaryColor = Color(YELLOW_GREEN);
  Color primaryTextColor = Color(PLATINUM);
  Color secondaryTextColor = Color(SILVER_CHALICE);
  Color tertiaryTextColor = Color(PLATINUM_DARK);
  Color onPrimary = Color(dark1);
  Color background = Color(JET_BLACK_DARK);
  Color errorColor = Color(ERROR);
  String currentMode = 'dark';

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
    notifyListeners();
  }
}

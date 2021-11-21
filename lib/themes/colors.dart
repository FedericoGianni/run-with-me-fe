import 'package:flutter/material.dart';

const YELLOW_GREEN_HEX = "A2D729";
const SMOTHLY_BLACK_HEX = "191516";
const CG_BLUE_HEX = "227C9D";
const PERIWINKLE_CRAYOLA = "C5D1EB";
const PURPLE_HEX = "5603AD";

int _getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return int.parse(hexColor, radix: 16);
}

class CustomColorScheme {
  static ColorScheme get lightColorScheme {
    return ColorScheme(
      //primary: Color(0XC5D1EB),
      primary: Color(_getColorFromHex(YELLOW_GREEN_HEX)),
      primaryVariant: Color(_getColorFromHex(PURPLE_HEX)),
      secondary: Color(_getColorFromHex(CG_BLUE_HEX)),
      secondaryVariant: Color(_getColorFromHex(PURPLE_HEX)),
      surface: Color(_getColorFromHex(PERIWINKLE_CRAYOLA)),
      background: Color(_getColorFromHex(PERIWINKLE_CRAYOLA)),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.purple,
      onSurface: Colors.purple,
      onBackground: Colors.purple,
      onError: Colors.purple,
      brightness: Brightness.light,
    );
  }
}

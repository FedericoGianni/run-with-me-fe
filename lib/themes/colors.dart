import 'package:flutter/material.dart';

// const YELLOW_GREEN_HEX = "A2D729";
// const SMOTHLY_BLACK_HEX = "191516";
// const CG_BLUE_HEX = "227C9D";
// const PERIWINKLE_CRAYOLA = "C5D1EB";
// const PURPLE_HEX = "5603AD";

const YELLOW_GREEN_DARK = "759B1C";
const YELLOW_GREEN = "9CCF26";
const YELLOW_GREEN_LIGHT = "B7E057";

const JET_BLACK_DARK = "262626";
const JET_BLACK = "333333";
const JET_BLACK_LIGHT = "666666";

const CG_BLUE_HEX_DARK = "1C637D";
const CG_BLUE_HEX = "2584A7";
const CG_BLUE_HEX_LIGHT = "43AFD6";

const SILVER_CHALICE_DARK = "808080";
const SILVER_CHALICE = "AAAAAA";
const SILVER_CHALICE_LIGHT = "C0C0C0";

const PLATINUM_DARK = "B0B0B0";
const PLATINUM = "EBEBEB";
const PLATINUM_LIGHT = "F0F0F0";

const MAGNOLIA = "FFFAFF";
const MAGNOLIA_LIGHT = "FFFBFF";

const ERROR = "CE2525";

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
      primary: Color(_getColorFromHex(CG_BLUE_HEX)),
      primaryVariant: Color(_getColorFromHex(CG_BLUE_HEX_DARK)),
      secondary: Color(_getColorFromHex(YELLOW_GREEN)),
      secondaryVariant: Color(_getColorFromHex(YELLOW_GREEN_DARK)),
      surface: Color(_getColorFromHex(MAGNOLIA_LIGHT)),
      background: Color(_getColorFromHex(PLATINUM)),
      error: Color(_getColorFromHex(ERROR)),
      onPrimary: Color(_getColorFromHex(MAGNOLIA_LIGHT)),
      onSecondary: Color(_getColorFromHex(MAGNOLIA_LIGHT)),
      onSurface: Color(_getColorFromHex(PLATINUM)),
      onBackground: Color(_getColorFromHex(PLATINUM)),
      onError: Color(_getColorFromHex(MAGNOLIA_LIGHT)),
      brightness: Brightness.light,
    );
  }
}

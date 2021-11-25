import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        colorScheme: CustomColorScheme.lightColorScheme,
        scaffoldBackgroundColor: const Color(PLATINUM),
        //fontFamily: 'Montserrat',
        primaryColor: const Color(CG_BLUE_HEX),
        unselectedWidgetColor: const Color(SILVER_CHALICE),
        backgroundColor: const Color(MAGNOLIA),
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purpleAccent,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        //fontFamily: 'Montserrat',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purpleAccent,
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:http/browser_client.dart';

import 'custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        // textTheme: GoogleFonts.robotoTextTheme(),
        // colorScheme: CustomColorScheme.lightColorScheme,
        scaffoldBackgroundColor: const Color(PLATINUM),
        //fontFamily: 'Montserrat',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
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
        // textTheme: GoogleFonts.robotoTextTheme(),
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        //fontFamily: 'Montserrat',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purpleAccent,
        ));
  }

  static ThemeData get noTheme {
    return ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        // primaryColor: const Color(CG_BLUE_HEX),
        scaffoldBackgroundColor: Colors.purple,
        colorScheme: const ColorScheme(
          secondary: Colors.purple,
          primary: Color(CG_BLUE_HEX),
          primaryVariant: Colors.purple,
          secondaryVariant: Colors.purple,
          onPrimary: Colors.purple,
          onSecondary: Colors.purple,
          onSurface: Colors.purple,
          onError: Colors.purple,
          onBackground: Color(CG_BLUE_HEX),
          error: Colors.purple,
          brightness: Brightness.dark,
          background: Color(CG_BLUE_HEX),
          surface: Colors.purple,
        ),
        //fontFamily: 'Montserrat',
        buttonTheme: ButtonThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purple,
        ));
  }
}

InputDecoration textFormDecoration(String label, ctx) {
  final colors = Provider.of<CustomColorScheme>(ctx);

  return InputDecoration(
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    floatingLabelStyle: TextStyle(color: colors.primaryColor),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.errorColor),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.errorColor),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    labelStyle: TextStyle(color: colors.secondaryTextColor),
    fillColor: colors.onPrimary,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.secondaryTextColor),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.secondaryTextColor),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}

InputDecoration passwordFormDecoration(
    String label, Icon icon, toggleFunction, ctx) {
  final colors = Provider.of<CustomColorScheme>(ctx);

  return InputDecoration(
    suffixIcon: GestureDetector(
        child: icon,
        onTap: () {
          toggleFunction();
        }),
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    floatingLabelStyle: TextStyle(color: colors.primaryColor),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.errorColor),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.errorColor),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    labelStyle: TextStyle(color: colors.secondaryTextColor),
    fillColor: colors.onPrimary,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.secondaryTextColor),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.secondaryTextColor),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
}

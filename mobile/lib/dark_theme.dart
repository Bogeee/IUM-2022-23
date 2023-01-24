import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const darkSecondaryColor = Color(0xFF2A2D3E);
const darkBgColor = Color(0xFF212332);
const darkSnackBarBgColor = Color(0xFF2E3144);
Color darkAccentColor  = const Color(0xFF31EDB9);
TextTheme darkTextTheme = ThemeData.dark().textTheme;

final darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF2697FF),
    secondary: Color(0xFF2A2D3E),
    background: Color(0xFF212332)
  ),
  scaffoldBackgroundColor: darkBgColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xff1d1e2c),
    unselectedItemColor: const Color(0xff0F172A),
    selectedItemColor: darkAccentColor,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(darkTextTheme)
                        .apply(bodyColor: Colors.white),
  canvasColor: darkSecondaryColor,
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: darkSnackBarBgColor,
    contentTextStyle: TextStyle(
      color: Colors.white
    ),
  ),
  dialogBackgroundColor: darkBgColor,
  timePickerTheme: TimePickerThemeData(
    backgroundColor: darkBgColor,
    dialHandColor: darkAccentColor,
  )
);


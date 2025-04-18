import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const lightSecondaryColor = Color.fromARGB(255, 221, 221, 221);
const lightBgColor = Color(0xFFFFFFFF);
const lightSnackBarBgColor = Color(0xFFF3F3F3);
Color lightAccentColor = const Color(0xFFAD1052);
TextTheme lightTextTheme = ThemeData.light().textTheme;

final lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2697FF),
    secondary: Color.fromARGB(255, 221, 221, 221),
    background: lightBgColor
  ),
  scaffoldBackgroundColor: lightBgColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xfff0f0f0),
    unselectedItemColor: const Color(0xff0F172A),
    selectedItemColor: lightAccentColor,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(lightTextTheme)
      .apply(bodyColor: Colors.black),
  canvasColor: lightSecondaryColor, 
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: lightSnackBarBgColor,
    contentTextStyle: TextStyle(color: Colors.black),
  ),
  dialogBackgroundColor: lightBgColor,
  timePickerTheme: TimePickerThemeData(
    backgroundColor: lightBgColor,
    dialHandColor: lightAccentColor,
  )
);

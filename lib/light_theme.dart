import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const lightSecondaryColor = Color.fromARGB(255, 221, 221, 221);
const lightBgColor = Color(0xFFFFFFFF);
const lightSnackBarBgColor = Color(0xFFF3F3F3);
TextTheme lightTextTheme = ThemeData.light().textTheme;

final lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2697FF),
    secondary: Color.fromARGB(255, 221, 221, 221),
    background: lightBgColor
  ),
  scaffoldBackgroundColor: lightBgColor,
  textTheme: GoogleFonts.poppinsTextTheme(lightTextTheme)
      .apply(bodyColor: Colors.black),
  canvasColor: lightSecondaryColor, 
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: lightSnackBarBgColor,
    contentTextStyle: TextStyle(color: Colors.black),
  )
);

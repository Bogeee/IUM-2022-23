import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proj/models/login_info.dart';

// models
import 'package:proj/models/user.dart';

// FIXME: create two files to separate the notifiers

// Light Theme main colors
Color lightThemeAccentColor = const Color(0xFFAD1052);
Color lightThemeShadeColor =const Color(0x24FE7163);

// Dark Theme main colors
Color darkThemeAccentColor  = const Color(0xFF31EDB9);
Color darkThemeShadeColor = const Color(0x24FEC863);

const String fileName = "theme.json";

class ThemeNotifier with ChangeNotifier {
  bool _isDark = false;
  Color _accentColor = lightThemeAccentColor;
  Color _shadeColor = lightThemeShadeColor;

  ThemeNotifier();

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    if (_isDark) {
      _accentColor = darkThemeAccentColor;
      _shadeColor = darkThemeShadeColor;
    } else {
      _accentColor = lightThemeAccentColor;
      _shadeColor = lightThemeShadeColor;
    }
    notifyListeners();
  }

  Color get accentColor => _accentColor;
  Color get shadeColor => _shadeColor;

  // TODO: Will fix in the future if we have time
  // static Future<bool> getTheme() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final path = directory.path;
  //     final file = File('$path/$fileName');

  //     if (await file.exists() == false) {
  //       return false;
  //     }

  //     String darkTheme = await file.readAsString();
  //     return darkTheme.isEmpty ? false : darkTheme as bool;
  //   } catch (e) {
  //     // IOException
  //     return false;
  //   }
  // }

  // Future<File> setTheme(bool darkTheme) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = directory.path;
  //   final file = File('$path/$fileName');

  //   return file.writeAsString(darkTheme.toString());
  // }
}

class LoggedInNotifier with ChangeNotifier {
  late User? _user;
  bool _isSaved = false;

  LoggedInNotifier(){
    _isSaved = false;
  }

  int get userId => _user!.id;

  bool get isAdmin => _user!.isAdmin;

  User get userDetails => _user!; 

  set user(User? loggedIn) {
    _user = loggedIn;
  }

  bool get isSaved => _isSaved;

  set saved(bool saved) {
    _isSaved = saved;
  }
}
import 'package:flutter/material.dart';
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

//TODO: Maybe we need to access shared preferences for the theme data
class ThemeNotifier with ChangeNotifier {
  bool _isDark = false;
  Color _accentColor = lightThemeAccentColor;
  Color _shadeColor = lightThemeShadeColor;

  ThemeNotifier(bool isDark){
    _isDark = isDark;
    if(isDark){
      _accentColor = darkThemeAccentColor;
      _shadeColor = darkThemeShadeColor;
    } else {
      _accentColor = lightThemeAccentColor;
      _shadeColor = lightThemeShadeColor;
    }
  }

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  Color get accentColor => _accentColor;
  Color get shadeColor => _shadeColor;
}

class LoggedInNotifier with ChangeNotifier {
  late User? _user;
  bool _isSaved = false;

  LoggedInNotifier(){
    _isSaved = false;
  }

  int get userId => _user!.id;

  bool get isAdmin => _user!.isAdmin;

  set user(User? loggedIn) {
    _user = loggedIn;
  }

  bool get isSaved => _isSaved;

  set saved(bool saved) {
    _isSaved = saved;
  }
}
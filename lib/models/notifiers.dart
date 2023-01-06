import 'package:flutter/material.dart';


//TODO: Maybe we need to access shared preferences for the theme data
class ThemeNotifier with ChangeNotifier {
  bool _isDark;

  ThemeNotifier(this._isDark);

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    notifyListeners();
  }
}

class LoggedInNotifier with ChangeNotifier {
  String _file_name;
  late int _userID;
  late bool _isAdmin;
  late String _password;

  LoggedInNotifier(this._file_name){
    //TODO: implement the access to local storage to get saved user data
    _userID = 0;
    _password = "";
    _isAdmin = false;
  }

  int get userId => _userID;

  bool get isAdmin => _isAdmin;

  set isAdmin(bool value) {
    _isAdmin = value;
    notifyListeners();
  }
}
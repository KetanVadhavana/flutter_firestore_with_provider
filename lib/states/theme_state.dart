import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState with ChangeNotifier {
  static final savedThemeKey = "saved_theme";

  SharedPreferences preferences;

  ThemeData _darkTheme = ThemeData(
//    accentColor: Colors.blueGrey,
    brightness: Brightness.dark,
//    buttonTheme: ButtonThemeData(
//      buttonColor: Colors.blue
//    )
  );
  ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.grey[200],
  );

  bool _isDark = false;

  ThemeData get appTheme {
    print('Current theme [Dark: $_isDark]');

    return _isDark ? _darkTheme : _lightTheme;
  }

  bool get isDark => _isDark;

  set setTheme(bool dark) {
    _isDark = dark;
    notifyListeners();
    _savePreference(dark);
  }

  ThemeState(this.preferences) {
    _readPreference();
  }

  ///Save current theme selection to preference
  void _savePreference(value) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(savedThemeKey, value);
  }

  ///Read default value from preference
  void _readPreference() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
    _isDark = preferences.getBool(savedThemeKey) ?? false;
//    notifyListeners();
  }
}

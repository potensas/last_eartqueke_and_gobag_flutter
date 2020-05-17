import 'package:flutter/material.dart';
import 'package:last_earthquake_flutter/constants/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  Future<void> saveData(isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }

  Future<bool> loadData([bool setUponLading = false]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (setUponLading) {
      setTheme(prefs.getBool('darkMode') ?? false);
      return true;
    } else
      return prefs.getBool('darkMode') ?? false;
  }

  getTheme() => _themeData;

  setTheme(bool isDarkMode) {
    if (isDarkMode)
      _themeData = darkTheme;
    else
      _themeData = lightTheme;

    notifyListeners();

    saveData(isDarkMode);
  }
}

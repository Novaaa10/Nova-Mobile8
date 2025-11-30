import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  String _userName = 'Pengguna';
  String get userName => _userName;

  static const String _themekey = 'theme_key';
  static const String _userkey = 'user_key';

  Future<void> initSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool(_themekey) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    _userName = prefs.getString(_userkey) ?? 'Pengguna';

    notifyListeners();
  }

  void toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themekey, isOn);
  }

  void setUserName(String name) async {
    if (_userName != name) {
      _userName = name;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_userkey, name);
    }
  }
}
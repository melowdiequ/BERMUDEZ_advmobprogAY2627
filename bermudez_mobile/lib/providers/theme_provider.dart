import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    loadThemePreference();
  }

  // Loads the saved theme preference when the application starts.
  Future<void> loadThemePreference() async {
    final prefs =
        await SharedPreferences.getInstance();

    _isDarkMode =
        prefs.getBool('isDarkMode') ?? false;

    notifyListeners();
  }

  // Updates the application theme and saves the selected preference.
  Future<void> setDarkMode(
    bool value,
  ) async {
    if (_isDarkMode == value) {
      return;
    }

    _isDarkMode = value;

    notifyListeners();

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'isDarkMode',
      value,
    );
  }
}
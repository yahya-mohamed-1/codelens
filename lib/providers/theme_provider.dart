import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.blue;

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void setAccentColor(Color color) {
    if (_accentColor != color) {
      _accentColor = color;
      notifyListeners();
    }
  }
}

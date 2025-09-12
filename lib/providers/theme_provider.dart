import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.blue;
  bool _isLoaded = false;

  ThemeProvider() {
    _loadFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  bool get isLoaded => _isLoaded;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', mode.toString());
    }
  }

  Future<void> setAccentColor(Color color) async {
    if (_accentColor != color) {
      _accentColor = color;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('accentColor', color.value);
    }
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // Load theme mode
    final themeModeString = prefs.getString('themeMode');
    if (themeModeString != null) {
      if (themeModeString == ThemeMode.light.toString()) {
        _themeMode = ThemeMode.light;
      } else if (themeModeString == ThemeMode.dark.toString()) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    }
    // Load accent color
    final colorValue = prefs.getInt('accentColor');
    if (colorValue != null) {
      _accentColor = Color(colorValue);
    }
    _isLoaded = true;
    notifyListeners();
  }
}

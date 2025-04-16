import "dart:ui";

import "package:flutter/material.dart";
import "package:coinhub/core/constants/theme.dart";

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> _loadThemeMode() async {
    _themeMode = await AppTheme.getThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await AppTheme.saveThemeMode(mode);
    notifyListeners();
  }

  ThemeData getTheme() {
    return isDarkMode ? AppTheme.darkTheme() : AppTheme.lightTheme();
  }
}

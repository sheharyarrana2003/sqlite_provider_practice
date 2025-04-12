import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  static const Color _lightPrimary = Color(0xFF4361EE);
  static const Color _lightSecondary = Color(0xFF3F37C9);
  static const Color _lightBackground = Color(0xFFF8F9FA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightError = Color(0xFFE63946);

  static const Color _darkPrimary = Color(0xFF4895EF);
  static const Color _darkSecondary = Color(0xFF4CC9F0);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkError = Color(0xFFF72585);

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Color getPrimaryColor() => isDarkMode ? _darkPrimary : _lightPrimary;
  Color getSecondaryColor() => isDarkMode ? _darkSecondary : _lightSecondary;
  Color getBackgroundColor() => isDarkMode ? _darkBackground : _lightBackground;
  Color getSurfaceColor() => isDarkMode ? _darkSurface : _lightSurface;
  Color getErrorColor() => isDarkMode ? _darkError : _lightError;
  Color getTextColor()=>isDarkMode ? _lightSurface : _darkBackground;
}
// providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const String _themeKey = 'theme_mode';
  
  ThemeProvider() {
    _loadThemeFromPreferences();
  }

  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode {
    return _themeMode == ThemeMode.dark;
  }

  bool get isLightMode {
    return _themeMode == ThemeMode.light;
  }

  bool get isSystemMode {
    return _themeMode == ThemeMode.system;
  }

  // Ganti ke mode terang
  void setLightMode() {
    _themeMode = ThemeMode.light;
    _saveThemeToPreferences();
    notifyListeners();
  }

  // Ganti ke mode gelap
  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    _saveThemeToPreferences();
    notifyListeners();
  }

  // Ganti ke mode sistem (mengikuti sistem)
  void setSystemMode() {
    _themeMode = ThemeMode.system;
    _saveThemeToPreferences();
    notifyListeners();
  }

  // Toggle antara light dan dark (abaikan system)
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setDarkMode();
    } else if (_themeMode == ThemeMode.dark) {
      setLightMode();
    } else {
      // Jika sistem, default ke light
      setLightMode();
    }
  }

  // Simpan preferensi tema ke SharedPreferences
  Future<void> _saveThemeToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String modeString = _themeMode.toString();
      await prefs.setString(_themeKey, modeString);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  // Muat preferensi tema dari SharedPreferences
  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? modeString = prefs.getString(_themeKey);
      
      if (modeString != null) {
        // Parse ThemeMode dari string
        if (modeString == 'ThemeMode.light') {
          _themeMode = ThemeMode.light;
        } else if (modeString == 'ThemeMode.dark') {
          _themeMode = ThemeMode.dark;
        } else if (modeString == 'ThemeMode.system') {
          _themeMode = ThemeMode.system;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }
}

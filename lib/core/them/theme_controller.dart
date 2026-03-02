import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeMode get themeMode =>
      _isDark ? ThemeMode.dark : ThemeMode.light;

  /// تحميل الثيم من التخزين
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _isDark = prefs.getBool("darkMode") ?? false;

    notifyListeners();
  }

  /// تغيير الثيم وحفظه
  Future<void> toggleTheme(bool value) async {
    _isDark = value;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("darkMode", value);

    notifyListeners();
  }
}

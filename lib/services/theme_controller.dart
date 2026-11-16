import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  ThemeController() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('themeMode');
      if (saved == 'dark') _mode = ThemeMode.dark;
      if (saved == 'light') _mode = ThemeMode.light;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggle(bool isDarkNow) async {
    _mode = isDarkNow ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', isDarkNow ? 'light' : 'dark');
    } catch (_) {}
  }
}

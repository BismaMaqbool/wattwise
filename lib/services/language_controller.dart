import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends ChangeNotifier {
  static bool isUrdu = false;

  LanguageController() {
    _load();
  }

  Locale get locale => isUrdu ? const Locale('ur') : const Locale('en');

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isUrdu = prefs.getString('language') == 'ur';
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggle() async {
    isUrdu = !isUrdu;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', isUrdu ? 'ur' : 'en');
    } catch (_) {}
  }
}

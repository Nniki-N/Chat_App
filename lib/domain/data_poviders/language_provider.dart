import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider {
  final languageConst = 'language';

  Future<void> changeLanguage({required String languageCode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageConst, languageCode);
  }

  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageConst);
  }
}

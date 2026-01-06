import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  Locale? locale;
  static Map<String, dynamic>? _localisedValues;
  static Map<String, dynamic>? _fallbackValues;

  AppTranslations(Locale locale) {
    this.locale = locale;
  }

  static AppTranslations? of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  /// Loads the requested locale file and a fallback English file.
  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);

    final code = locale.languageCode;
    try {
      String jsonContent =
          await rootBundle.loadString('assets/locales/i18n_$code.json');
      final decoded = json.decode(jsonContent);
      if (decoded is Map<String, dynamic>) {
        _localisedValues = decoded;
      } else {
        _localisedValues = Map<String, dynamic>.from(decoded as Map);
      }
    } catch (e) {
      // If loading current locale fails, keep an empty map and rely on fallback
      _localisedValues = <String, dynamic>{};
    }

    // Load English fallback (silent on error)
    try {
      String enContent =
          await rootBundle.loadString('assets/locales/i18n_en.json');
      final decodedEn = json.decode(enContent);
      if (decodedEn is Map<String, dynamic>) {
        _fallbackValues = decodedEn;
      } else {
        _fallbackValues = Map<String, dynamic>.from(decodedEn as Map);
      }
    } catch (e) {
      _fallbackValues = <String, dynamic>{};
    }

    return appTranslations;
  }

  get currentLanguage => locale?.languageCode;

  String text(String key) {
    // Prefer current locale
    if (_localisedValues != null && _localisedValues!.containsKey(key)) {
      final v = _localisedValues![key];
      return v == null ? '' : v.toString();
    }

    // Fallback to English
    if (_fallbackValues != null && _fallbackValues!.containsKey(key)) {
      final v = _fallbackValues![key];
      return v == null ? '' : v.toString();
    }

    // Last resort: humanize the key so UI shows readable text instead of "key not found"
    final human = key.replaceAll(RegExp(r'[._]'), ' ');
    // Capitalize first letter for English-looking keys
    if ((locale?.languageCode ?? 'en') == 'en' && human.isNotEmpty) {
      return human[0].toUpperCase() + human.substring(1);
    }
    return human;
  }

  bool get isEnLocale => locale?.languageCode == 'en';
  bool get isArLocale => locale?.languageCode == 'ar';
}

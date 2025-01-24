import 'dart:convert';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  // Method to load the JSON file
  Future<bool> load(BuildContext context) async {
    try {
      final String jsonString = await DefaultAssetBundle.of(context).loadString(
        'lib/l10n/${locale.languageCode}.json',
      );
      _localizedStrings = Map<String, String>.from(jsonDecode(jsonString));
      return true;
    } catch (e) {
      debugPrint("Localization load error: $e");
      _localizedStrings = {};
      return false;
    }
  }

  // Translate method
  String translate(String key) => _localizedStrings[key] ?? key;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'th'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    // Context is provided at runtime, and load() will use it correctly.
    // If you need context here, ensure to pass it down from MaterialApp.
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

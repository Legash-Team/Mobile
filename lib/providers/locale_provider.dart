import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'om';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const DefaultMaterialLocalizations();
  }

  @override
  bool shouldReload(FallbackMaterialLocalizationsDelegate old) => false;
}

class FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'om';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    return const DefaultCupertinoLocalizations();
  }

  @override
  bool shouldReload(FallbackCupertinoLocalizationsDelegate old) => false;
}

class LocaleProvider extends ChangeNotifier {
  static const String localePrefKey = 'preferred_locale';

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('am'),
    Locale('om'),
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'am': 'አማርኛ',
    'om': 'Afaan Oromoo',
  };

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    FallbackMaterialLocalizationsDelegate(),
    FallbackCupertinoLocalizationsDelegate(),
  ];

  Locale _locale = const Locale('en');

  LocaleProvider([String? initialCode]) {
    if (initialCode != null && isSupported(initialCode)) {
      _locale = Locale(initialCode);
    } else {
      _loadLocale();
    }
  }

  Locale get locale => _locale;

  static bool isSupported(String code) {
    return supportedLocales.any((l) => l.languageCode == code);
  }

  static String getLanguageName(String code) {
    return languageNames[code] ?? code;
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(localePrefKey);
      if (code != null && isSupported(code) && code != _locale.languageCode) {
        _locale = Locale(code);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[LocaleProvider] Failed to load locale: $e');
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (!isSupported(newLocale.languageCode)) return;
    if (_locale.languageCode == newLocale.languageCode) return;

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(localePrefKey, newLocale.languageCode);
    } catch (e) {
      debugPrint('[LocaleProvider] Failed to persist locale: $e');
    }
  }

  static Future<String?> getSavedLocaleCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(localePrefKey);
    } catch (e) {
      debugPrint('[LocaleProvider] Failed to get saved locale code: $e');
      return null;
    }
  }
}

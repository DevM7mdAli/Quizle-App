import 'package:flutter/material.dart';

enum AppLocalePreference {
  system,
  english,
  arabic;

  Locale? get locale {
    return switch (this) {
      AppLocalePreference.system => null,
      AppLocalePreference.english => const Locale('en'),
      AppLocalePreference.arabic => const Locale('ar'),
    };
  }
}

class AppSettings {
  const AppSettings({required this.locale, required this.themeMode});

  const AppSettings.defaults()
    : locale = AppLocalePreference.system,
      themeMode = ThemeMode.system;

  final AppLocalePreference locale;
  final ThemeMode themeMode;

  AppSettings copyWith({AppLocalePreference? locale, ThemeMode? themeMode}) {
    return AppSettings(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

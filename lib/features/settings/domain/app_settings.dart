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
  const AppSettings({
    required this.locale,
    required this.themeMode,
    this.dailyReminderEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
  });

  const AppSettings.defaults()
    : locale = AppLocalePreference.system,
      themeMode = ThemeMode.system,
      dailyReminderEnabled = false,
      reminderHour = 20,
      reminderMinute = 0;

  final AppLocalePreference locale;
  final ThemeMode themeMode;
  final bool dailyReminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  AppSettings copyWith({
    AppLocalePreference? locale,
    ThemeMode? themeMode,
    bool? dailyReminderEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}

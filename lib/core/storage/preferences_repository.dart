import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/settings/domain/app_settings.dart';

abstract interface class PreferencesRepository {
  Future<AppSettings> loadSettings();

  Future<void> saveLocale(AppLocalePreference locale);

  Future<void> saveReminder({
    required bool enabled,
    required int hour,
    required int minute,
  });

  Future<void> saveThemeMode(ThemeMode themeMode);
}

class SharedPreferencesRepository implements PreferencesRepository {
  SharedPreferencesRepository(this._preferences);

  static const _localeKey = 'settings.locale';
  static const _reminderEnabledKey = 'settings.reminder.enabled';
  static const _reminderHourKey = 'settings.reminder.hour';
  static const _reminderMinuteKey = 'settings.reminder.minute';
  static const _themeKey = 'settings.theme';

  final SharedPreferencesAsync _preferences;

  @override
  Future<AppSettings> loadSettings() async {
    final localeName = await _preferences.getString(_localeKey);
    final themeName = await _preferences.getString(_themeKey);
    final reminderEnabled =
        await _preferences.getBool(_reminderEnabledKey) ?? false;
    final reminderHour = await _preferences.getInt(_reminderHourKey) ?? 20;
    final reminderMinute = await _preferences.getInt(_reminderMinuteKey) ?? 0;

    return AppSettings(
      locale: _localeFromName(localeName),
      themeMode: _themeFromName(themeName),
      dailyReminderEnabled: reminderEnabled,
      reminderHour: reminderHour.clamp(0, 23),
      reminderMinute: reminderMinute.clamp(0, 59),
    );
  }

  @override
  Future<void> saveLocale(AppLocalePreference locale) {
    return _preferences.setString(_localeKey, locale.name);
  }

  @override
  Future<void> saveReminder({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    await _preferences.setBool(_reminderEnabledKey, enabled);
    await _preferences.setInt(_reminderHourKey, hour);
    await _preferences.setInt(_reminderMinuteKey, minute);
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) {
    return _preferences.setString(_themeKey, themeMode.name);
  }

  AppLocalePreference _localeFromName(String? name) {
    return AppLocalePreference.values.firstWhere(
      (locale) => locale.name == name,
      orElse: () => AppLocalePreference.system,
    );
  }

  ThemeMode _themeFromName(String? name) {
    return ThemeMode.values.firstWhere(
      (theme) => theme.name == name,
      orElse: () => ThemeMode.system,
    );
  }
}

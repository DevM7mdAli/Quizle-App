import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/settings/domain/app_settings.dart';

abstract interface class PreferencesRepository {
  Future<int?> getBestScore(String quizId);

  Future<AppSettings> loadSettings();

  Future<void> saveBestScore(String quizId, int score);

  Future<void> saveLocale(AppLocalePreference locale);

  Future<void> saveThemeMode(ThemeMode themeMode);
}

class SharedPreferencesRepository implements PreferencesRepository {
  SharedPreferencesRepository(this._preferences);

  static const _localeKey = 'settings.locale';
  static const _themeKey = 'settings.theme';

  final SharedPreferencesAsync _preferences;

  @override
  Future<int?> getBestScore(String quizId) {
    return _preferences.getInt(_bestScoreKey(quizId));
  }

  @override
  Future<AppSettings> loadSettings() async {
    final localeName = await _preferences.getString(_localeKey);
    final themeName = await _preferences.getString(_themeKey);

    return AppSettings(
      locale: _localeFromName(localeName),
      themeMode: _themeFromName(themeName),
    );
  }

  @override
  Future<void> saveBestScore(String quizId, int score) async {
    final currentBest = await getBestScore(quizId);
    if (currentBest == null || score > currentBest) {
      await _preferences.setInt(_bestScoreKey(quizId), score);
    }
  }

  @override
  Future<void> saveLocale(AppLocalePreference locale) {
    return _preferences.setString(_localeKey, locale.name);
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) {
    return _preferences.setString(_themeKey, themeMode.name);
  }

  String _bestScoreKey(String quizId) => 'progress.$quizId.bestScore';

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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/preferences_repository.dart';
import '../domain/app_settings.dart';

final initialSettingsProvider = Provider<AppSettings>(
  (ref) => const AppSettings.defaults(),
);

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => SharedPreferencesRepository(SharedPreferencesAsync()),
);

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(initialSettingsProvider);

  Future<void> setLocale(AppLocalePreference locale) async {
    if (locale == state.locale) {
      return;
    }
    state = state.copyWith(locale: locale);
    await ref.read(preferencesRepositoryProvider).saveLocale(locale);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (themeMode == state.themeMode) {
      return;
    }
    state = state.copyWith(themeMode: themeMode);
    await ref.read(preferencesRepositoryProvider).saveThemeMode(themeMode);
  }
}

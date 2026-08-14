import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../core/notifications/notification_service_stub.dart';
import '../../../core/storage/preferences_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/app_settings.dart';

final initialSettingsProvider = Provider<AppSettings>(
  (ref) => const AppSettings.defaults(),
);

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => SharedPreferencesRepository(SharedPreferencesAsync()),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => const UnsupportedNotificationService(),
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
    if (state.dailyReminderEnabled) {
      await _scheduleReminder(state);
    }
  }

  Future<bool> setReminderEnabled(bool enabled) async {
    if (enabled == state.dailyReminderEnabled) {
      return true;
    }

    final service = ref.read(notificationServiceProvider);
    if (enabled) {
      if (!service.supportsScheduledReminders ||
          !await service.requestPermission()) {
        return false;
      }
    }

    state = state.copyWith(dailyReminderEnabled: enabled);
    await ref
        .read(preferencesRepositoryProvider)
        .saveReminder(
          enabled: enabled,
          hour: state.reminderHour,
          minute: state.reminderMinute,
        );
    if (enabled) {
      await _scheduleReminder(state);
    } else {
      await service.cancelDailyReminder();
    }
    return true;
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    state = state.copyWith(
      reminderHour: time.hour,
      reminderMinute: time.minute,
    );
    await ref
        .read(preferencesRepositoryProvider)
        .saveReminder(
          enabled: state.dailyReminderEnabled,
          hour: time.hour,
          minute: time.minute,
        );
    if (state.dailyReminderEnabled) {
      await _scheduleReminder(state);
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (themeMode == state.themeMode) {
      return;
    }
    state = state.copyWith(themeMode: themeMode);
    await ref.read(preferencesRepositoryProvider).saveThemeMode(themeMode);
  }

  Future<void> _scheduleReminder(AppSettings settings) async {
    final requestedLocale = settings.locale.locale;
    final deviceLocale = PlatformDispatcher.instance.locale;
    final locale = requestedLocale ?? Locale(deviceLocale.languageCode);
    final l10n = lookupAppLocalizations(locale);
    await ref
        .read(notificationServiceProvider)
        .scheduleDailyReminder(
          hour: settings.reminderHour,
          minute: settings.reminderMinute,
          title: l10n.dailyReminderTitle,
          body: l10n.dailyReminderBody,
        );
  }
}

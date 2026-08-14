import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/notifications/notification_service.dart';
import 'core/notifications/notification_service_factory.dart';
import 'core/notifications/notification_service_stub.dart'
    show UnsupportedNotificationService;
import 'core/storage/preferences_repository.dart';
import 'features/progress/application/learning_controller.dart';
import 'features/progress/data/learning_repository.dart';
import 'features/settings/application/settings_controller.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = SharedPreferencesAsync();
  final preferencesRepository = SharedPreferencesRepository(preferences);
  final learningRepository = SharedPreferencesLearningRepository(preferences);
  final initialSettings = await preferencesRepository.loadSettings();
  final initialLearningData = await learningRepository.load();
  NotificationService notificationService = createNotificationService();
  try {
    await notificationService.initialize();
    if (initialSettings.dailyReminderEnabled &&
        notificationService.supportsScheduledReminders) {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final locale = initialSettings.locale.locale ?? deviceLocale;
      final l10n = lookupAppLocalizations(Locale(locale.languageCode));
      await notificationService.scheduleDailyReminder(
        hour: initialSettings.reminderHour,
        minute: initialSettings.reminderMinute,
        title: l10n.dailyReminderTitle,
        body: l10n.dailyReminderBody,
      );
    }
  } on Object {
    notificationService = const UnsupportedNotificationService();
  }

  runApp(
    ProviderScope(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(preferencesRepository),
        initialSettingsProvider.overrideWithValue(initialSettings),
        learningRepositoryProvider.overrideWithValue(learningRepository),
        initialLearningDataProvider.overrideWithValue(initialLearningData),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const QuizleApp(),
    ),
  );
}

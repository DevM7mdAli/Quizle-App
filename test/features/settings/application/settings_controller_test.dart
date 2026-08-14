import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quizle/features/settings/application/settings_controller.dart';

import '../../../support/fakes.dart';

void main() {
  test('enables and reschedules the local daily reminder', () async {
    final preferences = MemoryPreferencesRepository();
    final notifications = FakeNotificationService();
    final container = ProviderContainer(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(preferences),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(settingsControllerProvider.notifier);

    expect(await controller.setReminderEnabled(true), isTrue);
    expect(preferences.settings.dailyReminderEnabled, isTrue);
    expect(notifications.scheduledHour, 20);
    expect(notifications.scheduledMinute, 0);

    await controller.setReminderTime(const TimeOfDay(hour: 8, minute: 30));

    expect(preferences.settings.reminderHour, 8);
    expect(preferences.settings.reminderMinute, 30);
    expect(notifications.scheduledHour, 8);
    expect(notifications.scheduledMinute, 30);
  });

  test('keeps reminders disabled when permission is denied', () async {
    final preferences = MemoryPreferencesRepository();
    final notifications = FakeNotificationService()..permissionGranted = false;
    final container = ProviderContainer(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(preferences),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
    );
    addTearDown(container.dispose);

    final enabled = await container
        .read(settingsControllerProvider.notifier)
        .setReminderEnabled(true);

    expect(enabled, isFalse);
    expect(preferences.settings.dailyReminderEnabled, isFalse);
  });
}

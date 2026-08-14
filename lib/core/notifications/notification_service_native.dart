import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_10y.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import 'notification_service.dart';

NotificationService createNotificationService() {
  return NativeNotificationService();
}

class NativeNotificationService implements NotificationService {
  static const _reminderId = 1001;
  static const _channelId = 'daily_quiz_reminders';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  @override
  bool get supportsScheduledReminders {
    return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
  }

  @override
  Future<void> initialize() async {
    if (_initialized || !supportsScheduledReminders) {
      return;
    }

    timezone_data.initializeTimeZones();
    try {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      timezone.setLocalLocation(timezone.getLocation(localTimezone.identifier));
    } on Object {
      timezone.setLocalLocation(timezone.UTC);
    }

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    await initialize();
    if (Platform.isAndroid) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    if (Platform.isIOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    if (Platform.isMacOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await initialize();
    if (!supportsScheduledReminders) {
      return;
    }

    final now = timezone.TZDateTime.now(timezone.local);
    var scheduled = timezone.TZDateTime(
      timezone.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _reminderId,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Daily quiz reminders',
          channelDescription: 'A daily reminder to complete the Quizle quiz.',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelDailyReminder() async {
    if (!supportsScheduledReminders) {
      return;
    }
    await initialize();
    await _plugin.cancel(_reminderId);
  }
}

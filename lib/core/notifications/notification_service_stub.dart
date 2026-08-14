import 'notification_service.dart';

NotificationService createNotificationService() {
  return const UnsupportedNotificationService();
}

class UnsupportedNotificationService implements NotificationService {
  const UnsupportedNotificationService();

  @override
  bool get supportsScheduledReminders => false;

  @override
  Future<void> cancelDailyReminder() async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {}
}

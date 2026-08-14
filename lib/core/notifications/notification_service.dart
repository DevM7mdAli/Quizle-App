abstract interface class NotificationService {
  bool get supportsScheduledReminders;

  Future<void> initialize();

  Future<bool> requestPermission();

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  });

  Future<void> cancelDailyReminder();
}

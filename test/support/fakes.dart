import 'package:flutter/material.dart';

import 'package:quizle/core/notifications/notification_service.dart';
import 'package:quizle/core/storage/preferences_repository.dart';
import 'package:quizle/features/progress/data/learning_repository.dart';
import 'package:quizle/features/progress/domain/learning_models.dart';
import 'package:quizle/features/quiz/data/quiz_repository.dart';
import 'package:quizle/features/quiz/domain/quiz_models.dart';
import 'package:quizle/features/settings/domain/app_settings.dart';

class FakeQuizRepository implements QuizRepository {
  FakeQuizRepository(this.quizzes, {this.loadedQuiz});

  final List<Quiz> quizzes;
  final Quiz? loadedQuiz;

  @override
  Future<List<Quiz>> loadCatalog(Locale locale) async => quizzes;

  @override
  Future<Quiz?> loadDailyQuiz({
    required Locale locale,
    required DateTime date,
    required String title,
    required String description,
  }) async => null;

  @override
  Future<Quiz> loadQuiz(Quiz quiz, QuizConfiguration configuration) async {
    return loadedQuiz ?? quiz;
  }
}

class MemoryPreferencesRepository implements PreferencesRepository {
  AppSettings settings = const AppSettings.defaults();

  @override
  Future<AppSettings> loadSettings() async => settings;

  @override
  Future<void> saveLocale(AppLocalePreference locale) async {
    settings = settings.copyWith(locale: locale);
  }

  @override
  Future<void> saveReminder({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    settings = settings.copyWith(
      dailyReminderEnabled: enabled,
      reminderHour: hour,
      reminderMinute: minute,
    );
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    settings = settings.copyWith(themeMode: themeMode);
  }
}

class MemoryLearningRepository implements LearningRepository {
  LearningData data = const LearningData.empty();

  @override
  Future<LearningData> load() async => data;

  @override
  Future<void> saveAttempts(List<QuizAttempt> attempts) async {
    data = data.copyWith(attempts: List.unmodifiable(attempts));
  }

  @override
  Future<void> saveBookmarks(Set<String> questionIds) async {
    data = data.copyWith(bookmarkedQuestionIds: Set.unmodifiable(questionIds));
  }

  @override
  Future<void> saveQuestionBank(Map<String, QuizQuestion> questions) async {
    data = data.copyWith(questionBank: Map.unmodifiable(questions));
  }

  @override
  Future<void> saveSession(SavedQuizSession? session) async {
    data = session == null
        ? data.copyWith(clearSavedSession: true)
        : data.copyWith(savedSession: session);
  }
}

class FakeNotificationService implements NotificationService {
  bool permissionGranted = true;
  int? scheduledHour;
  int? scheduledMinute;
  bool wasCancelled = false;

  @override
  bool get supportsScheduledReminders => true;

  @override
  Future<void> cancelDailyReminder() async {
    wasCancelled = true;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    scheduledHour = hour;
    scheduledMinute = minute;
  }
}

Quiz buildTestQuiz() {
  return const Quiz(
    id: 'test_quiz',
    title: 'Test quiz',
    description: 'A focused test quiz.',
    questions: [
      QuizQuestion(
        id: 'question_one',
        categoryId: 'test_quiz',
        difficulty: QuizDifficulty.beginner,
        prompt: 'Which answer is correct?',
        imageAsset: 'images/ARM-Chip.jpg',
        imageDescription: 'A processor',
        correctOptionId: 'correct_one',
        explanation: 'The first correct answer is correct.',
        options: [
          AnswerOption(id: 'correct_one', text: 'Correct one'),
          AnswerOption(id: 'wrong_one', text: 'Wrong one'),
        ],
      ),
      QuizQuestion(
        id: 'question_two',
        categoryId: 'test_quiz',
        difficulty: QuizDifficulty.intermediate,
        prompt: 'Which second answer is correct?',
        imageAsset: 'images/smartthings_lead.png',
        imageDescription: 'Connected devices',
        correctOptionId: 'correct_two',
        explanation: 'The second correct answer is correct.',
        options: [
          AnswerOption(id: 'wrong_two', text: 'Wrong two'),
          AnswerOption(id: 'correct_two', text: 'Correct two'),
        ],
      ),
    ],
  );
}

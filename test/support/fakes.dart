import 'package:flutter/material.dart';

import 'package:quizle/core/storage/preferences_repository.dart';
import 'package:quizle/features/quiz/data/quiz_repository.dart';
import 'package:quizle/features/quiz/domain/quiz_models.dart';
import 'package:quizle/features/settings/domain/app_settings.dart';

class FakeQuizRepository implements QuizRepository {
  FakeQuizRepository(this.quizzes);

  final List<Quiz> quizzes;

  @override
  Future<List<Quiz>> loadCatalog(Locale locale) async => quizzes;
}

class MemoryPreferencesRepository implements PreferencesRepository {
  AppSettings settings = const AppSettings.defaults();
  final Map<String, int> bestScores = {};

  @override
  Future<int?> getBestScore(String quizId) async => bestScores[quizId];

  @override
  Future<AppSettings> loadSettings() async => settings;

  @override
  Future<void> saveBestScore(String quizId, int score) async {
    final currentBest = bestScores[quizId];
    if (currentBest == null || score > currentBest) {
      bestScores[quizId] = score;
    }
  }

  @override
  Future<void> saveLocale(AppLocalePreference locale) async {
    settings = settings.copyWith(locale: locale);
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    settings = settings.copyWith(themeMode: themeMode);
  }
}

Quiz buildTestQuiz() {
  return const Quiz(
    id: 'test_quiz',
    title: 'Test quiz',
    description: 'A focused test quiz.',
    difficulty: QuizDifficulty.beginner,
    questions: [
      QuizQuestion(
        id: 'question_one',
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

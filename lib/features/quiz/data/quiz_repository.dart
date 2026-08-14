import 'dart:ui';

import 'package:flutter/services.dart';

import '../domain/quiz_models.dart';
import 'open_trivia_quiz_repository.dart';

abstract interface class QuizRepository {
  Future<List<Quiz>> loadCatalog(Locale locale);

  Future<Quiz> loadQuiz(Quiz quiz, QuizConfiguration configuration);

  Future<Quiz?> loadDailyQuiz({
    required Locale locale,
    required DateTime date,
    required String title,
    required String description,
  });
}

class AssetQuizRepository implements QuizRepository {
  const AssetQuizRepository(this.assetBundle);

  final AssetBundle assetBundle;

  @override
  Future<List<Quiz>> loadCatalog(Locale locale) async {
    final languageCode = locale.languageCode == 'ar' ? 'ar' : 'en';
    final source = await assetBundle.loadString(
      'assets/content/quizzes_$languageCode.json',
    );
    return QuizCatalog.fromJsonString(source).quizzes;
  }

  @override
  Future<Quiz?> loadDailyQuiz({
    required Locale locale,
    required DateTime date,
    required String title,
    required String description,
  }) async {
    return null;
  }

  @override
  Future<Quiz> loadQuiz(Quiz quiz, QuizConfiguration configuration) async {
    return quiz;
  }
}

class HybridQuizRepository implements QuizRepository {
  const HybridQuizRepository({
    required AssetQuizRepository assets,
    required OpenTriviaQuizRepository remote,
  }) : _assets = assets,
       _remote = remote;

  final AssetQuizRepository _assets;
  final OpenTriviaQuizRepository _remote;

  @override
  Future<List<Quiz>> loadCatalog(Locale locale) async {
    final bundled = await _assets.loadCatalog(locale);
    if (locale.languageCode == 'ar') {
      return bundled;
    }
    return List.unmodifiable([..._remote.loadCategories(), ...bundled]);
  }

  @override
  Future<Quiz?> loadDailyQuiz({
    required Locale locale,
    required DateTime date,
    required String title,
    required String description,
  }) {
    if (locale.languageCode == 'ar') {
      return Future<Quiz?>.value();
    }
    return _remote.loadDailyQuiz(
      date: date,
      title: title,
      description: description,
    );
  }

  @override
  Future<Quiz> loadQuiz(Quiz quiz, QuizConfiguration configuration) {
    if (quiz.isRemote) {
      return _remote.loadQuiz(quiz, configuration);
    }
    return _assets.loadQuiz(quiz, configuration);
  }
}

import 'dart:ui';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:quizle/features/quiz/data/open_trivia_db_client.dart';
import 'package:quizle/features/quiz/data/open_trivia_quiz_repository.dart';
import 'package:quizle/features/quiz/data/quiz_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('English and Arabic catalogs keep the same stable IDs', () async {
    final repository = AssetQuizRepository(rootBundle);

    final english = await repository.loadCatalog(const Locale('en'));
    final arabic = await repository.loadCatalog(const Locale('ar'));

    expect(english.map((quiz) => quiz.id), arabic.map((quiz) => quiz.id));
    expect(english, isNotEmpty);

    for (var quizIndex = 0; quizIndex < english.length; quizIndex++) {
      final englishQuiz = english[quizIndex];
      final arabicQuiz = arabic[quizIndex];
      expect(
        englishQuiz.questions.map((question) => question.id),
        arabicQuiz.questions.map((question) => question.id),
      );

      for (
        var questionIndex = 0;
        questionIndex < englishQuiz.questions.length;
        questionIndex++
      ) {
        final englishQuestion = englishQuiz.questions[questionIndex];
        final arabicQuestion = arabicQuiz.questions[questionIndex];
        expect(englishQuestion.correctOptionId, arabicQuestion.correctOptionId);
        expect(englishQuestion.difficulty, arabicQuestion.difficulty);
        expect(
          englishQuestion.options.map((option) => option.id).toSet(),
          arabicQuestion.options.map((option) => option.id).toSet(),
        );
      }
    }
  });

  test('hybrid catalog exposes live trivia only in English', () async {
    final client = http.Client();
    addTearDown(client.close);
    final cache = CachedQuery.asNewInstance();
    addTearDown(cache.dispose);
    final repository = HybridQuizRepository(
      assets: AssetQuizRepository(rootBundle),
      remote: OpenTriviaQuizRepository(
        client: OpenTriviaDbClient(client),
        cache: cache,
      ),
    );

    final english = await repository.loadCatalog(const Locale('en'));
    final arabic = await repository.loadCatalog(const Locale('ar'));

    expect(english.where((quiz) => quiz.isRemote), hasLength(8));
    expect(english.where((quiz) => !quiz.isRemote), hasLength(arabic.length));
    expect(arabic.every((quiz) => !quiz.isRemote), isTrue);
  });
}

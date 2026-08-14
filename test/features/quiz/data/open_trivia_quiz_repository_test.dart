import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:quizle/features/quiz/data/open_trivia_db_client.dart';
import 'package:quizle/features/quiz/data/open_trivia_quiz_repository.dart';
import 'package:quizle/features/quiz/domain/quiz_models.dart';

void main() {
  group('OpenTriviaDbClient', () {
    test('maps encoded API questions into stable domain models', () async {
      late Uri requestedUri;
      final client = MockClient((request) async {
        requestedUri = request.url;
        return http.Response(jsonEncode(_successPayload), 200);
      });
      final api = OpenTriviaDbClient(client);
      const request = OpenTriviaRequest(
        amount: 5,
        categoryId: 18,
        difficulty: QuizDifficulty.beginner,
        quizId: 'opentdb_science_computers',
        title: 'Computers',
        description: 'Computer questions',
      );

      final first = await api.fetchQuiz(request);
      final second = await api.fetchQuiz(request);

      expect(requestedUri.host, 'opentdb.com');
      expect(requestedUri.queryParameters['amount'], '5');
      expect(requestedUri.queryParameters['category'], '18');
      expect(requestedUri.queryParameters['difficulty'], 'easy');
      expect(requestedUri.queryParameters['type'], 'multiple');
      expect(requestedUri.queryParameters['encode'], 'url3986');
      expect(first.questions.single.prompt, 'What does USB stand for?');
      expect(first.questions.single.correctOption.text, 'Universal Serial Bus');
      expect(first.questions.single.options, hasLength(4));
      expect(first.questions.single.source, QuizSource.openTriviaDb);
      expect(first.questions.single.id, second.questions.single.id);
    });

    test('surfaces API rate limits as retryable failures', () async {
      final client = MockClient(
        (_) async => http.Response('{"response_code":5,"results":[]}', 200),
      );
      final api = OpenTriviaDbClient(client);

      await expectLater(
        api.fetchQuiz(
          const OpenTriviaRequest(
            amount: 5,
            quizId: 'daily',
            title: 'Daily quiz',
            description: 'Daily questions',
          ),
        ),
        throwsA(
          isA<OpenTriviaException>()
              .having(
                (error) => error.failure,
                'failure',
                OpenTriviaFailure.rateLimit,
              )
              .having((error) => error.isRetryable, 'isRetryable', isTrue),
        ),
      );
    });
  });

  test('reuses a persisted cached quiz without another request', () async {
    var requestCount = 0;
    final client = MockClient((_) async {
      requestCount++;
      return http.Response(jsonEncode(_successPayload), 200);
    });
    final storage = _MemoryQueryStorage();
    final firstCache = CachedQuery.asNewInstance()
      ..config(storage: storage, config: const GlobalQueryConfig());
    final firstRepository = OpenTriviaQuizRepository(
      client: OpenTriviaDbClient(client),
      cache: firstCache,
    );
    final category = firstRepository.loadCategories().firstWhere(
      (quiz) => quiz.remoteCategoryId == 18,
    );
    const configuration = QuizConfiguration(
      difficulty: QuizDifficulty.beginner,
      questionCount: 5,
      mode: QuizMode.relaxed,
    );

    final firstQuiz = await firstRepository.loadQuiz(category, configuration);
    await firstCache.dispose();

    final secondCache = CachedQuery.asNewInstance()
      ..config(storage: storage, config: const GlobalQueryConfig());
    final secondRepository = OpenTriviaQuizRepository(
      client: OpenTriviaDbClient(client),
      cache: secondCache,
    );
    final cachedQuiz = await secondRepository.loadQuiz(category, configuration);
    addTearDown(secondCache.dispose);

    expect(requestCount, 1);
    expect(cachedQuiz.questions.single.id, firstQuiz.questions.single.id);
  });
}

const _successPayload = {
  'response_code': 0,
  'results': [
    {
      'type': 'multiple',
      'difficulty': 'easy',
      'category': 'Science%3A%20Computers',
      'question': 'What%20does%20USB%20stand%20for%3F',
      'correct_answer': 'Universal%20Serial%20Bus',
      'incorrect_answers': [
        'United%20Serial%20Bus',
        'Universal%20System%20Bus',
        'Unified%20Serial%20Board',
      ],
    },
  ],
};

class _MemoryQueryStorage implements StorageInterface {
  final Map<String, StoredQuery> entries = {};

  @override
  void close() {}

  @override
  void delete(String key) => entries.remove(key);

  @override
  void deleteAll() => entries.clear();

  @override
  StoredQuery? get(String key) => entries[key];

  @override
  void put(StoredQuery query) => entries[query.key] = query;
}

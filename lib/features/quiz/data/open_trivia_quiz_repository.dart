import 'package:cached_query_flutter/cached_query_flutter.dart';

import '../domain/quiz_models.dart';
import 'open_trivia_db_client.dart';

class OpenTriviaQuizRepository {
  const OpenTriviaQuizRepository({
    required OpenTriviaDbClient client,
    required CachedQuery cache,
  }) : _client = client,
       _cache = cache;

  final OpenTriviaDbClient _client;
  final CachedQuery _cache;

  List<Quiz> loadCategories() => _categories;

  Future<Quiz> loadQuiz(Quiz category, QuizConfiguration configuration) {
    final remoteCategoryId = category.remoteCategoryId;
    if (!category.isRemote || remoteCategoryId == null) {
      throw ArgumentError.value(category.id, 'category');
    }
    return _load(
      OpenTriviaRequest(
        amount: configuration.questionCount ?? 10,
        categoryId: remoteCategoryId,
        difficulty: configuration.difficulty,
        quizId: category.id,
        title: category.title,
        description: category.description,
      ),
      staleDuration: const Duration(minutes: 30),
      storageDuration: const Duration(days: 7),
    );
  }

  Future<Quiz> loadDailyQuiz({
    required DateTime date,
    required String title,
    required String description,
  }) {
    final localDate = date.toLocal();
    final dateKey = '${localDate.year}-${localDate.month}-${localDate.day}';
    return _load(
      OpenTriviaRequest(
        amount: 5,
        quizId: QuizSessionKind.daily.name,
        title: title,
        description: description,
        cacheKeySuffix: dateKey,
      ),
      staleDuration: const Duration(days: 1),
      storageDuration: const Duration(days: 3),
    );
  }

  Future<Quiz> _load(
    OpenTriviaRequest request, {
    required Duration staleDuration,
    required Duration storageDuration,
  }) async {
    final query = Query<Quiz>(
      key: request.cacheKey,
      cache: _cache,
      config: QueryConfig(
        staleDuration: staleDuration,
        cacheDuration: const Duration(minutes: 30),
        storeQuery: true,
        storageDuration: storageDuration,
        storageSerializer: (quiz) => quiz.toJson(),
        storageDeserializer: (json) => Quiz.fromJson(
          (json as Map<Object?, Object?>).cast<String, Object?>(),
        ),
        retryConfig: RetryConfig(
          maxRetries: 1,
          delay: (_) => const Duration(seconds: 5),
          whenError: (error, attempt) {
            return error is OpenTriviaException && error.isRetryable;
          },
        ),
      ),
      queryFn: () => _client.fetchQuiz(request),
    );
    final state = await query.fetch();
    final data = state.data;
    if (data != null) {
      return data;
    }
    if (state.error case final Object error) {
      throw error;
    }
    throw OpenTriviaException.empty();
  }
}

const _categories = [
  Quiz(
    id: 'opentdb_general_knowledge',
    title: 'General knowledge',
    description: 'A fresh mix of facts and everyday knowledge.',
    questions: [],
    source: QuizSource.openTriviaDb,
    remoteCategoryId: 9,
  ),
  Quiz(
    id: 'opentdb_entertainment_film',
    title: 'Film',
    description: 'Movies, directors, characters, and cinema history.',
    questions: [],
    source: QuizSource.openTriviaDb,
    remoteCategoryId: 11,
  ),
  Quiz(
    id: 'opentdb_entertainment_video_games',
    title: 'Video games',
    description: 'Games, studios, characters, and gaming history.',
    questions: [],
    source: QuizSource.openTriviaDb,
    remoteCategoryId: 15,
  ),
  Quiz(
    id: 'opentdb_science_nature',
    title: 'Science and nature',
    description: 'Discoveries, living systems, physics, and the natural world.',
    questions: [],
    source: QuizSource.openTriviaDb,
    remoteCategoryId: 17,
  ),
  Quiz(
    id: 'opentdb_science_computers',
    title: 'Computers',
    description: 'Hardware, software, internet, and computing history.',
    questions: [],
    source: QuizSource.openTriviaDb,
    remoteCategoryId: 18,
  ),
  Quiz(
    id: 'opentdb_sports',
    title: 'Sports',
    description: 'Teams, athletes, rules, records, and competitions.',
    questions: [],
    source: QuizSource.openTriviaDb,
    remoteCategoryId: 21,
  ),
  Quiz(
    id: 'opentdb_geography',
    title: 'Geography',
    description: 'Countries, cities, landmarks, maps, and landscapes.',
    questions: [],
    source: QuizSource.openTriviaDb,
    remoteCategoryId: 22,
  ),
  Quiz(
    id: 'opentdb_history',
    title: 'History',
    description: 'People, civilizations, milestones, and world events.',
    questions: [],
    source: QuizSource.openTriviaDb,
    remoteCategoryId: 23,
  ),
];

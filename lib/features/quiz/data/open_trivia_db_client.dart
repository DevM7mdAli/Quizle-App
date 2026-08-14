import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../domain/quiz_models.dart';

class OpenTriviaRequest {
  const OpenTriviaRequest({
    required this.amount,
    required this.quizId,
    required this.title,
    required this.description,
    this.categoryId,
    this.difficulty,
    this.cacheKeySuffix,
  });

  final int amount;
  final int? categoryId;
  final QuizDifficulty? difficulty;
  final String quizId;
  final String title;
  final String description;
  final String? cacheKeySuffix;

  Object get cacheKey => [
    'open-trivia-db',
    1,
    categoryId,
    difficulty?.name,
    amount,
    cacheKeySuffix,
  ];
}

class OpenTriviaDbClient {
  const OpenTriviaDbClient(this._client);

  static final Uri websiteUri = Uri.parse('https://opentdb.com/');
  static final Uri licenseUri = Uri.parse(
    'https://creativecommons.org/licenses/by-sa/4.0/',
  );

  final http.Client _client;

  Future<Quiz> fetchQuiz(OpenTriviaRequest request) async {
    if (request.amount < 1 || request.amount > 50) {
      throw ArgumentError.value(request.amount, 'amount');
    }

    final queryParameters = <String, String>{
      'amount': '${request.amount}',
      'type': 'multiple',
      'encode': 'url3986',
      if (request.categoryId != null) 'category': '${request.categoryId}',
      if (request.difficulty != null)
        'difficulty': _difficultyName(request.difficulty!),
    };
    final uri = Uri.https('opentdb.com', '/api.php', queryParameters);

    late http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 12));
    } on Object catch (error) {
      throw OpenTriviaException.transport(error);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw OpenTriviaException.http(response.statusCode);
    }

    final Map<String, Object?> payload;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<Object?, Object?>) {
        throw const FormatException('The response must be an object.');
      }
      payload = decoded.cast<String, Object?>();
    } on Object catch (error) {
      throw OpenTriviaException.invalidResponse(error);
    }

    final responseCode = payload['response_code'];
    if (responseCode is! int) {
      throw OpenTriviaException.invalidResponse(
        const FormatException('Missing response code.'),
      );
    }
    if (responseCode != 0) {
      throw OpenTriviaException.api(responseCode);
    }

    final results = payload['results'];
    if (results is! List<Object?>) {
      throw OpenTriviaException.invalidResponse(
        const FormatException('Missing question results.'),
      );
    }

    final questionsById = <String, QuizQuestion>{};
    try {
      for (final rawQuestion in results) {
        final question = _parseQuestion(
          rawQuestion,
          request.categoryId == null ? null : request.quizId,
        );
        questionsById.putIfAbsent(question.id, () => question);
      }
    } on Object catch (error) {
      throw OpenTriviaException.invalidResponse(error);
    }

    if (questionsById.isEmpty) {
      throw OpenTriviaException.api(1);
    }

    return Quiz(
      id: request.quizId,
      title: request.title,
      description: request.description,
      questions: List.unmodifiable(questionsById.values),
      source: QuizSource.openTriviaDb,
      remoteCategoryId: request.categoryId,
    );
  }

  QuizQuestion _parseQuestion(Object? source, String? requestedCategoryId) {
    if (source is! Map<Object?, Object?>) {
      throw const FormatException('A question must be an object.');
    }
    final json = source.cast<String, Object?>();
    final categoryName = _decode(_requiredString(json, 'category'));
    final categoryId =
        requestedCategoryId ?? 'opentdb_${_categorySlug(categoryName)}';
    final prompt = _decode(_requiredString(json, 'question'));
    final correctAnswer = _decode(_requiredString(json, 'correct_answer'));
    final difficulty = _parseDifficulty(_requiredString(json, 'difficulty'));
    final rawIncorrectAnswers = json['incorrect_answers'];
    if (rawIncorrectAnswers is! List<Object?>) {
      throw const FormatException('Incorrect answers must be a list.');
    }
    final incorrectAnswers = rawIncorrectAnswers
        .map((answer) {
          if (answer is! String || answer.trim().isEmpty) {
            throw const FormatException('An answer must be text.');
          }
          return _decode(answer);
        })
        .toList(growable: false);
    final questionId =
        'opentdb_${_digest('$categoryId|$prompt|$correctAnswer')}';
    final answers = [correctAnswer, ...incorrectAnswers];
    final options = [
      for (var index = 0; index < answers.length; index++)
        AnswerOption(
          id: '${questionId}_${_digest('$index|${answers[index]}')}',
          text: answers[index],
        ),
    ];

    if (options.length < 2) {
      throw const FormatException('A question needs at least two answers.');
    }

    return QuizQuestion(
      id: questionId,
      categoryId: categoryId,
      difficulty: difficulty,
      prompt: prompt,
      correctOptionId: options.first.id,
      explanation: 'Open Trivia DB lists "$correctAnswer" as the answer.',
      options: List.unmodifiable(options),
      source: QuizSource.openTriviaDb,
    );
  }

  String _decode(String value) => Uri.decodeComponent(value);

  String _digest(String value) {
    return sha256.convert(utf8.encode(value)).toString().substring(0, 20);
  }

  String _categorySlug(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  String _difficultyName(QuizDifficulty difficulty) {
    return switch (difficulty) {
      QuizDifficulty.beginner => 'easy',
      QuizDifficulty.intermediate => 'medium',
      QuizDifficulty.advanced => 'hard',
    };
  }

  QuizDifficulty _parseDifficulty(String difficulty) {
    return switch (difficulty) {
      'easy' => QuizDifficulty.beginner,
      'medium' => QuizDifficulty.intermediate,
      'hard' => QuizDifficulty.advanced,
      _ => throw FormatException(
        'Unknown Open Trivia DB difficulty: $difficulty',
      ),
    };
  }

  String _requiredString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
    throw FormatException('$key must be non-empty text.');
  }
}

enum OpenTriviaFailure {
  transport,
  http,
  noResults,
  invalidRequest,
  token,
  rateLimit,
  invalidResponse,
}

class OpenTriviaException implements Exception {
  const OpenTriviaException._(this.failure, this.message, [this.cause]);

  factory OpenTriviaException.transport(Object cause) {
    return OpenTriviaException._(
      OpenTriviaFailure.transport,
      'Open Trivia DB could not be reached.',
      cause,
    );
  }

  factory OpenTriviaException.http(int statusCode) {
    return OpenTriviaException._(
      OpenTriviaFailure.http,
      'Open Trivia DB returned HTTP $statusCode.',
    );
  }

  factory OpenTriviaException.invalidResponse(Object cause) {
    return OpenTriviaException._(
      OpenTriviaFailure.invalidResponse,
      'Open Trivia DB returned an invalid response.',
      cause,
    );
  }

  factory OpenTriviaException.empty() {
    return const OpenTriviaException._(
      OpenTriviaFailure.invalidResponse,
      'Open Trivia DB returned no quiz data.',
    );
  }

  factory OpenTriviaException.api(int responseCode) {
    return switch (responseCode) {
      1 => const OpenTriviaException._(
        OpenTriviaFailure.noResults,
        'No questions match this selection.',
      ),
      2 => const OpenTriviaException._(
        OpenTriviaFailure.invalidRequest,
        'Open Trivia DB rejected the request.',
      ),
      3 || 4 => const OpenTriviaException._(
        OpenTriviaFailure.token,
        'The Open Trivia DB session is unavailable.',
      ),
      5 => const OpenTriviaException._(
        OpenTriviaFailure.rateLimit,
        'Open Trivia DB is receiving requests too quickly.',
      ),
      _ => OpenTriviaException._(
        OpenTriviaFailure.invalidResponse,
        'Open Trivia DB returned response code $responseCode.',
      ),
    };
  }

  final OpenTriviaFailure failure;
  final String message;
  final Object? cause;

  bool get isRetryable {
    return failure == OpenTriviaFailure.transport ||
        failure == OpenTriviaFailure.http ||
        failure == OpenTriviaFailure.rateLimit;
  }

  @override
  String toString() => message;
}

import '../../quiz/domain/quiz_models.dart';

class QuestionAttempt {
  const QuestionAttempt({
    required this.questionId,
    required this.categoryId,
    required this.difficulty,
    required this.selectedOptionId,
    required this.correctOptionId,
  });

  factory QuestionAttempt.fromJson(Map<String, Object?> json) {
    return QuestionAttempt(
      questionId: _requiredString(json, 'questionId'),
      categoryId: _requiredString(json, 'categoryId'),
      difficulty: QuizDifficulty.fromName(_requiredString(json, 'difficulty')),
      selectedOptionId: json['selectedOptionId'] as String?,
      correctOptionId: _requiredString(json, 'correctOptionId'),
    );
  }

  final String questionId;
  final String categoryId;
  final QuizDifficulty difficulty;
  final String? selectedOptionId;
  final String correctOptionId;

  bool get isCorrect => selectedOptionId == correctOptionId;

  Map<String, Object?> toJson() {
    return {
      'questionId': questionId,
      'categoryId': categoryId,
      'difficulty': difficulty.name,
      'selectedOptionId': selectedOptionId,
      'correctOptionId': correctOptionId,
    };
  }
}

class QuizAttempt {
  const QuizAttempt({
    required this.id,
    required this.kind,
    required this.sourceQuizId,
    required this.mode,
    required this.startedAt,
    required this.completedAt,
    required this.answers,
  });

  factory QuizAttempt.fromJson(Map<String, Object?> json) {
    final rawAnswers = _requiredList(json, 'answers');
    return QuizAttempt(
      id: _requiredString(json, 'id'),
      kind: QuizSessionKind.values.byName(_requiredString(json, 'kind')),
      sourceQuizId: json['sourceQuizId'] as String?,
      mode: QuizMode.values.byName(_requiredString(json, 'mode')),
      startedAt: DateTime.parse(_requiredString(json, 'startedAt')),
      completedAt: DateTime.parse(_requiredString(json, 'completedAt')),
      answers: rawAnswers
          .map(
            (value) => QuestionAttempt.fromJson(_requiredMap(value, 'answer')),
          )
          .toList(growable: false),
    );
  }

  final String id;
  final QuizSessionKind kind;
  final String? sourceQuizId;
  final QuizMode mode;
  final DateTime startedAt;
  final DateTime completedAt;
  final List<QuestionAttempt> answers;

  int get correctAnswerCount {
    return answers.where((answer) => answer.isCorrect).length;
  }

  int get scorePercent {
    if (answers.isEmpty) {
      return 0;
    }
    return ((correctAnswerCount / answers.length) * 100).round();
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'kind': kind.name,
      'sourceQuizId': sourceQuizId,
      'mode': mode.name,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class SavedQuizSession {
  const SavedQuizSession({
    required this.kind,
    required this.sourceQuizId,
    required this.configuration,
    required this.questionIds,
    required this.optionOrders,
    required this.currentIndex,
    required this.answers,
    required this.selectedOptionId,
    required this.phase,
    required this.startedAt,
    required this.questionDeadline,
    required this.pausedRemainingSeconds,
  });

  factory SavedQuizSession.fromJson(Map<String, Object?> json) {
    final rawOptionOrders = _requiredMap(json['optionOrders'], 'optionOrders');
    final rawAnswers = _requiredMap(json['answers'], 'answers');
    final rawQuestionIds = _requiredList(json, 'questionIds');
    final deadline = json['questionDeadline'];

    return SavedQuizSession(
      kind: QuizSessionKind.values.byName(_requiredString(json, 'kind')),
      sourceQuizId: json['sourceQuizId'] as String?,
      configuration: QuizConfiguration.fromJson(
        _requiredMap(json['configuration'], 'configuration'),
      ),
      questionIds: rawQuestionIds.cast<String>(),
      optionOrders: rawOptionOrders.map(
        (key, value) => MapEntry(key, (value as List<Object?>).cast<String>()),
      ),
      currentIndex: _requiredInt(json, 'currentIndex'),
      answers: rawAnswers.map((key, value) => MapEntry(key, value as String)),
      selectedOptionId: json['selectedOptionId'] as String?,
      phase: QuizSessionPhase.values.byName(_requiredString(json, 'phase')),
      startedAt: DateTime.parse(_requiredString(json, 'startedAt')),
      questionDeadline: deadline is String ? DateTime.parse(deadline) : null,
      pausedRemainingSeconds: json['pausedRemainingSeconds'] as int?,
    );
  }

  final QuizSessionKind kind;
  final String? sourceQuizId;
  final QuizConfiguration configuration;
  final List<String> questionIds;
  final Map<String, List<String>> optionOrders;
  final int currentIndex;
  final Map<String, String> answers;
  final String? selectedOptionId;
  final QuizSessionPhase phase;
  final DateTime startedAt;
  final DateTime? questionDeadline;
  final int? pausedRemainingSeconds;

  Map<String, Object?> toJson() {
    return {
      'kind': kind.name,
      'sourceQuizId': sourceQuizId,
      'configuration': configuration.toJson(),
      'questionIds': questionIds,
      'optionOrders': optionOrders,
      'currentIndex': currentIndex,
      'answers': answers,
      'selectedOptionId': selectedOptionId,
      'phase': phase.name,
      'startedAt': startedAt.toIso8601String(),
      'questionDeadline': questionDeadline?.toIso8601String(),
      'pausedRemainingSeconds': pausedRemainingSeconds,
    };
  }
}

enum AchievementType {
  firstQuiz,
  perfectScore,
  fiveQuizzes,
  categoryExplorer,
  threeDayStreak,
}

class LearningData {
  const LearningData({
    required this.attempts,
    required this.bookmarkedQuestionIds,
    required this.savedSession,
    this.questionBank = const {},
  });

  const LearningData.empty()
    : attempts = const [],
      bookmarkedQuestionIds = const {},
      savedSession = null,
      questionBank = const {};

  final List<QuizAttempt> attempts;
  final Set<String> bookmarkedQuestionIds;
  final SavedQuizSession? savedSession;
  final Map<String, QuizQuestion> questionBank;

  Set<String> get unresolvedIncorrectQuestionIds {
    final incorrect = <String>{};
    final orderedAttempts = [...attempts]
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));
    for (final attempt in orderedAttempts) {
      for (final answer in attempt.answers) {
        if (answer.isCorrect) {
          incorrect.remove(answer.questionId);
        } else {
          incorrect.add(answer.questionId);
        }
      }
    }
    return incorrect;
  }

  int? bestScorePercent(String quizId) {
    final scores = attempts
        .where(
          (attempt) =>
              attempt.kind == QuizSessionKind.category &&
              attempt.sourceQuizId == quizId,
        )
        .map((attempt) => attempt.scorePercent);
    if (scores.isEmpty) {
      return null;
    }
    return scores.reduce((best, score) => score > best ? score : best);
  }

  bool completedDailyQuiz(DateTime date) {
    return attempts.any(
      (attempt) =>
          attempt.kind == QuizSessionKind.daily &&
          _isSameDate(attempt.completedAt, date),
    );
  }

  int dailyStreak(DateTime today) {
    final completedDates = attempts
        .where((attempt) => attempt.kind == QuizSessionKind.daily)
        .map((attempt) => _dateOnly(attempt.completedAt))
        .toSet();
    if (completedDates.isEmpty) {
      return 0;
    }

    var cursor = _dateOnly(today);
    if (!completedDates.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }

    var streak = 0;
    while (completedDates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Set<AchievementType> unlockedAchievements(DateTime today) {
    final unlocked = <AchievementType>{};
    if (attempts.isNotEmpty) {
      unlocked.add(AchievementType.firstQuiz);
    }
    if (attempts.any((attempt) => attempt.scorePercent == 100)) {
      unlocked.add(AchievementType.perfectScore);
    }
    if (attempts.length >= 5) {
      unlocked.add(AchievementType.fiveQuizzes);
    }
    final categories = attempts
        .expand((attempt) => attempt.answers)
        .map((answer) => answer.categoryId)
        .toSet();
    if (categories.length >= 3) {
      unlocked.add(AchievementType.categoryExplorer);
    }
    if (dailyStreak(today) >= 3) {
      unlocked.add(AchievementType.threeDayStreak);
    }
    return unlocked;
  }

  LearningData copyWith({
    List<QuizAttempt>? attempts,
    Set<String>? bookmarkedQuestionIds,
    SavedQuizSession? savedSession,
    bool clearSavedSession = false,
    Map<String, QuizQuestion>? questionBank,
  }) {
    return LearningData(
      attempts: attempts ?? this.attempts,
      bookmarkedQuestionIds:
          bookmarkedQuestionIds ?? this.bookmarkedQuestionIds,
      savedSession: clearSavedSession
          ? null
          : savedSession ?? this.savedSession,
      questionBank: questionBank ?? this.questionBank,
    );
  }
}

DateTime _dateOnly(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

bool _isSameDate(DateTime first, DateTime second) {
  return _dateOnly(first) == _dateOnly(second);
}

Map<String, Object?> _requiredMap(Object? value, String field) {
  if (value is Map<String, Object?>) {
    return value;
  }
  throw FormatException('$field must be an object.');
}

List<Object?> _requiredList(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is List<Object?>) {
    return value;
  }
  throw FormatException('$key must be a list.');
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw FormatException('$key must be a non-empty string.');
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  throw FormatException('$key must be an integer.');
}

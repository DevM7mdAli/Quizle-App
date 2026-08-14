import 'dart:convert';

enum QuizDifficulty {
  beginner,
  intermediate,
  advanced;

  static QuizDifficulty fromName(String value) {
    return QuizDifficulty.values.firstWhere(
      (difficulty) => difficulty.name == value,
      orElse: () => throw FormatException('Unknown quiz difficulty: $value'),
    );
  }
}

enum QuizMode { relaxed, timed }

enum QuizSessionKind { category, daily, incorrect, bookmarked }

enum QuizSessionPhase { answering, feedback, completed }

class QuizConfiguration {
  const QuizConfiguration({
    required this.difficulty,
    required this.questionCount,
    required this.mode,
    this.secondsPerQuestion = 30,
  });

  const QuizConfiguration.defaults()
    : difficulty = null,
      questionCount = 5,
      mode = QuizMode.relaxed,
      secondsPerQuestion = 30;

  factory QuizConfiguration.fromJson(Map<String, Object?> json) {
    final difficultyName = json['difficulty'];
    final modeName = _requiredString(json, 'mode');
    final questionCount = json['questionCount'];
    final secondsPerQuestion = json['secondsPerQuestion'];

    return QuizConfiguration(
      difficulty: difficultyName is String
          ? QuizDifficulty.fromName(difficultyName)
          : null,
      questionCount: questionCount is int ? questionCount : null,
      mode: QuizMode.values.firstWhere(
        (mode) => mode.name == modeName,
        orElse: () => throw FormatException('Unknown quiz mode: $modeName'),
      ),
      secondsPerQuestion: secondsPerQuestion is int ? secondsPerQuestion : 30,
    );
  }

  final QuizDifficulty? difficulty;
  final int? questionCount;
  final QuizMode mode;
  final int secondsPerQuestion;

  QuizConfiguration copyWith({
    QuizDifficulty? difficulty,
    bool clearDifficulty = false,
    int? questionCount,
    bool allQuestions = false,
    QuizMode? mode,
  }) {
    return QuizConfiguration(
      difficulty: clearDifficulty ? null : difficulty ?? this.difficulty,
      questionCount: allQuestions ? null : questionCount ?? this.questionCount,
      mode: mode ?? this.mode,
      secondsPerQuestion: secondsPerQuestion,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'difficulty': difficulty?.name,
      'questionCount': questionCount,
      'mode': mode.name,
      'secondsPerQuestion': secondsPerQuestion,
    };
  }
}

class AnswerOption {
  const AnswerOption({required this.id, required this.text});

  factory AnswerOption.fromJson(Map<String, Object?> json) {
    return AnswerOption(
      id: _requiredString(json, 'id'),
      text: _requiredString(json, 'text'),
    );
  }

  final String id;
  final String text;
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.categoryId,
    required this.difficulty,
    required this.prompt,
    required this.imageAsset,
    required this.imageDescription,
    required this.correctOptionId,
    required this.explanation,
    required this.options,
  });

  factory QuizQuestion.fromJson(
    Map<String, Object?> json, {
    required String categoryId,
    QuizDifficulty? fallbackDifficulty,
  }) {
    final rawOptions = _requiredList(json, 'options');
    final options = rawOptions
        .map((value) => AnswerOption.fromJson(_requiredMap(value, 'option')))
        .toList(growable: false);
    final correctOptionId = _requiredString(json, 'correctOptionId');
    final difficultyName = json['difficulty'];

    if (options.length < 2) {
      throw const FormatException('A question needs at least two options.');
    }

    final optionIds = options.map((option) => option.id).toSet();
    if (optionIds.length != options.length) {
      throw const FormatException('Answer option IDs must be unique.');
    }
    if (!optionIds.contains(correctOptionId)) {
      throw const FormatException('The correct option is missing.');
    }

    return QuizQuestion(
      id: _requiredString(json, 'id'),
      categoryId: categoryId,
      difficulty: difficultyName is String
          ? QuizDifficulty.fromName(difficultyName)
          : fallbackDifficulty ??
                (throw const FormatException(
                  'A question needs a valid difficulty.',
                )),
      prompt: _requiredString(json, 'prompt'),
      imageAsset: _requiredString(json, 'imageAsset'),
      imageDescription: _requiredString(json, 'imageDescription'),
      correctOptionId: correctOptionId,
      explanation: _requiredString(json, 'explanation'),
      options: List.unmodifiable(options),
    );
  }

  final String id;
  final String categoryId;
  final QuizDifficulty difficulty;
  final String prompt;
  final String imageAsset;
  final String imageDescription;
  final String correctOptionId;
  final String explanation;
  final List<AnswerOption> options;

  AnswerOption get correctOption {
    return options.firstWhere((option) => option.id == correctOptionId);
  }

  QuizQuestion withOptions(List<AnswerOption> shuffledOptions) {
    return QuizQuestion(
      id: id,
      categoryId: categoryId,
      difficulty: difficulty,
      prompt: prompt,
      imageAsset: imageAsset,
      imageDescription: imageDescription,
      correctOptionId: correctOptionId,
      explanation: explanation,
      options: List.unmodifiable(shuffledOptions),
    );
  }
}

class Quiz {
  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, Object?> json) {
    final id = _requiredString(json, 'id');
    final rawQuestions = _requiredList(json, 'questions');
    final quizDifficulty = json['difficulty'];
    final fallbackDifficulty = quizDifficulty is String
        ? QuizDifficulty.fromName(quizDifficulty)
        : null;
    final questions = rawQuestions
        .map(
          (value) => QuizQuestion.fromJson(
            _requiredMap(value, 'question'),
            categoryId: id,
            fallbackDifficulty: fallbackDifficulty,
          ),
        )
        .toList(growable: false);

    if (questions.isEmpty) {
      throw const FormatException('A quiz needs at least one question.');
    }

    final questionIds = questions.map((question) => question.id).toSet();
    if (questionIds.length != questions.length) {
      throw const FormatException('Question IDs must be unique.');
    }

    return Quiz(
      id: id,
      title: _requiredString(json, 'title'),
      description: _requiredString(json, 'description'),
      questions: List.unmodifiable(questions),
    );
  }

  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;

  String get imageAsset => questions.first.imageAsset;

  Set<QuizDifficulty> get availableDifficulties {
    return questions.map((question) => question.difficulty).toSet();
  }

  List<QuizQuestion> questionsFor(QuizDifficulty? difficulty) {
    if (difficulty == null) {
      return questions;
    }
    return questions
        .where((question) => question.difficulty == difficulty)
        .toList(growable: false);
  }
}

class QuizCatalog {
  const QuizCatalog(this.quizzes);

  factory QuizCatalog.fromJsonString(String source) {
    final Object? decoded = jsonDecode(source);
    final root = _requiredMap(decoded, 'catalog');
    final rawQuizzes = _requiredList(root, 'quizzes');
    final quizzes = rawQuizzes
        .map((value) => Quiz.fromJson(_requiredMap(value, 'quiz')))
        .toList(growable: false);

    final quizIds = quizzes.map((quiz) => quiz.id).toSet();
    if (quizIds.length != quizzes.length) {
      throw const FormatException('Quiz IDs must be unique.');
    }

    final questions = quizzes.expand((quiz) => quiz.questions).toList();
    final questionIds = questions.map((question) => question.id).toSet();
    if (questionIds.length != questions.length) {
      throw const FormatException('Question IDs must be globally unique.');
    }

    return QuizCatalog(List.unmodifiable(quizzes));
  }

  final List<Quiz> quizzes;

  List<QuizQuestion> get allQuestions {
    return quizzes.expand((quiz) => quiz.questions).toList(growable: false);
  }

  Quiz? quizById(String id) {
    for (final quiz in quizzes) {
      if (quiz.id == id) {
        return quiz;
      }
    }
    return null;
  }

  QuizQuestion? questionById(String id) {
    for (final quiz in quizzes) {
      for (final question in quiz.questions) {
        if (question.id == id) {
          return question;
        }
      }
    }
    return null;
  }
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
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  throw FormatException('$key must be a non-empty string.');
}

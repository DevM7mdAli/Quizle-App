import 'dart:convert';

enum QuizDifficulty {
  beginner;

  static QuizDifficulty fromName(String value) {
    return QuizDifficulty.values.firstWhere(
      (difficulty) => difficulty.name == value,
      orElse: () => throw FormatException('Unknown quiz difficulty: $value'),
    );
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
    required this.prompt,
    required this.imageAsset,
    required this.imageDescription,
    required this.correctOptionId,
    required this.explanation,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, Object?> json) {
    final rawOptions = _requiredList(json, 'options');
    final options = rawOptions
        .map((value) => AnswerOption.fromJson(_requiredMap(value, 'option')))
        .toList(growable: false);
    final correctOptionId = _requiredString(json, 'correctOptionId');

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
      prompt: _requiredString(json, 'prompt'),
      imageAsset: _requiredString(json, 'imageAsset'),
      imageDescription: _requiredString(json, 'imageDescription'),
      correctOptionId: correctOptionId,
      explanation: _requiredString(json, 'explanation'),
      options: options,
    );
  }

  final String id;
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
    required this.difficulty,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, Object?> json) {
    final rawQuestions = _requiredList(json, 'questions');
    final questions = rawQuestions
        .map((value) => QuizQuestion.fromJson(_requiredMap(value, 'question')))
        .toList(growable: false);

    if (questions.isEmpty) {
      throw const FormatException('A quiz needs at least one question.');
    }

    final questionIds = questions.map((question) => question.id).toSet();
    if (questionIds.length != questions.length) {
      throw const FormatException('Question IDs must be unique.');
    }

    return Quiz(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      description: _requiredString(json, 'description'),
      difficulty: QuizDifficulty.fromName(_requiredString(json, 'difficulty')),
      questions: questions,
    );
  }

  final String id;
  final String title;
  final String description;
  final QuizDifficulty difficulty;
  final List<QuizQuestion> questions;
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

    return QuizCatalog(quizzes);
  }

  final List<Quiz> quizzes;
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

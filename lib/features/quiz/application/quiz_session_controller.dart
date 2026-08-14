import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../progress/application/learning_controller.dart';
import '../../progress/domain/learning_models.dart';
import '../domain/quiz_models.dart';

class QuizSessionState {
  const QuizSessionState({
    required this.quiz,
    required this.configuration,
    required this.kind,
    required this.startedAt,
    required this.questions,
    required this.currentIndex,
    required this.answers,
    required this.selectedOptionId,
    required this.phase,
    required this.questionDeadline,
    required this.pausedRemainingSeconds,
  });

  final Quiz quiz;
  final QuizConfiguration configuration;
  final QuizSessionKind kind;
  final DateTime startedAt;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final Map<String, String> answers;
  final String? selectedOptionId;
  final QuizSessionPhase phase;
  final DateTime? questionDeadline;
  final int? pausedRemainingSeconds;

  QuizQuestion get currentQuestion => questions[currentIndex];

  bool get isLastQuestion => currentIndex == questions.length - 1;

  bool get isSelectionCorrect {
    return selectedOptionId == currentQuestion.correctOptionId;
  }

  int get correctAnswerCount {
    return questions.where((question) {
      return answers[question.id] == question.correctOptionId;
    }).length;
  }

  int get scorePercent {
    return ((correctAnswerCount / questions.length) * 100).round();
  }

  int? remainingSeconds(DateTime now) {
    if (configuration.mode != QuizMode.timed ||
        phase != QuizSessionPhase.answering) {
      return null;
    }
    if (questionDeadline == null) {
      return pausedRemainingSeconds ?? configuration.secondsPerQuestion;
    }
    final milliseconds = questionDeadline!.difference(now).inMilliseconds;
    return (milliseconds / Duration.millisecondsPerSecond).ceil().clamp(
      0,
      configuration.secondsPerQuestion,
    );
  }

  QuizSessionState copyWith({
    int? currentIndex,
    Map<String, String>? answers,
    String? selectedOptionId,
    bool clearSelection = false,
    QuizSessionPhase? phase,
    DateTime? questionDeadline,
    bool clearDeadline = false,
    int? pausedRemainingSeconds,
    bool clearPausedRemaining = false,
  }) {
    return QuizSessionState(
      quiz: quiz,
      configuration: configuration,
      kind: kind,
      startedAt: startedAt,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      selectedOptionId: clearSelection
          ? null
          : selectedOptionId ?? this.selectedOptionId,
      phase: phase ?? this.phase,
      questionDeadline: clearDeadline
          ? null
          : questionDeadline ?? this.questionDeadline,
      pausedRemainingSeconds: clearPausedRemaining
          ? null
          : pausedRemainingSeconds ?? this.pausedRemainingSeconds,
    );
  }
}

final randomProvider = Provider<Random>((ref) => Random());

final nowProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final quizSessionControllerProvider =
    NotifierProvider<QuizSessionController, QuizSessionState?>(
      QuizSessionController.new,
    );

class QuizSessionController extends Notifier<QuizSessionState?> {
  static const dailyQuestionCount = 5;

  @override
  QuizSessionState? build() => null;

  void discard() {
    state = null;
    unawaited(
      ref.read(learningControllerProvider.notifier).clearSavedSession(),
    );
  }

  void expireCurrentQuestion() {
    final session = state;
    if (session == null || session.phase != QuizSessionPhase.answering) {
      return;
    }
    state = session.copyWith(
      clearSelection: true,
      phase: QuizSessionPhase.feedback,
      clearDeadline: true,
      clearPausedRemaining: true,
    );
    _persist();
  }

  Future<bool> moveNext() async {
    final session = state;
    if (session == null || session.phase != QuizSessionPhase.feedback) {
      return false;
    }

    if (session.isLastQuestion) {
      final completed = session.copyWith(
        phase: QuizSessionPhase.completed,
        clearDeadline: true,
        clearPausedRemaining: true,
      );
      state = completed;
      final learningController = ref.read(learningControllerProvider.notifier);
      await learningController.recordAttempt(_buildAttempt(completed));
      await learningController.clearSavedSession();
      return true;
    }

    final now = ref.read(nowProvider)();
    state = session.copyWith(
      currentIndex: session.currentIndex + 1,
      clearSelection: true,
      phase: QuizSessionPhase.answering,
      questionDeadline: session.configuration.mode == QuizMode.timed
          ? now.add(Duration(seconds: session.configuration.secondsPerQuestion))
          : null,
      clearDeadline: session.configuration.mode == QuizMode.relaxed,
      clearPausedRemaining: true,
    );
    _persist();
    return false;
  }

  void pause() {
    final session = state;
    if (session == null || session.phase == QuizSessionPhase.completed) {
      return;
    }
    if (session.configuration.mode == QuizMode.timed &&
        session.phase == QuizSessionPhase.answering) {
      final remaining = session.remainingSeconds(ref.read(nowProvider)());
      state = session.copyWith(
        clearDeadline: true,
        pausedRemainingSeconds: remaining,
      );
    }
    _persist();
  }

  bool resume({
    required List<Quiz> catalog,
    required String sessionTitle,
    required String sessionDescription,
  }) {
    final saved = ref.read(learningControllerProvider).savedSession;
    if (saved == null) {
      return false;
    }

    final questionIndex = {
      for (final quiz in catalog)
        for (final question in quiz.questions) question.id: question,
    };
    final restoredQuestions = <QuizQuestion>[];
    for (final questionId in saved.questionIds) {
      final question = questionIndex[questionId];
      final optionOrder = saved.optionOrders[questionId];
      if (question == null || optionOrder == null) {
        discard();
        return false;
      }
      final optionIndex = {
        for (final option in question.options) option.id: option,
      };
      final orderedOptions = <AnswerOption>[];
      for (final optionId in optionOrder) {
        final option = optionIndex[optionId];
        if (option == null) {
          discard();
          return false;
        }
        orderedOptions.add(option);
      }
      restoredQuestions.add(question.withOptions(orderedOptions));
    }

    if (restoredQuestions.isEmpty ||
        saved.currentIndex >= restoredQuestions.length) {
      discard();
      return false;
    }

    final sourceQuiz = saved.kind == QuizSessionKind.category
        ? catalog.where((quiz) => quiz.id == saved.sourceQuizId).firstOrNull
        : null;
    if (saved.kind == QuizSessionKind.category && sourceQuiz == null) {
      discard();
      return false;
    }

    final quiz =
        sourceQuiz ??
        Quiz(
          id: saved.kind.name,
          title: sessionTitle,
          description: sessionDescription,
          questions: List.unmodifiable(restoredQuestions),
        );
    final now = ref.read(nowProvider)();
    var phase = saved.phase;
    DateTime? deadline;
    int? pausedRemaining = saved.pausedRemainingSeconds;
    if (saved.configuration.mode == QuizMode.timed &&
        phase == QuizSessionPhase.answering) {
      final remaining = saved.questionDeadline == null
          ? pausedRemaining ?? saved.configuration.secondsPerQuestion
          : (saved.questionDeadline!.difference(now).inMilliseconds /
                    Duration.millisecondsPerSecond)
                .ceil();
      if (remaining <= 0) {
        phase = QuizSessionPhase.feedback;
        pausedRemaining = null;
      } else {
        final safeRemaining = remaining.clamp(
          1,
          saved.configuration.secondsPerQuestion,
        );
        deadline = now.add(Duration(seconds: safeRemaining));
        pausedRemaining = null;
      }
    }

    state = QuizSessionState(
      quiz: quiz,
      configuration: saved.configuration,
      kind: saved.kind,
      startedAt: saved.startedAt,
      questions: List.unmodifiable(restoredQuestions),
      currentIndex: saved.currentIndex,
      answers: Map.unmodifiable(saved.answers),
      selectedOptionId: saved.selectedOptionId,
      phase: phase,
      questionDeadline: deadline,
      pausedRemainingSeconds: pausedRemaining,
    );
    _persist();
    return true;
  }

  void selectAnswer(String optionId) {
    final session = state;
    if (session == null || session.phase != QuizSessionPhase.answering) {
      return;
    }
    if (!session.currentQuestion.options.any(
      (option) => option.id == optionId,
    )) {
      return;
    }
    state = session.copyWith(selectedOptionId: optionId);
    _persist();
  }

  bool start(
    Quiz quiz,
    QuizConfiguration configuration, {
    QuizSessionKind kind = QuizSessionKind.category,
  }) {
    final eligibleQuestions = quiz.questionsFor(configuration.difficulty);
    if (eligibleQuestions.isEmpty) {
      return false;
    }
    final random = ref.read(randomProvider);
    final questions = List<QuizQuestion>.of(eligibleQuestions)..shuffle(random);
    final requestedCount = configuration.questionCount;
    final selectedQuestions = requestedCount == null
        ? questions
        : questions.take(requestedCount).toList(growable: false);
    return _startWithQuestions(
      quiz: quiz,
      configuration: configuration,
      kind: kind,
      questions: selectedQuestions,
      random: random,
    );
  }

  bool startDaily({
    required List<Quiz> catalog,
    required DateTime date,
    required String title,
    required String description,
  }) {
    final questions = catalog
        .expand((quiz) => quiz.questions)
        .toList(growable: true);
    if (questions.isEmpty) {
      return false;
    }
    final seed = date.year * 10000 + date.month * 100 + date.day;
    questions.shuffle(Random(seed));
    final selected = questions.take(dailyQuestionCount).toList(growable: false);
    final quiz = Quiz(
      id: QuizSessionKind.daily.name,
      title: title,
      description: description,
      questions: selected,
    );
    return _startWithQuestions(
      quiz: quiz,
      configuration: const QuizConfiguration(
        difficulty: null,
        questionCount: dailyQuestionCount,
        mode: QuizMode.relaxed,
      ),
      kind: QuizSessionKind.daily,
      questions: selected,
      random: Random(seed),
    );
  }

  bool startQuestionSet({
    required List<Quiz> catalog,
    required Set<String> questionIds,
    required QuizSessionKind kind,
    required String title,
    required String description,
  }) {
    final questions = catalog
        .expand((quiz) => quiz.questions)
        .where((question) => questionIds.contains(question.id))
        .toList(growable: false);
    if (questions.isEmpty) {
      return false;
    }
    final quiz = Quiz(
      id: kind.name,
      title: title,
      description: description,
      questions: questions,
    );
    return start(
      quiz,
      QuizConfiguration(
        difficulty: null,
        questionCount: questions.length,
        mode: QuizMode.relaxed,
      ),
      kind: kind,
    );
  }

  void submitAnswer() {
    final session = state;
    final selectedOptionId = session?.selectedOptionId;
    if (session == null ||
        selectedOptionId == null ||
        session.phase != QuizSessionPhase.answering) {
      return;
    }

    state = session.copyWith(
      answers: Map.unmodifiable({
        ...session.answers,
        session.currentQuestion.id: selectedOptionId,
      }),
      phase: QuizSessionPhase.feedback,
      clearDeadline: true,
      clearPausedRemaining: true,
    );
    _persist();
  }

  QuizAttempt _buildAttempt(QuizSessionState session) {
    final completedAt = ref.read(nowProvider)();
    return QuizAttempt(
      id: completedAt.microsecondsSinceEpoch.toString(),
      kind: session.kind,
      sourceQuizId: session.kind == QuizSessionKind.category
          ? session.quiz.id
          : null,
      mode: session.configuration.mode,
      startedAt: session.startedAt,
      completedAt: completedAt,
      answers: session.questions
          .map(
            (question) => QuestionAttempt(
              questionId: question.id,
              categoryId: question.categoryId,
              difficulty: question.difficulty,
              selectedOptionId: session.answers[question.id],
              correctOptionId: question.correctOptionId,
            ),
          )
          .toList(growable: false),
    );
  }

  bool _startWithQuestions({
    required Quiz quiz,
    required QuizConfiguration configuration,
    required QuizSessionKind kind,
    required List<QuizQuestion> questions,
    required Random random,
  }) {
    if (questions.isEmpty) {
      return false;
    }
    final shuffledQuestions = questions
        .map((question) {
          final options = List<AnswerOption>.of(question.options)
            ..shuffle(random);
          return question.withOptions(options);
        })
        .toList(growable: false);
    final now = ref.read(nowProvider)();
    state = QuizSessionState(
      quiz: quiz,
      configuration: configuration,
      kind: kind,
      startedAt: now,
      questions: List.unmodifiable(shuffledQuestions),
      currentIndex: 0,
      answers: const {},
      selectedOptionId: null,
      phase: QuizSessionPhase.answering,
      questionDeadline: configuration.mode == QuizMode.timed
          ? now.add(Duration(seconds: configuration.secondsPerQuestion))
          : null,
      pausedRemainingSeconds: null,
    );
    _persist();
    return true;
  }

  void _persist() {
    final session = state;
    if (session == null || session.phase == QuizSessionPhase.completed) {
      return;
    }
    final saved = SavedQuizSession(
      kind: session.kind,
      sourceQuizId: session.kind == QuizSessionKind.category
          ? session.quiz.id
          : null,
      configuration: session.configuration,
      questionIds: session.questions
          .map((question) => question.id)
          .toList(growable: false),
      optionOrders: {
        for (final question in session.questions)
          question.id: question.options
              .map((option) => option.id)
              .toList(growable: false),
      },
      currentIndex: session.currentIndex,
      answers: session.answers,
      selectedOptionId: session.selectedOptionId,
      phase: session.phase,
      startedAt: session.startedAt,
      questionDeadline: session.questionDeadline,
      pausedRemainingSeconds: session.pausedRemainingSeconds,
    );
    unawaited(ref.read(learningControllerProvider.notifier).saveSession(saved));
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}

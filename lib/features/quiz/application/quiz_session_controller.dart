import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/quiz_models.dart';
import 'quiz_providers.dart';

enum QuizSessionPhase { answering, feedback, completed }

class QuizSessionState {
  const QuizSessionState({
    required this.quiz,
    required this.questions,
    required this.currentIndex,
    required this.answers,
    required this.selectedOptionId,
    required this.phase,
  });

  final Quiz quiz;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final Map<String, String> answers;
  final String? selectedOptionId;
  final QuizSessionPhase phase;

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

  QuizSessionState copyWith({
    int? currentIndex,
    Map<String, String>? answers,
    String? selectedOptionId,
    bool clearSelection = false,
    QuizSessionPhase? phase,
  }) {
    return QuizSessionState(
      quiz: quiz,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      selectedOptionId: clearSelection
          ? null
          : selectedOptionId ?? this.selectedOptionId,
      phase: phase ?? this.phase,
    );
  }
}

final randomProvider = Provider<Random>((ref) => Random());

final quizSessionControllerProvider =
    NotifierProvider<QuizSessionController, QuizSessionState?>(
      QuizSessionController.new,
    );

class QuizSessionController extends Notifier<QuizSessionState?> {
  @override
  QuizSessionState? build() => null;

  void discard() {
    state = null;
  }

  Future<bool> moveNext() async {
    final session = state;
    if (session == null || session.phase != QuizSessionPhase.feedback) {
      return false;
    }

    if (session.isLastQuestion) {
      state = session.copyWith(phase: QuizSessionPhase.completed);
      await ref
          .read(progressRepositoryProvider)
          .saveBestScore(session.quiz.id, session.correctAnswerCount);
      ref.invalidate(bestScoreProvider(session.quiz.id));
      return true;
    }

    state = session.copyWith(
      currentIndex: session.currentIndex + 1,
      clearSelection: true,
      phase: QuizSessionPhase.answering,
    );
    return false;
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
  }

  void start(Quiz quiz) {
    final random = ref.read(randomProvider);
    final questions = List<QuizQuestion>.of(quiz.questions)..shuffle(random);
    final shuffledQuestions = questions
        .map((question) {
          final options = List<AnswerOption>.of(question.options)
            ..shuffle(random);
          return question.withOptions(options);
        })
        .toList(growable: false);

    state = QuizSessionState(
      quiz: quiz,
      questions: List.unmodifiable(shuffledQuestions),
      currentIndex: 0,
      answers: const {},
      selectedOptionId: null,
      phase: QuizSessionPhase.answering,
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
    );
  }
}

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quizle/features/quiz/application/quiz_providers.dart';
import 'package:quizle/features/quiz/application/quiz_session_controller.dart';

import '../../../support/fakes.dart';

void main() {
  test('runs a complete session and persists the best score', () async {
    final preferences = MemoryPreferencesRepository();
    final container = ProviderContainer(
      overrides: [
        randomProvider.overrideWithValue(Random(7)),
        progressRepositoryProvider.overrideWithValue(preferences),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(quizSessionControllerProvider.notifier);

    controller.start(buildTestQuiz());

    var session = container.read(quizSessionControllerProvider)!;
    expect(session.phase, QuizSessionPhase.answering);
    expect(session.questions, hasLength(2));

    controller.selectAnswer(session.currentQuestion.correctOptionId);
    controller.submitAnswer();

    session = container.read(quizSessionControllerProvider)!;
    expect(session.phase, QuizSessionPhase.feedback);
    expect(session.correctAnswerCount, 1);
    expect(await controller.moveNext(), isFalse);

    session = container.read(quizSessionControllerProvider)!;
    controller.selectAnswer(session.currentQuestion.correctOptionId);
    controller.submitAnswer();

    expect(await controller.moveNext(), isTrue);
    session = container.read(quizSessionControllerProvider)!;
    expect(session.phase, QuizSessionPhase.completed);
    expect(session.scorePercent, 100);
    expect(preferences.bestScores['test_quiz'], 2);
  });

  test('ignores answer changes after feedback is shown', () {
    final container = ProviderContainer(
      overrides: [randomProvider.overrideWithValue(Random(3))],
    );
    addTearDown(container.dispose);
    final controller = container.read(quizSessionControllerProvider.notifier);

    controller.start(buildTestQuiz());
    final question = container
        .read(quizSessionControllerProvider)!
        .currentQuestion;
    controller.selectAnswer(question.correctOptionId);
    controller.submitAnswer();
    controller.selectAnswer(
      question.options
          .firstWhere((option) => option.id != question.correctOptionId)
          .id,
    );

    final session = container.read(quizSessionControllerProvider)!;
    expect(session.selectedOptionId, question.correctOptionId);
  });
}

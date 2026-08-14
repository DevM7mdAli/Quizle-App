import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quizle/features/progress/application/learning_controller.dart';
import 'package:quizle/features/quiz/application/quiz_session_controller.dart';
import 'package:quizle/features/quiz/domain/quiz_models.dart';

import '../../../support/fakes.dart';

void main() {
  test('runs a complete session and persists the attempt', () async {
    final learningRepository = MemoryLearningRepository();
    final container = ProviderContainer(
      overrides: [
        randomProvider.overrideWithValue(Random(7)),
        learningRepositoryProvider.overrideWithValue(learningRepository),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(quizSessionControllerProvider.notifier);

    controller.start(
      buildTestQuiz(),
      const QuizConfiguration(
        difficulty: null,
        questionCount: null,
        mode: QuizMode.relaxed,
      ),
    );

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
    expect(learningRepository.data.attempts, hasLength(1));
    expect(learningRepository.data.attempts.single.scorePercent, 100);
  });

  test('ignores answer changes after feedback is shown', () {
    final learningRepository = MemoryLearningRepository();
    final container = ProviderContainer(
      overrides: [
        randomProvider.overrideWithValue(Random(3)),
        learningRepositoryProvider.overrideWithValue(learningRepository),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(quizSessionControllerProvider.notifier);

    controller.start(
      buildTestQuiz(),
      const QuizConfiguration(
        difficulty: null,
        questionCount: null,
        mode: QuizMode.relaxed,
      ),
    );
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

  test('filters questions by difficulty and count', () {
    final container = ProviderContainer(
      overrides: [
        randomProvider.overrideWithValue(Random(3)),
        learningRepositoryProvider.overrideWithValue(
          MemoryLearningRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(quizSessionControllerProvider.notifier);

    controller.start(
      buildTestQuiz(),
      const QuizConfiguration(
        difficulty: QuizDifficulty.intermediate,
        questionCount: 1,
        mode: QuizMode.relaxed,
      ),
    );

    final session = container.read(quizSessionControllerProvider)!;
    expect(session.questions, hasLength(1));
    expect(session.questions.single.difficulty, QuizDifficulty.intermediate);
  });

  test('expires a timed question when its deadline passes', () {
    var now = DateTime(2026, 8, 14, 12);
    final container = ProviderContainer(
      overrides: [
        nowProvider.overrideWithValue(() => now),
        learningRepositoryProvider.overrideWithValue(
          MemoryLearningRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(quizSessionControllerProvider.notifier);

    controller.start(
      buildTestQuiz(),
      const QuizConfiguration(
        difficulty: null,
        questionCount: 1,
        mode: QuizMode.timed,
      ),
    );
    now = now.add(const Duration(seconds: 31));
    expect(
      container.read(quizSessionControllerProvider)!.remainingSeconds(now),
      0,
    );

    controller.expireCurrentQuestion();

    final session = container.read(quizSessionControllerProvider)!;
    expect(session.phase, QuizSessionPhase.feedback);
    expect(session.selectedOptionId, isNull);
  });

  test('restores an interrupted session from stable question IDs', () {
    final repository = MemoryLearningRepository();
    final firstContainer = ProviderContainer(
      overrides: [
        randomProvider.overrideWithValue(Random(4)),
        learningRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(firstContainer.dispose);
    final firstController = firstContainer.read(
      quizSessionControllerProvider.notifier,
    );
    final quiz = buildTestQuiz();
    firstController.start(
      quiz,
      const QuizConfiguration(
        difficulty: null,
        questionCount: null,
        mode: QuizMode.relaxed,
      ),
    );
    final selectedOption = firstContainer
        .read(quizSessionControllerProvider)!
        .currentQuestion
        .options
        .first
        .id;
    firstController.selectAnswer(selectedOption);
    firstController.pause();
    final savedLearning = firstContainer.read(learningControllerProvider);

    final restoredContainer = ProviderContainer(
      overrides: [
        initialLearningDataProvider.overrideWithValue(savedLearning),
        learningRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(restoredContainer.dispose);
    final restored = restoredContainer
        .read(quizSessionControllerProvider.notifier)
        .resume(
          catalog: [quiz],
          sessionTitle: 'Practice',
          sessionDescription: 'Practice session',
        );

    expect(restored, isTrue);
    expect(
      restoredContainer.read(quizSessionControllerProvider)!.selectedOptionId,
      selectedOption,
    );
  });
}

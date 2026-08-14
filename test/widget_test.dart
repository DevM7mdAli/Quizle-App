import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quizle/app/app.dart';
import 'package:quizle/features/progress/application/learning_controller.dart';
import 'package:quizle/features/quiz/application/quiz_providers.dart';
import 'package:quizle/features/quiz/application/quiz_session_controller.dart';
import 'package:quizle/features/settings/application/settings_controller.dart';
import 'package:quizle/features/settings/domain/app_settings.dart';

import 'support/fakes.dart';

void main() {
  testWidgets('completes a quiz and shows the result', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final preferences = MemoryPreferencesRepository();
    final learningRepository = MemoryLearningRepository();
    final container = ProviderContainer(
      overrides: [
        initialSettingsProvider.overrideWithValue(
          const AppSettings(
            locale: AppLocalePreference.english,
            themeMode: ThemeMode.light,
          ),
        ),
        preferencesRepositoryProvider.overrideWithValue(preferences),
        learningRepositoryProvider.overrideWithValue(learningRepository),
        quizRepositoryProvider.overrideWithValue(
          FakeQuizRepository([buildTestQuiz()]),
        ),
        randomProvider.overrideWithValue(Random(5)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const QuizleApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test your technology knowledge'), findsOneWidget);
    final startButton = find.text('Start quiz');
    await tester.ensureVisible(startButton);
    await tester.pumpAndSettle();
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    final beginButton = find.text('Begin quiz');
    await tester.ensureVisible(beginButton);
    await tester.tap(beginButton);
    await tester.pumpAndSettle();

    for (var index = 0; index < 2; index++) {
      final session = container.read(quizSessionControllerProvider)!;
      final correctOption = find.text(
        session.currentQuestion.correctOption.text,
      );
      await tester.ensureVisible(correctOption);
      await tester.pumpAndSettle();
      await tester.tap(correctOption);
      await tester.pump();
      final submitButton = find.text('Check answer');
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Correct answer'), findsOneWidget);
      final continueButton = find.text(
        index == 1 ? 'See results' : 'Next question',
      );
      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();
      await tester.tap(continueButton);
      await tester.pumpAndSettle();
    }

    expect(find.text('Excellent work'), findsOneWidget);
    expect(
      find.text('You answered 2 of 2 questions correctly.'),
      findsOneWidget,
    );
  });

  testWidgets('renders the home screen right to left in Arabic', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer(
      overrides: [
        initialSettingsProvider.overrideWithValue(
          const AppSettings(
            locale: AppLocalePreference.arabic,
            themeMode: ThemeMode.light,
          ),
        ),
        preferencesRepositoryProvider.overrideWithValue(
          MemoryPreferencesRepository(),
        ),
        learningRepositoryProvider.overrideWithValue(
          MemoryLearningRepository(),
        ),
        quizRepositoryProvider.overrideWithValue(
          FakeQuizRepository([buildTestQuiz()]),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const QuizleApp()),
    );
    await tester.pumpAndSettle();

    final title = find.text('اختبر معرفتك التقنية');
    expect(title, findsOneWidget);
    expect(Directionality.of(tester.element(title)), TextDirection.rtl);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('الإعدادات'));
    await tester.pumpAndSettle();

    expect(find.text('الإعدادات'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the progress dashboard on a narrow screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer(
      overrides: [
        initialSettingsProvider.overrideWithValue(
          const AppSettings(
            locale: AppLocalePreference.english,
            themeMode: ThemeMode.light,
          ),
        ),
        preferencesRepositoryProvider.overrideWithValue(
          MemoryPreferencesRepository(),
        ),
        learningRepositoryProvider.overrideWithValue(
          MemoryLearningRepository(),
        ),
        quizRepositoryProvider.overrideWithValue(
          FakeQuizRepository([buildTestQuiz()]),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const QuizleApp()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Progress'));
    await tester.pumpAndSettle();

    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

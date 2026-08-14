import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quizle/app/app.dart';
import 'package:quizle/features/onboarding/application/onboarding_controller.dart';
import 'package:quizle/features/progress/application/learning_controller.dart';
import 'package:quizle/features/quiz/application/quiz_providers.dart';
import 'package:quizle/features/quiz/application/quiz_session_controller.dart';
import 'package:quizle/features/quiz/domain/quiz_models.dart';
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
        initialOnboardingCompletedProvider.overrideWithValue(true),
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
    await _enterAppFromLanding(tester);

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
        initialOnboardingCompletedProvider.overrideWithValue(true),
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
    await _enterAppFromLanding(tester);

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
        initialOnboardingCompletedProvider.overrideWithValue(true),
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
    await _enterAppFromLanding(tester);
    await tester.tap(find.byTooltip('Progress'));
    await tester.pumpAndSettle();

    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loads a live category before starting its quiz', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const remoteCategory = Quiz(
      id: 'opentdb_science_computers',
      title: 'Computers',
      description: 'Fresh computer questions',
      questions: [],
      source: QuizSource.openTriviaDb,
      remoteCategoryId: 18,
    );
    const remoteQuestion = QuizQuestion(
      id: 'remote_cpu',
      categoryId: 'opentdb_science_computers',
      difficulty: QuizDifficulty.beginner,
      prompt: 'What does CPU stand for?',
      correctOptionId: 'central',
      explanation: 'Central processing unit is the answer.',
      options: [
        AnswerOption(id: 'central', text: 'Central processing unit'),
        AnswerOption(id: 'computer', text: 'Computer processing utility'),
      ],
      source: QuizSource.openTriviaDb,
    );
    final container = ProviderContainer(
      overrides: [
        initialOnboardingCompletedProvider.overrideWithValue(true),
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
          FakeQuizRepository([
            remoteCategory,
            buildTestQuiz(),
          ], loadedQuiz: remoteCategory.withQuestions([remoteQuestion])),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const QuizleApp()),
    );
    await tester.pumpAndSettle();
    await _enterAppFromLanding(tester);

    expect(find.text('Live trivia'), findsOneWidget);
    expect(find.text('Fresh online questions'), findsOneWidget);
    final remoteStartButton = find.text('Start quiz').first;
    await tester.ensureVisible(remoteStartButton);
    await tester.pumpAndSettle();
    await tester.tap(remoteStartButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Begin quiz'));
    await tester.pumpAndSettle();

    expect(find.text('What does CPU stand for?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows onboarding only after the web landing page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final preferences = MemoryPreferencesRepository();
    final container = ProviderContainer(
      overrides: [
        initialOnboardingCompletedProvider.overrideWithValue(false),
        initialSettingsProvider.overrideWithValue(
          const AppSettings(
            locale: AppLocalePreference.english,
            themeMode: ThemeMode.light,
          ),
        ),
        preferencesRepositoryProvider.overrideWithValue(preferences),
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

    if (kIsWeb) {
      expect(
        find.text('Turn a few spare minutes into real progress.'),
        findsOneWidget,
      );
      expect(
        find.text('A better quiz starts with a better question'),
        findsNothing,
      );
      await tester.tap(find.byKey(const Key('landing-primary-action')));
      await tester.pumpAndSettle();
    }

    expect(
      find.text('A better quiz starts with a better question'),
      findsOneWidget,
    );

    for (var page = 0; page < 3; page++) {
      final action = find.byKey(const Key('onboarding-primary-action'));
      await tester.ensureVisible(action);
      await tester.tap(action);
      await tester.pumpAndSettle();
    }

    expect(preferences.onboardingCompleted, isTrue);
    expect(find.text('Test your technology knowledge'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the first-run experience on a narrow Arabic screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer(
      overrides: [
        initialOnboardingCompletedProvider.overrideWithValue(false),
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

    if (kIsWeb) {
      expect(find.text('حوّل دقائقك المتاحة إلى تقدم حقيقي.'), findsOneWidget);
      expect(find.text('الاختبار الأفضل يبدأ بسؤال أفضل'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const Key('landing-primary-action')));
      await tester.pumpAndSettle();
    }

    final title = find.text('الاختبار الأفضل يبدأ بسؤال أفضل');
    expect(title, findsOneWidget);
    expect(Directionality.of(tester.element(title)), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _enterAppFromLanding(WidgetTester tester) async {
  if (!kIsWeb) {
    return;
  }
  await tester.tap(find.byKey(const Key('landing-primary-action')));
  await tester.pumpAndSettle();
}

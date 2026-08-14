import 'package:flutter_test/flutter_test.dart';

import 'package:quizle/features/progress/domain/learning_models.dart';
import 'package:quizle/features/quiz/domain/quiz_models.dart';

void main() {
  test('resolves incorrect questions from the latest answer state', () {
    final firstAttempt = _attempt(
      id: 'first',
      completedAt: DateTime(2026, 8, 10),
      answers: [
        _answer(questionId: 'q1', selectedOptionId: 'wrong'),
        _answer(questionId: 'q2', selectedOptionId: 'wrong'),
      ],
    );
    final secondAttempt = _attempt(
      id: 'second',
      completedAt: DateTime(2026, 8, 11),
      answers: [_answer(questionId: 'q1', selectedOptionId: 'correct')],
    );
    final learning = LearningData(
      attempts: [secondAttempt, firstAttempt],
      bookmarkedQuestionIds: const {},
      savedSession: null,
    );

    expect(learning.unresolvedIncorrectQuestionIds, {'q2'});
  });

  test('calculates daily streaks and achievement unlocks', () {
    final learning = LearningData(
      attempts: [
        _attempt(
          id: 'third',
          completedAt: DateTime(2026, 8, 14, 9),
          kind: QuizSessionKind.daily,
          answers: [_answer(questionId: 'q3', categoryId: 'category_three')],
        ),
        _attempt(
          id: 'second',
          completedAt: DateTime(2026, 8, 13, 9),
          kind: QuizSessionKind.daily,
          answers: [_answer(questionId: 'q2', categoryId: 'category_two')],
        ),
        _attempt(
          id: 'first',
          completedAt: DateTime(2026, 8, 12, 9),
          kind: QuizSessionKind.daily,
          answers: [_answer(questionId: 'q1', categoryId: 'category_one')],
        ),
      ],
      bookmarkedQuestionIds: const {},
      savedSession: null,
    );

    expect(learning.dailyStreak(DateTime(2026, 8, 14)), 3);
    expect(
      learning.unlockedAchievements(DateTime(2026, 8, 14)),
      containsAll({
        AchievementType.firstQuiz,
        AchievementType.perfectScore,
        AchievementType.categoryExplorer,
        AchievementType.threeDayStreak,
      }),
    );
  });
}

QuizAttempt _attempt({
  required String id,
  required DateTime completedAt,
  required List<QuestionAttempt> answers,
  QuizSessionKind kind = QuizSessionKind.category,
}) {
  return QuizAttempt(
    id: id,
    kind: kind,
    sourceQuizId: kind == QuizSessionKind.category ? 'category_one' : null,
    mode: QuizMode.relaxed,
    startedAt: completedAt.subtract(const Duration(minutes: 2)),
    completedAt: completedAt,
    answers: answers,
  );
}

QuestionAttempt _answer({
  required String questionId,
  String categoryId = 'category_one',
  String? selectedOptionId = 'correct',
}) {
  return QuestionAttempt(
    questionId: questionId,
    categoryId: categoryId,
    difficulty: QuizDifficulty.beginner,
    selectedOptionId: selectedOptionId,
    correctOptionId: 'correct',
  );
}

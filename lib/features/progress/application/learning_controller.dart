import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/learning_repository.dart';
import '../domain/learning_models.dart';

final initialLearningDataProvider = Provider<LearningData>(
  (ref) => const LearningData.empty(),
);

final learningRepositoryProvider = Provider<LearningRepository>(
  (ref) => SharedPreferencesLearningRepository(SharedPreferencesAsync()),
);

final learningControllerProvider =
    NotifierProvider<LearningController, LearningData>(LearningController.new);

final bestScoreProvider = Provider.family<int?, String>((ref, quizId) {
  return ref.watch(
    learningControllerProvider.select((data) => data.bestScorePercent(quizId)),
  );
});

class LearningController extends Notifier<LearningData> {
  static const _maximumAttemptCount = 200;

  @override
  LearningData build() => ref.watch(initialLearningDataProvider);

  Future<void> clearSavedSession() async {
    state = state.copyWith(clearSavedSession: true);
    await ref.read(learningRepositoryProvider).saveSession(null);
  }

  Future<void> recordAttempt(QuizAttempt attempt) async {
    final attempts = [attempt, ...state.attempts];
    if (attempts.length > _maximumAttemptCount) {
      attempts.removeRange(_maximumAttemptCount, attempts.length);
    }
    state = state.copyWith(attempts: List.unmodifiable(attempts));
    await ref.read(learningRepositoryProvider).saveAttempts(state.attempts);
  }

  Future<void> saveSession(SavedQuizSession session) async {
    state = state.copyWith(savedSession: session);
    await ref.read(learningRepositoryProvider).saveSession(session);
  }

  Future<void> toggleBookmark(String questionId) async {
    final bookmarks = {...state.bookmarkedQuestionIds};
    if (!bookmarks.remove(questionId)) {
      bookmarks.add(questionId);
    }
    state = state.copyWith(bookmarkedQuestionIds: Set.unmodifiable(bookmarks));
    await ref
        .read(learningRepositoryProvider)
        .saveBookmarks(state.bookmarkedQuestionIds);
  }
}

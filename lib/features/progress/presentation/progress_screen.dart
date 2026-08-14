import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/content_width.dart';
import '../../../l10n/app_localizations.dart';
import '../../quiz/application/quiz_providers.dart';
import '../../quiz/application/quiz_session_controller.dart';
import '../../quiz/domain/quiz_models.dart';
import '../application/learning_controller.dart';
import '../domain/learning_models.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final catalog = ref.watch(quizCatalogProvider(languageCode));
    final learning = ref.watch(learningControllerProvider);
    final totalAnswers = learning.attempts.fold<int>(
      0,
      (total, attempt) => total + attempt.answers.length,
    );
    final correctAnswers = learning.attempts.fold<int>(
      0,
      (total, attempt) => total + attempt.correctAnswerCount,
    );
    final accuracy = totalAnswers == 0
        ? 0
        : ((correctAnswers / totalAnswers) * 100).round();
    final today = ref.read(nowProvider)();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.progress)),
      body: ListView(
        children: [
          ContentWidth(
            maxWidth: 960,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.overview,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 14),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisExtent: 140,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: [
                    _StatCard(
                      icon: Icons.flag_rounded,
                      label: l10n.attempts,
                      value: '${learning.attempts.length}',
                    ),
                    _StatCard(
                      icon: Icons.track_changes_rounded,
                      label: l10n.accuracy,
                      value: l10n.scorePercent(accuracy),
                    ),
                    _StatCard(
                      icon: Icons.check_circle_rounded,
                      label: l10n.correctAnswersStat,
                      value: '$correctAnswers/$totalAnswers',
                    ),
                    _StatCard(
                      icon: Icons.local_fire_department_rounded,
                      label: l10n.dailyStreak,
                      value: l10n.dayStreak(learning.dailyStreak(today)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.categoryPerformance,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 14),
                catalog.when(
                  data: (quizzes) => _CategoryProgress(
                    quizzes: quizzes,
                    attempts: learning.attempts,
                  ),
                  error: (error, stackTrace) => Text(l10n.loadFailure),
                  loading: () => const LinearProgressIndicator(),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.achievements,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 14),
                _Achievements(unlocked: learning.unlockedAchievements(today)),
                const SizedBox(height: 32),
                Text(
                  l10n.recentActivity,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 14),
                if (learning.attempts.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l10n.noHistory, textAlign: TextAlign.center),
                    ),
                  )
                else
                  catalog.when(
                    data: (quizzes) => _HistoryList(
                      attempts: learning.attempts.take(20).toList(),
                      quizzes: quizzes,
                    ),
                    error: (error, stackTrace) => Text(l10n.loadFailure),
                    loading: () => const LinearProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  const _CategoryProgress({required this.quizzes, required this.attempts});

  final List<Quiz> quizzes;
  final List<QuizAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            for (var index = 0; index < quizzes.length; index++) ...[
              _CategoryProgressRow(quiz: quizzes[index], attempts: attempts),
              if (index < quizzes.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),
            ],
            if (quizzes.isEmpty) Text(l10n.loadFailure),
          ],
        ),
      ),
    );
  }
}

class _CategoryProgressRow extends StatelessWidget {
  const _CategoryProgressRow({required this.quiz, required this.attempts});

  final Quiz quiz;
  final List<QuizAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final answers = attempts
        .expand((attempt) => attempt.answers)
        .where((answer) => answer.categoryId == quiz.id)
        .toList();
    final correct = answers.where((answer) => answer.isCorrect).length;
    final accuracy = answers.isEmpty ? 0.0 : correct / answers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                quiz.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(l10n.scorePercent((accuracy * 100).round())),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: accuracy,
          minHeight: 8,
          borderRadius: BorderRadius.circular(999),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.questionsCount(answers.length),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Achievements extends StatelessWidget {
  const _Achievements({required this.unlocked});

  final Set<AchievementType> unlocked;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AchievementType.values.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 390,
        mainAxisExtent: 150,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final achievement = AchievementType.values[index];
        return _AchievementCard(
          achievement: achievement,
          isUnlocked: unlocked.contains(achievement),
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement, required this.isUnlocked});

  final AchievementType achievement;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final (title, description, icon) = switch (achievement) {
      AchievementType.firstQuiz => (
        l10n.achievementFirstQuiz,
        l10n.achievementFirstQuizDescription,
        Icons.emoji_flags_rounded,
      ),
      AchievementType.perfectScore => (
        l10n.achievementPerfectScore,
        l10n.achievementPerfectScoreDescription,
        Icons.workspace_premium_rounded,
      ),
      AchievementType.fiveQuizzes => (
        l10n.achievementFiveQuizzes,
        l10n.achievementFiveQuizzesDescription,
        Icons.trending_up_rounded,
      ),
      AchievementType.categoryExplorer => (
        l10n.achievementCategoryExplorer,
        l10n.achievementCategoryExplorerDescription,
        Icons.explore_rounded,
      ),
      AchievementType.threeDayStreak => (
        l10n.achievementThreeDayStreak,
        l10n.achievementThreeDayStreakDescription,
        Icons.local_fire_department_rounded,
      ),
    };

    return Card(
      color: isUnlocked ? colorScheme.tertiaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isUnlocked ? icon : Icons.lock_outline_rounded,
              color: isUnlocked
                  ? colorScheme.onTertiaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    isUnlocked ? l10n.unlocked : l10n.locked,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.attempts, required this.quizzes});

  final List<QuizAttempt> attempts;
  final List<Quiz> quizzes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (var index = 0; index < attempts.length; index++) ...[
            _HistoryTile(attempt: attempts[index], quizzes: quizzes),
            if (index < attempts.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.attempt, required this.quizzes});

  final QuizAttempt attempt;
  final List<Quiz> quizzes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formatter = DateFormat.yMMMd(locale).add_jm();
    final category = _findQuiz(attempt.sourceQuizId);
    final title =
        category?.title ??
        switch (attempt.kind) {
          QuizSessionKind.category => l10n.categoryQuiz,
          QuizSessionKind.daily => l10n.dailyQuiz,
          QuizSessionKind.incorrect => l10n.incorrectPractice,
          QuizSessionKind.bookmarked => l10n.bookmarkPractice,
        };

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          _kindIcon(attempt.kind),
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        '${formatter.format(attempt.completedAt.toLocal())} · '
        '${attempt.mode == QuizMode.timed ? l10n.timedMode : l10n.relaxedMode}',
      ),
      trailing: Text(
        l10n.scorePercent(attempt.scorePercent),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }

  Quiz? _findQuiz(String? id) {
    for (final quiz in quizzes) {
      if (quiz.id == id) {
        return quiz;
      }
    }
    return null;
  }

  IconData _kindIcon(QuizSessionKind kind) {
    return switch (kind) {
      QuizSessionKind.category => Icons.category_rounded,
      QuizSessionKind.daily => Icons.today_rounded,
      QuizSessionKind.incorrect => Icons.replay_rounded,
      QuizSessionKind.bookmarked => Icons.bookmark_rounded,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/content_width.dart';
import '../../../l10n/app_localizations.dart';
import '../../progress/application/learning_controller.dart';
import '../application/quiz_providers.dart';
import '../application/quiz_session_controller.dart';
import '../domain/quiz_models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final catalog = ref.watch(quizCatalogProvider(locale.languageCode));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            tooltip: l10n.progress,
            onPressed: () => context.push('/progress'),
            icon: const Icon(Icons.insights_rounded),
          ),
          IconButton(
            tooltip: l10n.settings,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(quizCatalogProvider(locale.languageCode));
          await ref.read(quizCatalogProvider(locale.languageCode).future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroPanel(l10n: l10n),
                  const SizedBox(height: 28),
                  catalog.when(
                    data: (quizzes) => _HomeContent(quizzes: quizzes),
                    error: (error, stackTrace) => _LoadFailure(
                      onRetry: () {
                        ref.invalidate(
                          quizCatalogProvider(locale.languageCode),
                        );
                      },
                    ),
                    loading: () => const _LoadingCatalog(),
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

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.quizzes});

  final List<Quiz> quizzes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final learning = ref.watch(learningControllerProvider);
    final today = ref.read(nowProvider)();
    final savedSession = learning.savedSession;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (savedSession != null) ...[
          _ContinueCard(
            currentQuestion: savedSession.currentIndex + 1,
            totalQuestions: savedSession.questionIds.length,
            onResume: () {
              final started = ref
                  .read(quizSessionControllerProvider.notifier)
                  .resume(
                    catalog: quizzes,
                    sessionTitle: _sessionTitle(l10n, savedSession.kind),
                    sessionDescription: _sessionDescription(
                      l10n,
                      savedSession.kind,
                    ),
                  );
              if (started) {
                context.go('/quiz');
              }
            },
            onDiscard: () {
              ref.read(quizSessionControllerProvider.notifier).discard();
            },
          ),
          const SizedBox(height: 28),
        ],
        Text(
          l10n.overview,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 390,
            mainAxisExtent: 240,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          children: [
            _QuickActionCard(
              icon: Icons.today_rounded,
              title: l10n.dailyQuiz,
              description: learning.completedDailyQuiz(today)
                  ? l10n.dailyCompleted
                  : l10n.dailyQuizDescription,
              supportingText: l10n.dayStreak(learning.dailyStreak(today)),
              actionLabel: learning.completedDailyQuiz(today)
                  ? l10n.dailyCompleted
                  : l10n.startDailyQuiz,
              onPressed: learning.completedDailyQuiz(today)
                  ? null
                  : () {
                      final started = ref
                          .read(quizSessionControllerProvider.notifier)
                          .startDaily(
                            catalog: quizzes,
                            date: today,
                            title: l10n.dailyQuiz,
                            description: l10n.dailyQuizDescription,
                          );
                      if (started) {
                        context.go('/quiz');
                      }
                    },
            ),
            _QuickActionCard(
              icon: Icons.replay_circle_filled_rounded,
              title: l10n.practiceIncorrect,
              description: learning.unresolvedIncorrectQuestionIds.isEmpty
                  ? l10n.noIncorrectQuestions
                  : l10n.practiceIncorrectDescription(
                      learning.unresolvedIncorrectQuestionIds.length,
                    ),
              actionLabel: l10n.practiceIncorrect,
              onPressed: learning.unresolvedIncorrectQuestionIds.isEmpty
                  ? null
                  : () {
                      final started = ref
                          .read(quizSessionControllerProvider.notifier)
                          .startQuestionSet(
                            catalog: quizzes,
                            questionIds:
                                learning.unresolvedIncorrectQuestionIds,
                            kind: QuizSessionKind.incorrect,
                            title: l10n.incorrectPractice,
                            description: l10n.practiceIncorrect,
                          );
                      if (started) {
                        context.go('/quiz');
                      }
                    },
            ),
            _QuickActionCard(
              icon: Icons.bookmark_rounded,
              title: l10n.bookmarkedQuestions,
              description: learning.bookmarkedQuestionIds.isEmpty
                  ? l10n.noBookmarkedQuestions
                  : l10n.bookmarkedDescription(
                      learning.bookmarkedQuestionIds.length,
                    ),
              actionLabel: l10n.bookmarkedQuestions,
              onPressed: learning.bookmarkedQuestionIds.isEmpty
                  ? null
                  : () {
                      final started = ref
                          .read(quizSessionControllerProvider.notifier)
                          .startQuestionSet(
                            catalog: quizzes,
                            questionIds: learning.bookmarkedQuestionIds,
                            kind: QuizSessionKind.bookmarked,
                            title: l10n.bookmarkPractice,
                            description: l10n.bookmarkedQuestions,
                          );
                      if (started) {
                        context.go('/quiz');
                      }
                    },
            ),
            _QuickActionCard(
              icon: Icons.insights_rounded,
              title: l10n.progressDashboard,
              description: learning.attempts.isEmpty
                  ? l10n.noHistory
                  : l10n.questionsCount(
                      learning.attempts.fold<int>(
                        0,
                        (total, attempt) => total + attempt.answers.length,
                      ),
                    ),
              actionLabel: l10n.viewProgress,
              onPressed: () => context.push('/progress'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          l10n.categories,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        if (quizzes.isEmpty)
          _LoadFailure(onRetry: () {})
        else
          for (var index = 0; index < quizzes.length; index++) ...[
            _QuizCard(quiz: quizzes[index]),
            if (index < quizzes.length - 1) const SizedBox(height: 16),
          ],
      ],
    );
  }

  String _sessionTitle(AppLocalizations l10n, QuizSessionKind kind) {
    return switch (kind) {
      QuizSessionKind.category => l10n.categoryQuiz,
      QuizSessionKind.daily => l10n.dailyQuiz,
      QuizSessionKind.incorrect => l10n.incorrectPractice,
      QuizSessionKind.bookmarked => l10n.bookmarkPractice,
    };
  }

  String _sessionDescription(AppLocalizations l10n, QuizSessionKind kind) {
    return switch (kind) {
      QuizSessionKind.category => l10n.availableQuizzes,
      QuizSessionKind.daily => l10n.dailyQuizDescription,
      QuizSessionKind.incorrect => l10n.practiceIncorrect,
      QuizSessionKind.bookmarked => l10n.bookmarkedQuestions,
    };
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final quizColors = context.quizColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [quizColors.heroStart, quizColors.heroEnd],
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 28, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.homeEyebrow,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.homeTitle,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.homeDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.currentQuestion,
    required this.totalQuestions,
    required this.onResume,
    required this.onDiscard,
  });

  final int currentQuestion;
  final int totalQuestions;
  final VoidCallback onResume;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.play_circle_fill_rounded,
              size: 34,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.continueQuiz,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.continueQuizDescription(
                      currentQuestion,
                      totalQuestions,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      FilledButton(
                        onPressed: onResume,
                        child: Text(l10n.resumeQuiz),
                      ),
                      TextButton(
                        onPressed: onDiscard,
                        child: Text(l10n.abandonQuiz),
                      ),
                    ],
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

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
    this.supportingText,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? supportingText;
  final String actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary, size: 28),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (supportingText != null)
              Text(
                supportingText!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(onPressed: onPressed, child: Text(actionLabel)),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends ConsumerWidget {
  const _QuizCard({required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bestScore = ref.watch(bestScoreProvider(quiz.id));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 640;
          final image = Image.asset(
            quiz.imageAsset,
            fit: BoxFit.cover,
            semanticLabel: quiz.questions.first.imageDescription,
          );
          final content = Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      icon: Icons.layers_rounded,
                      label: l10n.allDifficulties,
                    ),
                    _InfoChip(
                      icon: Icons.help_outline_rounded,
                      label: l10n.questionsCount(quiz.questions.length),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(quiz.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  quiz.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (compact)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        bestScore == null
                            ? l10n.notPlayedYet
                            : l10n.bestScorePercent(bestScore),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: () => context.push('/setup/${quiz.id}'),
                        icon: const Icon(Icons.tune_rounded),
                        label: Text(l10n.startQuiz),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          bestScore == null
                              ? l10n.notPlayedYet
                              : l10n.bestScorePercent(bestScore),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => context.push('/setup/${quiz.id}'),
                        icon: const Icon(Icons.tune_rounded),
                        label: Text(l10n.startQuiz),
                      ),
                    ],
                  ),
              ],
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(aspectRatio: 2.4, child: image),
                SizedBox(height: 385, child: content),
              ],
            );
          }
          return SizedBox(
            height: 285,
            child: Row(
              children: [
                SizedBox(width: 250, child: image),
                Expanded(child: content),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 12, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.onSecondaryContainer),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCatalog extends StatelessWidget {
  const _LoadingCatalog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.loadingQuizzes,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 36,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(l10n.loadFailure, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: Text(l10n.tryAgain)),
          ],
        ),
      ),
    );
  }
}

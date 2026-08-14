import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_paths.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/content_width.dart';
import '../../../l10n/app_localizations.dart';
import '../application/quiz_session_controller.dart';
import '../domain/quiz_models.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(quizSessionControllerProvider);

    if (session == null || session.phase != QuizSessionPhase.completed) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.results)),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go(AppPaths.home),
            child: Text(l10n.backHome),
          ),
        ),
      );
    }

    final resultTitle = switch (session.scorePercent) {
      >= 80 => l10n.excellentResult,
      >= 50 => l10n.goodResult,
      _ => l10n.practiceResult,
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(quizSessionControllerProvider.notifier).discard();
          context.go(AppPaths.home);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l10n.results),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            children: [
              ContentWidth(
                maxWidth: 640,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          children: [
                            _ScoreIndicator(percent: session.scorePercent),
                            const SizedBox(height: 24),
                            Text(
                              resultTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.scoreSummary(
                                session.correctAnswerCount,
                                session.questions.length,
                              ),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => context.push('/review'),
                      icon: const Icon(Icons.fact_check_outlined),
                      label: Text(l10n.reviewAnswers),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        ref
                            .read(quizSessionControllerProvider.notifier)
                            .start(
                              session.quiz,
                              session.configuration,
                              kind: session.kind,
                            );
                        context.go('/quiz');
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.retryQuiz),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(quizSessionControllerProvider.notifier)
                            .discard();
                        context.go(AppPaths.home);
                      },
                      child: Text(l10n.backHome),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreIndicator extends StatelessWidget {
  const _ScoreIndicator({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quizColors = context.quizColors;
    return SizedBox.square(
      dimension: 148,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: percent / 100),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  color: quizColors.success,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
              Text(
                l10n.scorePercent((value * 100).round()),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          );
        },
      ),
    );
  }
}

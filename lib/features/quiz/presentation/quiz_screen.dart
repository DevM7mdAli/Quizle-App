import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/content_width.dart';
import '../../../l10n/app_localizations.dart';
import '../application/quiz_session_controller.dart';
import '../domain/quiz_models.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(quizSessionControllerProvider);

    if (session == null || session.phase == QuizSessionPhase.completed) {
      return _UnavailableQuiz(l10n: l10n);
    }

    final question = session.currentQuestion;
    final progress = (session.currentIndex + 1) / session.questions.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _confirmQuit(context, ref);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: l10n.quit,
            onPressed: () => _confirmQuit(context, ref),
            icon: const Icon(Icons.close_rounded),
          ),
          title: Text(
            l10n.questionProgress(
              session.currentIndex + 1,
              session.questions.length,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      label: l10n.questionProgress(
                        session.currentIndex + 1,
                        session.questions.length,
                      ),
                      value: l10n.scorePercent((progress * 100).round()),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 2,
                        child: Image.asset(
                          question.imageAsset,
                          fit: BoxFit.cover,
                          semanticLabel: question.imageDescription,
                          errorBuilder: (context, error, stackTrace) {
                            return ColoredBox(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHigh,
                              child: const Center(
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      question.prompt,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.chooseAnswer,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (
                      var index = 0;
                      index < question.options.length;
                      index++
                    ) ...[
                      _AnswerCard(
                        index: index,
                        option: question.options[index],
                        question: question,
                        selectedOptionId: session.selectedOptionId,
                        phase: session.phase,
                        onTap: () {
                          ref
                              .read(quizSessionControllerProvider.notifier)
                              .selectAnswer(question.options[index].id);
                        },
                      ),
                      if (index < question.options.length - 1)
                        const SizedBox(height: 12),
                    ],
                    if (session.phase == QuizSessionPhase.feedback) ...[
                      const SizedBox(height: 20),
                      _FeedbackPanel(session: session),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: session.phase == QuizSessionPhase.feedback
                          ? () => _moveNext(context, ref)
                          : session.selectedOptionId == null
                          ? null
                          : () {
                              ref
                                  .read(quizSessionControllerProvider.notifier)
                                  .submitAnswer();
                            },
                      child: Text(
                        session.phase == QuizSessionPhase.feedback
                            ? session.isLastQuestion
                                  ? l10n.seeResults
                                  : l10n.nextQuestion
                            : l10n.submitAnswer,
                      ),
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

  Future<void> _confirmQuit(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final shouldQuit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.quitQuiz),
        content: Text(l10n.quitQuizMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.quit),
          ),
        ],
      ),
    );

    if (shouldQuit == true && context.mounted) {
      ref.read(quizSessionControllerProvider.notifier).discard();
      context.go('/');
    }
  }

  Future<void> _moveNext(BuildContext context, WidgetRef ref) async {
    final completed = await ref
        .read(quizSessionControllerProvider.notifier)
        .moveNext();
    if (completed && context.mounted) {
      context.go('/results');
    }
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({
    required this.index,
    required this.option,
    required this.question,
    required this.selectedOptionId,
    required this.phase,
    required this.onTap,
  });

  final int index;
  final AnswerOption option;
  final QuizQuestion question;
  final String? selectedOptionId;
  final QuizSessionPhase phase;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final quizColors = context.quizColors;
    final isSelected = selectedOptionId == option.id;
    final isFeedback = phase == QuizSessionPhase.feedback;
    final isCorrect = option.id == question.correctOptionId;

    final Color backgroundColor;
    final Color foregroundColor;
    final Color borderColor;
    final IconData? statusIcon;

    if (isFeedback && isCorrect) {
      backgroundColor = quizColors.successContainer;
      foregroundColor = quizColors.onSuccessContainer;
      borderColor = quizColors.success;
      statusIcon = Icons.check_circle_rounded;
    } else if (isFeedback && isSelected) {
      backgroundColor = colorScheme.errorContainer;
      foregroundColor = colorScheme.onErrorContainer;
      borderColor = colorScheme.error;
      statusIcon = Icons.cancel_rounded;
    } else if (isSelected) {
      backgroundColor = colorScheme.primaryContainer;
      foregroundColor = colorScheme.onPrimaryContainer;
      borderColor = colorScheme.primary;
      statusIcon = Icons.radio_button_checked_rounded;
    } else {
      backgroundColor = colorScheme.surfaceContainerLow;
      foregroundColor = colorScheme.onSurface;
      borderColor = colorScheme.outlineVariant;
      statusIcon = null;
    }

    return Semantics(
      button: !isFeedback,
      selected: isSelected,
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isFeedback ? null : onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 18, 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: foregroundColor.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: foregroundColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    option.text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (statusIcon != null) ...[
                  const SizedBox(width: 12),
                  Icon(statusIcon, color: foregroundColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel({required this.session});

  final QuizSessionState session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final quizColors = context.quizColors;
    final isCorrect = session.isSelectionCorrect;
    final backgroundColor = isCorrect
        ? quizColors.successContainer
        : colorScheme.errorContainer;
    final foregroundColor = isCorrect
        ? quizColors.onSuccessContainer
        : colorScheme.onErrorContainer;

    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                    color: foregroundColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isCorrect
                          ? l10n.correctAnswerFeedback
                          : l10n.incorrectAnswerFeedback,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: foregroundColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.explanation,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                session.currentQuestion.explanation,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: foregroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnavailableQuiz extends StatelessWidget {
  const _UnavailableQuiz({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: ContentWidth(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.quiz_outlined, size: 48),
              const SizedBox(height: 16),
              Text(l10n.quizUnavailable),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go('/'),
                child: Text(l10n.backHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

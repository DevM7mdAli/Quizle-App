import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_paths.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/content_width.dart';
import '../../../l10n/app_localizations.dart';
import '../../progress/application/learning_controller.dart';
import '../application/quiz_session_controller.dart';
import '../domain/quiz_models.dart';
import 'widgets/quiz_artwork.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => _refreshTimer(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(quizSessionControllerProvider);

    if (session == null || session.phase == QuizSessionPhase.completed) {
      return _UnavailableQuiz(l10n: l10n);
    }

    final question = session.currentQuestion;
    final progress = (session.currentIndex + 1) / session.questions.length;
    final bookmarks = ref.watch(
      learningControllerProvider.select((data) => data.bookmarkedQuestionIds),
    );
    final isBookmarked = bookmarks.contains(question.id);
    final remainingSeconds = session.remainingSeconds(ref.read(nowProvider)());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _confirmQuit();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: l10n.quit,
            onPressed: _confirmQuit,
            icon: const Icon(Icons.close_rounded),
          ),
          title: Text(
            l10n.questionProgress(
              session.currentIndex + 1,
              session.questions.length,
            ),
          ),
          actions: [
            IconButton(
              tooltip: isBookmarked
                  ? l10n.removeBookmark
                  : l10n.bookmarkQuestion,
              onPressed: () {
                ref
                    .read(learningControllerProvider.notifier)
                    .toggleBookmark(question.id);
              },
              icon: Icon(
                isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
              ),
            ),
            const SizedBox(width: 8),
          ],
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
                    if (remainingSeconds != null) ...[
                      const SizedBox(height: 14),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: _TimerPill(seconds: remainingSeconds),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 2,
                        child: QuizArtwork(
                          categoryId: question.categoryId,
                          imageAsset: question.imageAsset,
                          semanticLabel: question.imageDescription.isEmpty
                              ? question.prompt
                              : question.imageDescription,
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
                          ? _moveNext
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

  Future<void> _confirmQuit() async {
    final l10n = AppLocalizations.of(context);
    final choice = await showDialog<_QuitChoice>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.quitQuiz),
        content: Text(l10n.quitQuizMessageSaved),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(_QuitChoice.abandon),
            child: Text(l10n.abandonQuiz),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_QuitChoice.save),
            child: Text(l10n.saveAndExit),
          ),
        ],
      ),
    );

    if (!mounted || choice == null) {
      return;
    }
    final controller = ref.read(quizSessionControllerProvider.notifier);
    if (choice == _QuitChoice.save) {
      controller.pause();
    } else {
      controller.discard();
    }
    context.go(AppPaths.home);
  }

  Future<void> _moveNext() async {
    final completed = await ref
        .read(quizSessionControllerProvider.notifier)
        .moveNext();
    if (completed && mounted) {
      context.go('/results');
    }
  }

  void _refreshTimer() {
    if (!mounted) {
      return;
    }
    final session = ref.read(quizSessionControllerProvider);
    if (session?.configuration.mode != QuizMode.timed ||
        session?.phase != QuizSessionPhase.answering) {
      return;
    }
    final remaining = session!.remainingSeconds(ref.read(nowProvider)());
    if (remaining == 0) {
      ref.read(quizSessionControllerProvider.notifier).expireCurrentQuestion();
    } else {
      setState(() {});
    }
  }
}

enum _QuitChoice { save, abandon }

class _TimerPill extends StatelessWidget {
  const _TimerPill({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final urgent = seconds <= 10;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: urgent
            ? colorScheme.errorContainer
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 14, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_outlined,
              size: 18,
              color: urgent
                  ? colorScheme.onErrorContainer
                  : colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 7),
            Text(
              l10n.secondsRemaining(seconds),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: urgent
                    ? colorScheme.onErrorContainer
                    : colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
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
    final timedOut = session.selectedOptionId == null;
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
                      timedOut
                          ? l10n.timeExpired
                          : isCorrect
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
                onPressed: () => context.go(AppPaths.home),
                child: Text(l10n.backHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

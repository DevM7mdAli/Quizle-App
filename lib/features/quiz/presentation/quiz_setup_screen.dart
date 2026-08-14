import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/content_width.dart';
import '../../../l10n/app_localizations.dart';
import '../application/quiz_providers.dart';
import '../application/quiz_session_controller.dart';
import '../data/open_trivia_db_client.dart';
import '../domain/quiz_models.dart';

class QuizSetupScreen extends ConsumerStatefulWidget {
  const QuizSetupScreen({required this.quizId, super.key});

  final String quizId;

  @override
  ConsumerState<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends ConsumerState<QuizSetupScreen> {
  QuizConfiguration _configuration = const QuizConfiguration.defaults();
  bool _isLoadingQuestions = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final catalog = ref.watch(quizCatalogProvider(languageCode));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizSetup)),
      body: catalog.when(
        data: (quizzes) {
          final quiz = _findQuiz(quizzes, widget.quizId);
          if (quiz == null) {
            return _UnavailableQuiz(message: l10n.quizUnavailable);
          }
          return _buildSetup(context, quiz);
        },
        error: (error, stackTrace) =>
            _UnavailableQuiz(message: l10n.loadFailure),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildSetup(BuildContext context, Quiz quiz) {
    final l10n = AppLocalizations.of(context);
    final availableQuestions = quiz.questionsFor(_configuration.difficulty);
    final questionCounts = quiz.isRemote
        ? const [5, 10, 20]
        : [
            for (final count in const [2, 5, 10, 20])
              if (count < availableQuestions.length) count,
          ];
    final selectedCount = _configuration.questionCount;

    return ListView(
      children: [
        ContentWidth(
          maxWidth: 720,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(quiz.title, style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 10),
              Text(
                l10n.customizeQuiz,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              _SetupSection(
                title: l10n.difficulty,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.allDifficulties),
                      selected: _configuration.difficulty == null,
                      onSelected: (_) => _selectDifficulty(null, quiz),
                    ),
                    for (final difficulty in QuizDifficulty.values)
                      if (quiz.isRemote ||
                          quiz.availableDifficulties.contains(difficulty))
                        ChoiceChip(
                          label: Text(_difficultyLabel(l10n, difficulty)),
                          selected: _configuration.difficulty == difficulty,
                          onSelected: (_) =>
                              _selectDifficulty(difficulty, quiz),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _SetupSection(
                title: l10n.questionCountTitle,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final count in questionCounts)
                      ChoiceChip(
                        label: Text('$count'),
                        selected: selectedCount == count,
                        onSelected: (_) {
                          setState(() {
                            _configuration = _configuration.copyWith(
                              questionCount: count,
                            );
                          });
                        },
                      ),
                    if (!quiz.isRemote)
                      ChoiceChip(
                        label: Text(
                          '${l10n.allQuestions} (${availableQuestions.length})',
                        ),
                        selected:
                            selectedCount == null || questionCounts.isEmpty,
                        onSelected: (_) {
                          setState(() {
                            _configuration = _configuration.copyWith(
                              allQuestions: true,
                            );
                          });
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _SetupSection(
                title: l10n.quizMode,
                child: SegmentedButton<QuizMode>(
                  segments: [
                    ButtonSegment(
                      value: QuizMode.relaxed,
                      icon: const Icon(Icons.self_improvement_rounded),
                      label: Text(l10n.relaxedMode),
                    ),
                    ButtonSegment(
                      value: QuizMode.timed,
                      icon: const Icon(Icons.timer_outlined),
                      label: Text(l10n.timedMode),
                    ),
                  ],
                  selected: {_configuration.mode},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _configuration = _configuration.copyWith(
                        mode: selection.single,
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _configuration.mode == QuizMode.timed
                    ? l10n.timedModeDescription(
                        _configuration.secondsPerQuestion,
                      )
                    : l10n.relaxedModeDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 36),
              FilledButton.icon(
                onPressed: _isLoadingQuestions ? null : () => _startQuiz(quiz),
                icon: _isLoadingQuestions
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(
                  _isLoadingQuestions ? l10n.loadingQuestions : l10n.beginQuiz,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectDifficulty(QuizDifficulty? difficulty, Quiz quiz) {
    if (quiz.isRemote) {
      setState(() {
        _configuration = _configuration.copyWith(
          difficulty: difficulty,
          clearDifficulty: difficulty == null,
        );
      });
      return;
    }
    final availableCount = quiz.questionsFor(difficulty).length;
    final currentCount = _configuration.questionCount;
    setState(() {
      _configuration = _configuration.copyWith(
        difficulty: difficulty,
        clearDifficulty: difficulty == null,
        questionCount: currentCount != null && currentCount < availableCount
            ? currentCount
            : null,
        allQuestions: currentCount == null || currentCount >= availableCount,
      );
    });
  }

  Future<void> _startQuiz(Quiz quiz) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoadingQuestions = true);
    try {
      final loadedQuiz = await ref
          .read(quizRepositoryProvider)
          .loadQuiz(quiz, _configuration);
      if (!mounted) {
        return;
      }
      final started = ref
          .read(quizSessionControllerProvider.notifier)
          .start(loadedQuiz, _configuration);
      if (started) {
        context.go('/quiz');
      } else {
        _showError(l10n.noMatchingQuestions);
      }
    } on OpenTriviaException catch (error) {
      if (mounted) {
        _showError(
          error.failure == OpenTriviaFailure.noResults
              ? l10n.noMatchingQuestions
              : l10n.questionLoadFailure,
        );
      }
    } on Object {
      if (mounted) {
        _showError(l10n.questionLoadFailure);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingQuestions = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Quiz? _findQuiz(List<Quiz> quizzes, String quizId) {
    for (final quiz in quizzes) {
      if (quiz.id == quizId) {
        return quiz;
      }
    }
    return null;
  }

  String _difficultyLabel(AppLocalizations l10n, QuizDifficulty difficulty) {
    return switch (difficulty) {
      QuizDifficulty.beginner => l10n.beginner,
      QuizDifficulty.intermediate => l10n.intermediate,
      QuizDifficulty.advanced => l10n.advanced,
    };
  }
}

class _SetupSection extends StatelessWidget {
  const _SetupSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _UnavailableQuiz extends StatelessWidget {
  const _UnavailableQuiz({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ContentWidth(
      child: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }
}

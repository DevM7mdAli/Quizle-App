import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/content_width.dart';
import '../../../l10n/app_localizations.dart';
import '../application/quiz_session_controller.dart';
import '../domain/quiz_models.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(quizSessionControllerProvider);

    if (session == null || session.phase != QuizSessionPhase.completed) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.answerReview)),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/'),
            child: Text(l10n.backHome),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.answerReview)),
      body: ListView(
        children: [
          ContentWidth(
            child: Column(
              children: [
                for (
                  var index = 0;
                  index < session.questions.length;
                  index++
                ) ...[
                  _QuestionReviewCard(
                    index: index,
                    question: session.questions[index],
                    selectedOptionId:
                        session.answers[session.questions[index].id],
                  ),
                  if (index < session.questions.length - 1)
                    const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionReviewCard extends StatelessWidget {
  const _QuestionReviewCard({
    required this.index,
    required this.question,
    required this.selectedOptionId,
  });

  final int index;
  final QuizQuestion question;
  final String? selectedOptionId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quizColors = context.quizColors;
    final isCorrect = selectedOptionId == question.correctOptionId;
    final selectedOption = question.options.where(
      (option) => option.id == selectedOptionId,
    );
    final selectedText = selectedOption.isEmpty
        ? l10n.notAnswered
        : selectedOption.first.text;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? quizColors.successContainer
                        : Theme.of(context).colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCorrect ? Icons.check_rounded : Icons.close_rounded,
                    color: isCorrect
                        ? quizColors.onSuccessContainer
                        : Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    '${index + 1}. ${question.prompt}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _AnswerLine(label: l10n.yourAnswer, value: selectedText),
            if (!isCorrect) ...[
              const SizedBox(height: 10),
              _AnswerLine(
                label: l10n.correctAnswer,
                value: question.correctOption.text,
                valueColor: quizColors.success,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              question.explanation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

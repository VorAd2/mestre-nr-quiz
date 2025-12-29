import 'package:flutter/material.dart';
import 'package:mestre_nr/quiz/models/question_model.dart';

class QuestionOptionsGrid extends StatelessWidget {
  final QuestionModel question;
  final Function(int) onOptionClicked;

  const QuestionOptionsGrid({
    super.key,
    required this.question,
    required this.onOptionClicked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: List.generate(4, (index) {
        final letter = String.fromCharCode(65 + index);
        final text = question.optionTexts[index];
        return ElevatedButton(
          onPressed: () => onOptionClicked(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerLeft,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$letter)",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary.withAlpha(184),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onPrimary,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

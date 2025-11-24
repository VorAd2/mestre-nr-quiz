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
    final colors = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const columns = 2;
        final spacing = width * 0.02;
        final cardWidth = (width - (spacing * (columns + 1))) / columns;
        final cardHeight = cardWidth * 0.70;
        final fontSize = width * 0.032;
        String getLetter(int optionIndex) =>
            String.fromCharCode(65 + optionIndex);
        return Padding(
          padding: EdgeInsets.all(spacing),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: cardWidth / cardHeight * 0.8,
            ),
            itemBuilder: (_, optionIndex) {
              return ElevatedButton(
                onPressed: () {
                  onOptionClicked(optionIndex);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  backgroundColor: colors.surfaceContainerLow,
                  foregroundColor: colors.onSurfaceVariant,
                ),
                child: Text(
                  '(${getLetter(optionIndex)}) ${question.optionTexts[optionIndex]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: fontSize, height: 1.2),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const columns = 1;
        final spacing = width * 0.02;
        final cardWidth = (width - (spacing * (columns + 1))) / columns;
        final cardHeight = cardWidth * 0.70;
        final fontSize = width * 0.036;
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
              childAspectRatio: cardWidth / cardHeight * 2.7,
            ),
            itemBuilder: (_, optionIndex) {
              final maxLinesConstant = 0.0111;
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
                    horizontal: 8,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  '(${getLetter(optionIndex)}) ${question.optionTexts[optionIndex]}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: fontSize, height: 1.2),
                  maxLines: (width * maxLinesConstant).floor(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';

class QuestionModel {
  late final int number;
  late final String prompt;
  late final List<String> options;
  late final int correctOptionIndex;

  QuestionModel({
    required this.number,
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      number: json['number'],
      prompt: json['prompt'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
    );
  }

  static Widget getOptionsCards({
    required BoxConstraints constraints,
    required Map<String, dynamic>? data,
    required ColorScheme colors,
    required AppColorScheme custom,
  }) {
    final width = constraints.maxWidth;

    const columns = 2;
    final spacing = width * 0.02;
    final cardWidth = (width - (spacing * (columns + 1))) / columns;
    final cardHeight = cardWidth * 0.70;
    final fontSize = width * 0.032;

    String getLetter(int index) => String.fromCharCode(65 + index);

    final question = data!['questions']![3];

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
        itemBuilder: (_, index) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Center(
                child: Text(
                  '(${getLetter(index)}) ${question['options'][index]['text']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: custom.text,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

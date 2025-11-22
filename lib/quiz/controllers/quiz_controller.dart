import 'package:flutter/material.dart';
import 'package:mestre_nr/core/services/gemini_service.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';

class QuizController {
  final isLoaded = ValueNotifier<bool>(false);
  late final Object? data;

  Future<void> generateData(Map<String, Object> userParams) async {
    data = await GeminiService.fetchQuizData(userParams);
    isLoaded.value = true;
  }

  Widget getOptionsCards(BoxConstraints constraints, AppColorScheme custom) {
    final width = constraints.maxWidth;
    final double cardWidth = (width / 2) - 24;
    final double cardHeight = cardWidth * 0.8;
    String getLetter(int index) {
      return String.fromCharCode(65 + index);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: cardWidth / cardHeight,
        ),
        itemBuilder: (_, index) {
          return Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsetsGeometry.only(left: 6),
              child: Center(
                child: Text(
                  '(${getLetter(index)}) Lorem ipsumlum ers',
                  style: TextStyle(fontSize: 15, color: custom.text),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

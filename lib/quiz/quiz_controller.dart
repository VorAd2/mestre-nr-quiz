import 'package:flutter/widgets.dart';
import 'package:mestre_nr/core/services/gemini_service.dart';

class QuizController {
  final isLoaded = ValueNotifier<bool>(false);
  late final Object? data;

  Future<void> generateData(Map<String, Object> userParams) async {
    data = await GeminiService.fetchQuizData(userParams);
    isLoaded.value = true;
  }
}

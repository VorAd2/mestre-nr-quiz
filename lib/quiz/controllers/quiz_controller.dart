import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mestre_nr/core/services/gemini_service.dart';

class QuizController {
  final isLoaded = ValueNotifier<bool>(false);
  late final Map<String, dynamic>? data;

  Future<void> generateData(Map<String, Object> userParams) async {
    String extractJson(String text) {
      final match = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      return match?.group(0) ?? text;
    }

    final raw = await GeminiService.fetchQuizData(userParams);
    final jsonString = extractJson(raw as String);
    data = jsonDecode(jsonString);
    isLoaded.value = true;
  }
}

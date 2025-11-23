import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mestre_nr/core/services/gemini_service.dart';
import 'package:mestre_nr/core/utils/error_type.dart';

class QuizController {
  final isLoaded = ValueNotifier<bool>(false);
  ErrorType? error;
  late final Map<String, dynamic>? data;

  Future<void> generateData(Map<String, Object> userParams) async {
    String extractJson(String text) {
      final match = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      return match?.group(0) ?? text;
    }

    final fetchRes = await GeminiService.fetchQuizData(userParams);
    if (!fetchRes.isSuccess) {
      isLoaded.value = true;
      data = null;
      error = fetchRes.error;
      return;
    }
    final raw = fetchRes.data;
    final jsonString = extractJson(raw as String);
    data = jsonDecode(jsonString);
    isLoaded.value = true;
  }
}

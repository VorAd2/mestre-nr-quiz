import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mestre_nr/core/services/gemini_service.dart';
import 'package:mestre_nr/core/utils/generation_error_type.dart';
import 'package:mestre_nr/quiz/models/question_model.dart';

class QuizController {
  final isLoaded = ValueNotifier<bool>(false);
  GenerationErrorType? generationError;
  List<QuestionModel>? questions;
  int _currQuestionIndex = 0;
  final currQuestionNotifier = ValueNotifier<QuestionModel?>(null);

  Future<void> generateData(Map<String, Object> userParams) async {
    String? extractJsonString(String text) {
      final cleanText = text.replaceAll(RegExp(r'```json|```'), '');
      final startIndex = cleanText.indexOf('{');
      final endIndex = cleanText.lastIndexOf('}');
      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
        return cleanText.substring(startIndex, endIndex + 1);
      }
      return null;
    }

    final fetchRes = await GeminiService.fetchQuizData(userParams);
    if (!fetchRes.isSuccess) {
      questions = null;
      generationError = fetchRes.error;
      isLoaded.value = true;
      return;
    }
    final raw = fetchRes.data as String;
    final jsonString = extractJsonString(raw);
    if (jsonString == null) {
      generationError = GenerationErrorType.gemini;
      questions = null;
      isLoaded.value = true;
      return;
    }
    try {
      final decoded = jsonDecode(jsonString);
      final List<dynamic> rawList = decoded["questions"];
      questions = rawList
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      currQuestionNotifier.value = questions![0];
    } catch (e) {
      generationError = GenerationErrorType.gemini;
      questions = null;
    }
    isLoaded.value = true;
  }

  void checkOption(QuestionModel question, int clickedOptionIndex) {
    //Armazenar a resposta do usuario para a questão
    _currQuestionIndex += 1;
    currQuestionNotifier.value = questions![_currQuestionIndex];
  }
}

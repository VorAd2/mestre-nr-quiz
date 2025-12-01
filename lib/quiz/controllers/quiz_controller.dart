import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:mestre_nr/core/services/gemini_service.dart';
import 'package:mestre_nr/core/utils/gemini_service_error_type.dart';
import 'package:mestre_nr/core/utils/gemini_service_exception.dart';
import 'package:mestre_nr/quiz/models/question_model.dart';
import 'package:mestre_nr/quiz/models/quiz_model.dart';

class QuizController {
  List<QuestionModel>? _questions;
  late final QuizModel _quizModel;
  int _currQuestionIndex = 0;
  final currQuestionNotifier = ValueNotifier<QuestionModel?>(null);

  String _getErrorMessage(GeminiServiceErrorType error) {
    switch (error) {
      case GeminiServiceErrorType.quota:
        return 'Muitas solicitações foram feitas ao Gemini. Por favor, tente novamente mais tarde.';
      case GeminiServiceErrorType.network:
        return 'Erro de rede. Verifique sua conexão e tente novamente.';
      case GeminiServiceErrorType.gemini:
        return 'Ocorreu um problema na interação com o Gemini. Por favor, tente novamente e, se o problema persistir, contate o desenvolvedor.';
      case GeminiServiceErrorType.unknown:
        return 'Um erro inesperado ocorreu. Por favor, contate o desenvolvedor.';
    }
  }

  void _printFormattedJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(json);
    print(prettyJson);
  }

  Future<void> generateData(Map<String, Object> userParams) async {
    try {
      final jsonString = await GeminiService.fetchQuizData(userParams);
      final dynamic decoded = jsonDecode(jsonString!);
      final List<dynamic> rawList = decoded["questions"];
      _questions = rawList
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _quizModel = QuizModel.fromQuestions(_questions!);
      currQuestionNotifier.value = _questions![0];
    } on ServerException catch (_) {
      throw GeminiServiceException(
        type: GeminiServiceErrorType.gemini,
        message: _getErrorMessage(GeminiServiceErrorType.gemini),
      );
    } on GeminiServiceException catch (e) {
      e.message = _getErrorMessage(e.type);
      rethrow;
    } on FormatException catch (_) {
      throw GeminiServiceException(
        type: GeminiServiceErrorType.unknown,
        message: _getErrorMessage(GeminiServiceErrorType.unknown),
      );
    } catch (e) {
      if (e.runtimeType.toString() == 'QuotaExceeded') {
        throw GeminiServiceException(
          type: GeminiServiceErrorType.quota,
          message: _getErrorMessage(GeminiServiceErrorType.quota),
        );
      }
      throw GeminiServiceException(
        type: GeminiServiceErrorType.unknown,
        message: _getErrorMessage(GeminiServiceErrorType.unknown),
      );
    }
  }

  void checkOption(int clickedOptionIndex) {
    _quizModel.insertUserAnswer(clickedOptionIndex);
    if (_currQuestionIndex == 9) {
      return;
    }
    _currQuestionIndex += 1;
    currQuestionNotifier.value = _questions![_currQuestionIndex];
  }

  List<Map<String, dynamic>> getQuestionsReview() {
    return _quizModel.getQuestionsReview();
  }
}

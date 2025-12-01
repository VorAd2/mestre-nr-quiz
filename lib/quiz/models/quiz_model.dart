import 'package:mestre_nr/quiz/models/question_model.dart';

class QuizModel {
  final List<QuestionModel> questions;
  final List<int> answerKey;
  final userAnswers = <int>[];

  QuizModel({required this.questions, required this.answerKey});

  factory QuizModel.fromQuestions(List<QuestionModel> questions) {
    final answerKey = <int>[];
    for (int i = 0; i < 10; i++) {
      final correctOptionIndex = questions[i].correctOptionIndex;
      answerKey.add(correctOptionIndex);
    }
    return QuizModel(questions: questions, answerKey: answerKey);
  }

  void insertUserAnswer(int optionIndex) {
    userAnswers.add(optionIndex);
  }

  List<Map<String, dynamic>> getQuestionsReview() {
    final List<Map<String, dynamic>> summary = [];
    var i = 0;
    for (QuestionModel question in questions) {
      summary.add({
        'id': question.questionIndex,
        'prompt': question.prompt,
        'isCorrect': userAnswers[i] == question.correctOptionIndex,
        'correctOption': question.optionTexts[question.correctOptionIndex],
        'userAnswer': question.optionTexts[userAnswers[i]],
      });
      i += 1;
    }
    return summary;
  }
}

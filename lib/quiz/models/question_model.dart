class QuestionModel {
  late final int questionIndex;
  late final String prompt;
  late final List<dynamic> optionTexts;
  late final int correctOptionIndex;

  QuestionModel({
    required this.questionIndex,
    required this.prompt,
    required this.optionTexts,
    required this.correctOptionIndex,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionIndex: json['id'],
      prompt: json['prompt'],
      optionTexts: List<String>.from(json['optionTexts']),
      correctOptionIndex: json['correctOptionIndex'],
    );
  }
}

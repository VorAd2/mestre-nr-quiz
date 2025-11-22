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
}

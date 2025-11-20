import 'package:flutter/widgets.dart';

class QuizController {
  final isLoaded = ValueNotifier<bool>(false);
  late final Map<String, Object> data;

  Future<void> generateData() async {
    await Future.delayed(Duration(seconds: 1));
  }
}

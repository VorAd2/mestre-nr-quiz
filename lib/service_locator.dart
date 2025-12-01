import 'package:get_it/get_it.dart';
import 'package:mestre_nr/core/services/gemini_service.dart';
import 'package:mestre_nr/quiz/controllers/quiz_controller.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<GeminiService>(GeminiService());
  getIt.registerLazySingleton<QuizController>(
    () => QuizController(getIt<GeminiService>()),
  );
}

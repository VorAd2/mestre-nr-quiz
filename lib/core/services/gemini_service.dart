import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  static const prompt =
      'Retorne uma frase poética em ingles ou portugues. Apenas a frase, nada mais';

  static Future<Object?> fetchQuizData(Map<String, Object> userParams) async {
    Gemini.instance
        .prompt(parts: [Part.text(prompt)])
        .then((value) {
          print('FRASE POETICA: ${value?.output}');
          return value?.output;
        })
        .catchError((e) {
          print('ERROR FETCH: $e');
        });
    return null;
  }
}

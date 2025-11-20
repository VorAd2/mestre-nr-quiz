import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  static const prompt =
      'Retorne uma frase poética em ingles ou portugues. Apenas a frase, nada mais';

  static Future<Object?> fetchQuizData(Map<String, Object> userParams) async {
    try {
      final response = await Gemini.instance.prompt(parts: [Part.text(prompt)]);
      print('FRASE POETICA: ${response?.output}');
      return response?.output;
    } catch (e) {
      print('ERROR FETCH: $e');
      return null;
    }
  }
}

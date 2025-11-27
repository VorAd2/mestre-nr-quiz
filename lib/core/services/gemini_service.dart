import 'package:firebase_ai/firebase_ai.dart';
import 'package:mestre_nr/core/utils/gemini_service_error_type.dart';
import 'package:mestre_nr/core/utils/gemini_service_exception.dart';

final responseSchema = Schema.object(
  properties: {
    'questions': Schema.array(
      items: Schema.object(
        properties: {
          'id': Schema.integer(
            description:
                'Representa o id, variando de 0 a 9, da questão. A questão 1 tem id=0, a questao 2 tem id=1, e assim sucessivamente',
          ),
          'prompt': Schema.string(description: 'É o texto da questão'),
          'nr': Schema.integer(minimum: 1, maximum: 38),
          'optionTexts': Schema.array(
            items: Schema.string(
              description:
                  'Texto de cada uma das 4 alternativas de resposta à questão',
            ),
            minItems: 4,
            maxItems: 4,
          ),
          'correctOptionIndex': Schema.integer(
            description: 'O index da alternativa correta do array optionTexts',
            maximum: 1,
          ),
        },
      ),
    ),
  },
);

final instruction = '''
  Você é um grande conhecedor da Higiene e Segurança do Trabalho no Brasil e é
  um habilidoso formulador de perguntas, no estilo quiz, sobre o assunto.
''';

final aiModel = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash',
  generationConfig: GenerationConfig(
    temperature: 1.5,
    responseMimeType: 'application/json',
    responseSchema: responseSchema,
  ),
  systemInstruction: Content.system(instruction),
);

class GeminiService {
  static Future<String?> fetchQuizData(Map<String, Object> userParams) async {
    final prompt = _generatePropmt(userParams);
    final response = await aiModel.generateContent(prompt);
    if (response.candidates.isEmpty) {
      throw GeminiServiceException(type: GeminiServiceErrorType.gemini);
    }
    final rawData = response.text;
    if (rawData == null) {
      throw GeminiServiceException(type: GeminiServiceErrorType.gemini);
    }
    final jsonString = _extractJsonString(rawData);
    if (jsonString == null) {
      throw GeminiServiceException(type: GeminiServiceErrorType.gemini);
    }
    return jsonString;
  }

  static List<Content> _generatePropmt(Map<String, Object> userParams) {
    final nrs = userParams['nrs'] as Set<int>;
    final diff = userParams['diff'] as String;
    final prompt =
        '''  
      Gere um conjunto de 10 questões no estilo QUIZ sobre as seguintes Normas Regulamentadoras (HST):
      ${nrs.toString()}. As perguntas devem, se possivel, ser distribuídas igualmente entre as NRs fornecidas.
      As questões NÃO devem ser entregues na ordem das NRs, mas sim embaralhadas aleatoriamente.

      Nível de dificuldade desejado para as questões: $diff
      (Níveis possíveis: "fácil", "médio", "difícil")

      Cada questão deve:
      - Ser clara, objetiva e tecnicamente correta.
      - Conter exatamente 4 alternativas.
      - Ter APENAS UMA alternativa correta.
      - Estar alinhada com o conteúdo das normas regulamentadoras pedidas.
    ''';
    return [Content.text(prompt)];
  }

  static String? _extractJsonString(String text) {
    final cleanText = text.replaceAll(RegExp(r'```json|```'), '');
    final startIndex = cleanText.indexOf('{');
    final endIndex = cleanText.lastIndexOf('}');
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return cleanText.substring(startIndex, endIndex + 1);
    }
    return null;
  }
}

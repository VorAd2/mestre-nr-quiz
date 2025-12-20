import 'package:firebase_ai/firebase_ai.dart';
import 'package:mestre_nr/core/utils/gemini_service_error_type.dart';
import 'package:mestre_nr/core/utils/gemini_service_exception.dart';

Schema _buildResponseSchema() {
  return Schema.object(
    properties: {
      'questions': Schema.array(
        items: Schema.object(
          properties: {
            'id': Schema.integer(
              description:
                  'Representa o id, variando de 0 a 9, da questão. A questão 1 tem id=0, a questão 2 tem id=1, e assim sucessivamente',
            ),
            'prompt': Schema.string(description: 'É o texto da questão'),
            'nr': Schema.integer(minimum: 1, maximum: 38),
            'optionTexts': Schema.array(
              items: Schema.string(
                description:
                    'Texto de cada uma das 4 alternativas de resposta à questão. Esse texto deve possuir, no máximo, 200 caracteres.',
              ),
              minItems: 4,
              maxItems: 4,
            ),
            'correctOptionIndex': Schema.integer(
              description:
                  'O índice (0..3) da alternativa correta do array optionTexts',
              minimum: 0,
              maximum: 3,
            ),
          },
        ),
      ),
    },
  );
}

final _defaultInstruction = '''
Você é um grande conhecedor da Higiene e Segurança do Trabalho no Brasil e é
um habilidoso formulador de perguntas, no estilo quiz, sobre o assunto.
''';

class GeminiService {
  final FirebaseAI _firebaseAi = FirebaseAI.googleAI();
  final String modelName = 'gemini-2.5-flash';

  Future<String?> fetchQuizData(Map<String, Object> userParams) async {
    final nrs = userParams['nrs'] as Set<int>;
    final diff = userParams['diff'] as String;
    final responseSchema = _buildResponseSchema();
    final aiModel = _firebaseAi.generativeModel(
      model: modelName,
      generationConfig: GenerationConfig(
        temperature: 1.2,
        responseMimeType: 'application/json',
        responseSchema: responseSchema,
      ),
      systemInstruction: Content.system(_defaultInstruction),
    );
    final promptParts = _generatePrompt(nrs, diff);
    final response = await aiModel.generateContent(promptParts);
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

  static List<Content> _generatePrompt(Set<int> nrs, String diff) {
    final nQuestions = 10;
    final prompt =
        '''
    Gere um conjunto de $nQuestions questões no estilo QUIZ sobre as seguintes Normas Regulamentadoras (HST):
    ${nrs.join(', ')}.

    As perguntas devem, se possível, ser distribuídas igualmente entre as NRs fornecidas e embaralhadas.
    Nível de dificuldade desejado para as questões: $diff
    (Valores possíveis: "fácil", "médio", "difícil")

    Cada questão deve:
    - Ser clara, objetiva e tecnicamente correta.
    - Conter exatamente 4 alternativas.
    - Ter APENAS UMA alternativa correta.
    - As alternativas (optionTexts) devem ter no máximo 200 caracteres cada.
    - Forneça a saída em JSON conforme o schema fornecido (sem explicações adicionais). 
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

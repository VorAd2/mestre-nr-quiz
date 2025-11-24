import 'package:dio/dio.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mestre_nr/core/utils/generation_error_type.dart';
import 'package:mestre_nr/core/utils/fetch_result.dart';

class GeminiService {
  static Future<FetchResult> fetchQuizData(
    Map<String, Object> userParams,
  ) async {
    final String prompt = _generatePropmt(userParams);
    try {
      final response = await Gemini.instance.prompt(parts: [Part.text(prompt)]);
      return FetchResult.success(response?.output);
    } on GeminiException catch (e) {
      final msg = e.message.toString();
      if (msg.contains('RESOURCE_EXHAUSTED')) {
        return FetchResult.error(GenerationErrorType.quota);
      }
      return FetchResult.error(GenerationErrorType.gemini);
    } on DioException catch (_) {
      return FetchResult.error(GenerationErrorType.network);
    } catch (_) {
      return FetchResult.error(GenerationErrorType.unknown);
    }
  }

  static String _generatePropmt(Map<String, Object> userParams) {
    final nrs = userParams['nrs'] as Set<int>;
    final diff = userParams['diff'] as String;
    // Resolver tamanho dinamico maximo do comando da questão
    return '''
      Você é um gerador de questões de prova de alta qualidade.

      Gere um conjunto de 10 questões no estilo QUIZ sobre as seguintes Normas Regulamentadoras (HST):
      ${nrs.toString()}. As perguntas devem, se possivel, ser distribuídas igualmente entre as NRs fornecidas.
      As questões NÃO devem ser entregues na ordem das NRs, mas sim embaralhadas aleatoriamente.

      Nível de dificuldade desejado: $diff
      (Níveis possíveis: "fácil", "médio", "difícil")

      Cada questão deve:
      - Ser clara, objetiva e tecnicamente correta.
      - Conter exatamente 4 alternativas (A, B, C e D).
      - Ter apenas uma alternativa correta.
      - Estar alinhada com o conteúdo das normas regulamentadoras pedidas.
      - Estar formatada rigorosamente no JSON especificado abaixo.

      ### IMPORTANTE
      - Retorne APENAS o JSON.
      - O JSON deve estar 100% válido e sem textos adicionais.
      - Não inclua comentários, explicações ou formatação Markdown.

      ### FORMATO EXATO DO JSON DE RETORNO:
      {
        "questions": [
          {
            "id": 0,
            "prompt": "Texto da pergunta...",
            "difficulty": "facil|medio|dificil",
            "nr": "NR-XX",
            "optionTexts": [
              "texto da opção 0",
              "texto da opção 1",
              "texto da opção 2",
              "texto da opção 3"
            ],
            "correctOptionIndex": 0|1|2|3
          },
          ...
        ]
      }
    ''';
  }
}

import 'package:flutter/material.dart';
import 'package:mestre_nr/quiz/models/question_model.dart';

class QuestionOptionsGrid extends StatelessWidget {
  final QuestionModel question;
  final Function(int) onOptionClicked;

  const QuestionOptionsGrid({
    super.key,
    required this.question,
    required this.onOptionClicked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Não precisamos de LayoutBuilder.
    // A largura será controlada pelo Padding da tela pai (QuizView).
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Estica botões na largura
      spacing: 16, // Espaçamento nativo do Flutter (substituto do SizedBox)
      children: List.generate(4, (index) {
        final letter = String.fromCharCode(65 + index); // A, B, C, D
        final text = question.optionTexts[index];

        return ElevatedButton(
          onPressed: () => onOptionClicked(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 2,
            // Permite que o botão cresça verticalmente se o texto for longo
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // Alinhamento do conteúdo dentro do botão
            alignment: Alignment.centerLeft,
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha letra e texto no topo
            children: [
              // Letra (A, B, C...) com destaque
              Text(
                "$letter)",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 12),
              // Texto da opção
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onPrimary,
                    height: 1.2,
                  ),
                  // Removemos maxLines fixo. O texto aparece inteiro agora!
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

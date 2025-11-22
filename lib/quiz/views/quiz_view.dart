import 'package:flutter/material.dart';
import 'package:mestre_nr/quiz/controllers/quiz_controller.dart';
import 'package:mestre_nr/quiz/models/question_model.dart';
import 'package:mestre_nr/quiz/widgets/circular_count.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';

class QuizView extends StatefulWidget {
  final QuizController controller;
  const QuizView({super.key, required this.controller});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  @override
  Widget build(BuildContext context) {
    final data = widget.controller.data;
    final msg = data?['questions']?[0]?['prompt'] ?? 'VAZIO';
    final colors = Theme.of(context).colorScheme;
    final custom = Theme.of(context).extension<AppColorScheme>()!;

    return Scaffold(
      backgroundColor: custom.background,
      appBar: getAppBar(colors),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final spacing = width * 0.06;
          final countdownSize = width * 0.30;
          final promptFontSize = width * 0.04;
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                children: [
                  SizedBox(height: spacing),
                  CircularCountdown(
                    seconds: 20,
                    size: countdownSize,
                    color: colors.primary,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    msg,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: promptFontSize,
                      fontWeight: FontWeight.bold,
                      color: custom.text,
                    ),
                  ),
                  SizedBox(height: spacing),
                  QuestionModel.getOptionsCards(
                    constraints: constraints,
                    data: data,
                    colors: colors,
                    custom: custom,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget getAppBar(ColorScheme colors) {
    return AppBar(
      backgroundColor: colors.surfaceContainerLow,
      centerTitle: true,
      title: Text('Quiz', style: TextStyle(color: colors.onSurfaceVariant)),
      leading: getReturnBtn(colors),
      actions: const [ThemeButton()],
    );
  }

  Widget getReturnBtn(ColorScheme colors) {
    return IconButton(
      color: colors.onSurfaceVariant,
      onPressed: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: colors.surfaceContainerLow,
            title: Text(
              'Sair do Quiz?',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            content: Text(
              'Tem certeza de que deseja retornar? Seu progresso será perdido.',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        );

        if (shouldPop == true && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        }
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mestre_nr/quiz/controllers/quiz_controller.dart';
import 'package:mestre_nr/quiz/models/question_model.dart';
import 'package:mestre_nr/quiz/widgets/circular_count.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';
import 'package:mestre_nr/quiz/widgets/question_options_grid.dart';

class QuizView extends StatefulWidget {
  final QuizController controller;
  const QuizView({super.key, required this.controller});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  @override
  Widget build(BuildContext context) {
    final questions = widget.controller.questions;
    final colors = Theme.of(context).colorScheme;
    final custom = Theme.of(context).extension<AppColorScheme>()!;

    return Scaffold(
      backgroundColor: custom.background,
      appBar: buildAppBar(colors),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: ValueListenableBuilder(
                valueListenable: widget.controller.currQuestionNotifier,
                builder: (context, currQuestion, _) => buildLayoutColumn(
                  constraints: constraints,
                  question: currQuestion!,
                  colors: colors,
                  custom: custom,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar(ColorScheme colors) {
    return AppBar(
      backgroundColor: colors.surfaceContainerLow,
      centerTitle: true,
      toolbarHeight: 70,
      title: Text(
        'Quiz',
        style: TextStyle(color: colors.onSurfaceVariant, fontFamily: 'Poppins'),
      ),
      leading: buildReturnBtn(colors),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 12), child: ThemeButton()),
      ],
    );
  }

  Widget buildReturnBtn(ColorScheme colors) {
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

  Column buildLayoutColumn({
    required BoxConstraints constraints,
    required QuestionModel question,
    required ColorScheme colors,
    required AppColorScheme custom,
  }) {
    final width = constraints.maxWidth;
    final spacing = width * 0.06;
    final countdownSize = width * 0.30;
    final promptFontSize = width * 0.035;
    return Column(
      children: [
        SizedBox(height: spacing),
        CircularCountdown(
          key: ValueKey(question.questionIndex),
          seconds: 20,
          size: countdownSize,
          color: colors.primary,
          custom: custom,
        ),
        SizedBox(height: spacing),
        Text(
          question.prompt,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: promptFontSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: custom.text,
          ),
        ),
        SizedBox(height: spacing),
        QuestionOptionsGrid(
          question: question,
          onOptionClicked: (clickedOptionIndex) {
            if (question.questionIndex == 9) {
              print('ULTIMA QUESTAO');
              return;
            }
            widget.controller.checkOption(question, clickedOptionIndex);
          },
        ),
      ],
    );
  }
}

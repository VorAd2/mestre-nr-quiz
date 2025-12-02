import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mestre_nr/quiz/controllers/quiz_controller.dart';
import 'package:mestre_nr/quiz/models/question_model.dart';
import 'package:mestre_nr/quiz/utils/soundtrack_manager.dart';
import 'package:mestre_nr/quiz/views/result_view.dart';
import 'package:mestre_nr/quiz/widgets/circular_count.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';
import 'package:mestre_nr/quiz/widgets/question_options_grid.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});
  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final QuizController controller = GetIt.I.get<QuizController>();
  final SoundtrackManager _soundManager = SoundtrackManager();

  @override
  void initState() {
    super.initState();
    _initializeSound();
  }

  @override
  void dispose() {
    _soundManager.dispose();
    super.dispose();
  }

  Future<void> _initializeSound() async {
    await _soundManager.initAndStart();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: buildAppBar(cs),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: ValueListenableBuilder(
                valueListenable: controller.currQuestionNotifier,
                builder: (context, currQuestion, _) => buildLayoutColumn(
                  constraints: constraints,
                  question: currQuestion!,
                  cs: cs,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar(ColorScheme cs) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 70,
      title: Text('Quiz', style: TextStyle(fontFamily: 'Poppins')),
      leading: buildReturnBtn(cs),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 12), child: ThemeButton()),
      ],
    );
  }

  Widget buildReturnBtn(ColorScheme cs) {
    return IconButton(
      onPressed: () async {
        final shouldPop = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: cs.surfaceContainer,
            title: const Text('Sair do Quiz?'),
            content: const Text(
              'Tem certeza de que deseja retornar? Seu progresso será perdido.',
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
          controller.reset();
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
    required ColorScheme cs,
  }) {
    final width = constraints.maxWidth;
    final spacing = width * 0.06;
    final countdownSize = width * 0.30;
    final promptFontSize = width * 0.035;
    return Column(
      children: [
        SizedBox(height: spacing * 0.5),
        CircularCountdown(
          key: ValueKey(question.questionIndex),
          seconds: 20,
          size: countdownSize,
          color: cs.primary,
        ),
        SizedBox(height: spacing),
        Text(
          question.prompt,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: promptFontSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing),
        QuestionOptionsGrid(
          question: question,
          onOptionClicked: (clickedOptionIndex) {
            controller.checkOption(clickedOptionIndex);
            if (question.questionIndex == 9) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ResultView()),
              );
            }
          },
        ),
      ],
    );
  }
}

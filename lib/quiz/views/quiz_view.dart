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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Scaffold(
      appBar: buildAppBar(cs),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: ValueListenableBuilder(
            valueListenable: controller.currQuestionNotifier,
            builder: (context, currQuestion, _) {
              if (currQuestion == null) return const SizedBox();
              return buildLayoutColumn(question: currQuestion, theme: theme);
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(ColorScheme cs) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 70,
      title: const Text(
        'Quiz',
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      ),
      leading: buildReturnBtn(cs),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 16), child: ThemeButton()),
      ],
    );
  }

  Widget buildReturnBtn(ColorScheme cs) {
    return IconButton(
      tooltip: 'Sair do Quiz',
      onPressed: () async {
        final shouldPop = await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: cs.surfaceContainerHigh,
            title: const Text('Sair do Quiz?'),
            content: const Text(
              'Tem certeza de que deseja retornar? Seu progresso será perdido.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Sair'),
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

  Widget buildLayoutColumn({
    required QuestionModel question,
    required ThemeData theme,
  }) {
    final diff = controller.userParams['diff'];
    final cs = theme.colorScheme;
    return Column(
      children: [
        const SizedBox(height: 16),
        CircularCountdown(
          key: ValueKey(question.questionIndex),
          seconds: diff == 'facil' ? 20 : 23,
          size: 120,
          color: cs.primary,
          onTimeExpired: () {
            controller.checkOption(null);
            if (question.questionIndex == 9) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ResultView()),
              );
            }
          },
        ),
        const SizedBox(height: 32),
        Text(
          question.prompt,
          textAlign: TextAlign.justify,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
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
        const SizedBox(height: 24),
      ],
    );
  }
}

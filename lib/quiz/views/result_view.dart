import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';
import 'package:mestre_nr/quiz/controllers/quiz_controller.dart';
import 'package:mestre_nr/quiz/views/loading_view.dart';
import 'package:mestre_nr/quiz/widgets/review_tile.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final QuizController controller = GetIt.I.get<QuizController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final reviewData = controller.getQuestionsReview();
    return Scaffold(
      appBar: buildAppBar(cs),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        itemCount: reviewData.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return ReviewTile(data: reviewData[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Reiniciar Quiz',
        onPressed: () {
          final userParams = controller.userParams;
          controller.reset();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LoadingView(userParams: userParams),
            ),
          );
        },
        child: const Icon(Icons.replay),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(ColorScheme cs) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 70,
      title: const Text(
        'Resultados',
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      ),
      leading: buildHomeBtn(cs),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 16), child: ThemeButton()),
      ],
    );
  }

  IconButton buildHomeBtn(ColorScheme cs) {
    return IconButton(
      tooltip: "Voltar ao Início",
      onPressed: () async {
        final shouldPop = await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: cs.surfaceContainerHigh,
            title: const Text('Novo Quiz?'),
            content: const Text('Você deseja retornar à tela inicial?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton.tonal(
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
      icon: const Icon(Icons.home),
    );
  }
}

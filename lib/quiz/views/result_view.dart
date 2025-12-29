import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mestre_nr/home_view.dart';
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
    final reviewData = controller.getQuestionsReview();
    return Scaffold(
      appBar: _MyAppBar(
        navigateHome: (shouldPop) {
          if (shouldPop == true && mounted) {
            controller.reset();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
          }
        },
      ),
      body: _ReviewTiles(reviewData: reviewData),
      floatingActionButton: _MyFAB(
        navigateNewQuiz: (userParams) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => LoadingView(userParams: userParams),
            ),
          );
        },
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final controller = GetIt.I.get<QuizController>();
  final void Function(bool?) navigateHome;

  _MyAppBar({required this.navigateHome});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 70,
      title: const Text(
        'Resultados',
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      ),
      leading: _HomeButton(navigateHome: navigateHome),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 16), child: ThemeButton()),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeButton extends StatelessWidget {
  final controller = GetIt.I.get<QuizController>();
  final void Function(bool?) navigateHome;

  _HomeButton({required this.navigateHome});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
        navigateHome(shouldPop);
      },
      icon: const Icon(Icons.home),
    );
  }
}

class _ReviewTiles extends StatelessWidget {
  final List<Map<String, dynamic>> reviewData;
  const _ReviewTiles({required this.reviewData});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      itemCount: reviewData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ReviewTile(data: reviewData[index]);
      },
    );
  }
}

class _MyFAB extends StatelessWidget {
  final controller = GetIt.I.get<QuizController>();
  final void Function(Map<String, Object>) navigateNewQuiz;
  _MyFAB({required this.navigateNewQuiz});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Responder novamente',
      onPressed: () {
        final userParams = controller.userParams;
        controller.reset();
        navigateNewQuiz(userParams);
      },
      child: const Icon(Icons.replay),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';
import 'package:mestre_nr/quiz/controllers/quiz_controller.dart';
import 'package:mestre_nr/quiz/widgets/review_tile.dart';

class ResultView extends StatefulWidget {
  final QuizController controller;
  const ResultView({super.key, required this.controller});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: buildAppBar(cs),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bottomSystemPadding = MediaQuery.of(context).viewPadding.bottom;
          final width = constraints.maxWidth;
          final spacing = width * 0.06;
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomSystemPadding + 24),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: spacing),
                  buildQuestionsReview(width),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.replay),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(ColorScheme cs) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 70,
      title: Text('Resultados', style: TextStyle(fontFamily: 'Poppins')),
      leading: buildReturnBtn(cs),
      actions: const [
        Padding(padding: EdgeInsets.only(right: 12), child: ThemeButton()),
      ],
    );
  }

  IconButton buildReturnBtn(ColorScheme cs) {
    return IconButton(
      onPressed: () async {
        final shouldPop = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: cs.surfaceContainer,
            title: Text('Construir Outro Quiz?'),
            content: Text('Você deseja retornar à tela inicial?'),
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
      icon: const Icon(Icons.home),
    );
  }

  Column buildQuestionsReview(double width) {
    final children = <Widget>[];
    final rawSummary = widget.controller.getQuestionsReview();
    for (int i = 0; i < 10; i++) {
      children.add(ReviewTile(width: width, data: rawSummary[i]));
    }
    return Column(spacing: 20, children: children);
  }
}

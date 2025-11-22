import 'package:flutter/material.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';
import 'package:mestre_nr/quiz/controllers/quiz_controller.dart';
import 'package:mestre_nr/quiz/widgets/circular_count.dart';

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
    final msg = data == null ? 'VAZIO' : data.toString();
    final colors = Theme.of(context).colorScheme;
    final custom = Theme.of(context).extension<AppColorScheme>()!;
    return Scaffold(
      backgroundColor: custom.background,
      appBar: getAppBar(colors),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                CircularCountdown(),
                SizedBox(height: 30),
                Text(msg, style: TextStyle(color: custom.text)),
                SizedBox(height: 60),
                widget.controller.getOptionsCards(constraints, custom),
              ],
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
      actions: [ThemeButton()],
    );
  }

  Widget getReturnBtn(ColorScheme colors) {
    return IconButton(
      color: colors.onSurfaceVariant,
      onPressed: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
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
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: Text('Confirmar'),
                ),
              ],
            );
          },
        );
        if (shouldPop == true && mounted) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
        }
      },
      icon: Icon(Icons.arrow_back),
    );
  }
}

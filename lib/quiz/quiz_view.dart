import 'package:flutter/material.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';
import 'package:mestre_nr/quiz/widgets/circular_count.dart';

class QuizView extends StatefulWidget {
  final Object? data;
  const QuizView({super.key, required this.data});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  @override
  Widget build(BuildContext context) {
    final msg = widget.data == null ? 'VAZIO' : widget.data.toString();
    final colors = Theme.of(context).colorScheme;
    final custom = Theme.of(context).extension<AppColorScheme>()!;
    return Scaffold(
      backgroundColor: custom.background,
      appBar: getAppBar(colors),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularCountdown(), Text(msg)],
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
        if (shouldPop && mounted) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
        }
      },
      icon: Icon(Icons.arrow_back),
    );
  }
}

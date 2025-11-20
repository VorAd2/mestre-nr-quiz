import 'package:flutter/material.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(msg)],
            ),
          );
        },
      ),
    );
  }
}

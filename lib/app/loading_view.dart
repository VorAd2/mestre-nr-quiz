import 'package:flutter/material.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/core/utils/screen_constraints.dart';
import 'package:mestre_nr/quiz/quiz_controller.dart';
import 'package:mestre_nr/quiz/quiz_view.dart';

class LoadingView extends StatefulWidget {
  final Map<String, Object> userParams;
  const LoadingView({super.key, required this.userParams});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  final quizController = QuizController();

  @override
  void initState() {
    super.initState();
    quizController.generateData(widget.userParams);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final custom = Theme.of(context).extension<AppColorScheme>()!;
    return Scaffold(
      backgroundColor: custom.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ValueListenableBuilder<bool>(
            valueListenable: quizController.isLoaded,
            builder: (context, loaded, _) {
              if (loaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizView(data: quizController.data),
                    ),
                  );
                });
              }
              return getLoadingContent(
                constraints: constraints,
                colors: colors,
                custom: custom,
                userParams: widget.userParams,
              );
            },
          );
        },
      ),
    );
  }

  Widget getLoadingContent({
    required BoxConstraints constraints,
    required ColorScheme colors,
    required AppColorScheme custom,
    required Object userParams,
  }) {
    final width = constraints.maxWidth;
    final double fontSize = ScreenConstraints.isMobile(width) ? 16 : 18;
    final double circularSize = ScreenConstraints.isMobile(width) ? 70 : 78;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          CircularProgressIndicator(
            constraints: BoxConstraints.tightFor(
              width: circularSize,
              height: circularSize,
            ),
            color: colors.primary,
          ),
          Text(
            'Aguardando resposta do Gemini',
            style: TextStyle(fontSize: fontSize, color: custom.text),
          ),
          Text(userParams.toString()),
        ],
      ),
    );
  }
}

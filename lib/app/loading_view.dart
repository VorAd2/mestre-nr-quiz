import 'package:flutter/material.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/quiz/controllers/quiz_controller.dart';
import 'package:mestre_nr/quiz/views/quiz_view.dart';

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
      body: ValueListenableBuilder<bool>(
        valueListenable: quizController.isLoaded,
        builder: (context, loaded, _) {
          if (loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizView(controller: quizController),
                ),
              );
            });
          }

          return _buildLoadingContent(colors, custom);
        },
      ),
    );
  }

  Widget _buildLoadingContent(ColorScheme colors, AppColorScheme custom) {
    final textScaler = MediaQuery.of(context).textScaler;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 40,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: colors.primary,
            ),
          ),
          Text(
            'Aguardando resposta do Gemini',
            textScaler: textScaler,
            style: TextStyle(
              fontSize: 17,
              color: custom.text,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.userParams.toString(),
            style: TextStyle(color: custom.text.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}

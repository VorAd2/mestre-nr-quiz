import 'package:flutter/material.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/core/utils/error_type.dart';
import 'package:mestre_nr/core/widgets/theme_button.dart';
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
  bool _handledOutcome = false;

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
      appBar: AppBar(
        backgroundColor: custom.background,
        actions: [ThemeButton()],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: quizController.isLoaded,
        builder: (context, loaded, _) {
          if (loaded && !_handledOutcome) {
            _handledOutcome = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (quizController.error != null) {
                _showErrorDialog(quizController.error!, colors);
                return;
              }
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

  void _showErrorDialog(ErrorType error, ColorScheme colors) {
    String getErrorMessage(ErrorType error) {
      switch (error) {
        case ErrorType.quota:
          return 'Muitas solicitações foram feitas ao Gemini. Por favor, tente novamente mais tarde.';
        case ErrorType.network:
          return 'Erro de rede. Verifique sua conexão e tente novamente.';
        case ErrorType.gemini:
          return 'Ocorreu um problema na interação com o Gemini. Por favor, contate o desenvolvedor se o problema persistir.';
        case ErrorType.unknown:
          return 'Um erro inesperado ocorreu. Por favor, contate o desenvolvedor.';
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surfaceContainerLow,
          title: const Text(
            "Erro",
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            getErrorMessage(error),
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeView()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

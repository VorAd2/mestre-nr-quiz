import 'package:flutter/material.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/utils/generation_error_type.dart';
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
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12, top: 9),
            child: ThemeButton(),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: quizController.isLoaded,
        builder: (context, loaded, _) {
          if (loaded && !_handledOutcome) {
            _handledOutcome = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (quizController.generationError != null) {
                _showErrorDialog(quizController.generationError!, cs);
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

          return _buildLoadingContent(cs);
        },
      ),
    );
  }

  Widget _buildLoadingContent(ColorScheme cs) {
    final textScaler = MediaQuery.of(context).textScaler;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 40,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(strokeWidth: 5, color: cs.primary),
          ),
          Text(
            'Aguardando resposta do Gemini',
            textScaler: textScaler,
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(widget.userParams.toString()),
        ],
      ),
    );
  }

  void _showErrorDialog(GenerationErrorType error, ColorScheme cs) {
    String getErrorMessage(GenerationErrorType error) {
      switch (error) {
        case GenerationErrorType.quota:
          return 'Muitas solicitações foram feitas ao Gemini. Por favor, tente novamente mais tarde.';
        case GenerationErrorType.network:
          return 'Erro de rede. Verifique sua conexão e tente novamente.';
        case GenerationErrorType.gemini:
          return 'Ocorreu um problema na interação com o Gemini. Por favor, tente novamente e, se o problema persistir, contate o desenvolvedor.';
        case GenerationErrorType.unknown:
          return 'Um erro inesperado ocorreu. Por favor, contate o desenvolvedor.';
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cs.surfaceContainer,
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
            style: TextStyle(color: cs.onSurfaceVariant),
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

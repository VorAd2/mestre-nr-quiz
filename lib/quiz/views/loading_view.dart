import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mestre_nr/app/home_view.dart';
import 'package:mestre_nr/core/utils/gemini_service_exception.dart';
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
  final quizController = GetIt.I.get<QuizController>();
  bool _handledOutcome = false;
  final isLoadedNotifier = ValueNotifier<bool>(false);
  late final String? errorMessage;

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() async {
    try {
      await quizController.generateData(widget.userParams);
      errorMessage = null;
      isLoadedNotifier.value = true;
    } catch (e) {
      final exception = e as GeminiServiceException;
      errorMessage = exception.message;
      isLoadedNotifier.value = true;
    }
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
        valueListenable: isLoadedNotifier,
        builder: (context, loaded, _) {
          if (loaded && !_handledOutcome) {
            _handledOutcome = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (errorMessage != null) {
                _showErrorDialog(errorMessage!, cs);
                return;
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => QuizView()),
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
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          CircularProgressIndicator(
            strokeWidth: 5,
            color: cs.primary,
            constraints: BoxConstraints(minWidth: 60, minHeight: 60),
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
        ],
      ),
    );
  }

  void _showErrorDialog(String errorMessage, ColorScheme cs) {
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
            errorMessage,
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

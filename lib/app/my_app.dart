import 'package:flutter/material.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/quiz/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mestre NR',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}

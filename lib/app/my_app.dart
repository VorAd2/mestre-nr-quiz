import 'package:flutter/material.dart';
import 'package:mestre_nr/core/theme/app_colors.dart';
import 'package:mestre_nr/core/theme/theme_controller.dart';
import 'package:mestre_nr/app/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mestre NR',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          home: const HomeView(),
        );
      },
    );
  }
}

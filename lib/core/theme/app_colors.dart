import 'package:flutter/material.dart';

final seed = Color(0xFF006D5B);
//fromSeed produz primaryContainer, surfaceVariant, etc.
final lightScheme = ColorScheme.fromSeed(
  seedColor: seed,
  brightness: Brightness.light,
);
final darkScheme = ColorScheme.fromSeed(
  seedColor: seed,
  brightness: Brightness.dark,
);

ThemeData buildAppThemeLight() {
  final cs = lightScheme.copyWith(
    // override nessas cores especificas, o resto fica como o flutter gerou
    secondary: Color(0xFF4BAA96),
    tertiary: Color(0xFFFFC857),
    error: Color(0xFFB00020),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    appBarTheme: AppBarTheme(
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      elevation: 1,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: cs.tertiary,
      contentTextStyle: TextStyle(color: cs.onSurface),
    ),
    // adicionar textTheme, inputDecorationTheme etc se precisar
  );
}

ThemeData buildAppThemeDark() {
  final cs = darkScheme.copyWith(
    secondary: Color(0xFF4BAA96),
    tertiary: Color(0xFFFFC857),
    error: Color(0xFFB00020),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    brightness: Brightness.dark,

    snackBarTheme: SnackBarThemeData(
      backgroundColor: cs.tertiary.withAlpha(100),
      contentTextStyle: TextStyle(color: cs.tertiary),
    ),
  );
}

extension SafetyColors on ColorScheme {
  Color get success => const Color(0xFF2E7D32);
  Color get warning => const Color(0xFFF57C00);
  Color get info => const Color(0xFF0288D1);
}

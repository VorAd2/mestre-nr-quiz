import 'package:flutter/material.dart';

class AppColors {
  static const Color _lightPrimary = Color(0xFF007BFF);
  static const Color _lightSecondary = Color(0xFFFFC107);
  static const Color _lightBackground = Color(0xFFF8F9FA);
  static const Color _lightGray = Color.fromARGB(255, 221, 221, 221);
  static const Color _darkGray = Color.fromARGB(255, 197, 197, 197);
  static const Color _lightText = Color(0xFF212529);
  static const Color _lightSuccess = Color(0xFF28A745);
  static const Color _darkPrimary = Color.fromARGB(255, 39, 160, 44);
  static const Color _darkSecondary = Color(0xFFFF9800);
  static const Color _darkBackground = Color(0xFF1E1E1E);
  static const Color _darkText = Color.fromARGB(255, 237, 237, 238);
}

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color success;
  final Color background;
  final Color text;

  const AppColorScheme({
    required this.success,
    required this.background,
    required this.text,
  });

  @override
  AppColorScheme copyWith({Color? success, Color? background, Color? text}) {
    return AppColorScheme(
      success: success ?? this.success,
      background: background ?? this.background,
      text: text ?? this.text,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      success: Color.lerp(success, other.success, t)!,
      background: Color.lerp(background, other.background, t)!,
      text: Color.lerp(text, other.text, t)!,
    );
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColors._lightPrimary,
    secondary: AppColors._lightSecondary,
    surface: AppColors._lightGray,
    onSurface: AppColors._lightText,
    onSurfaceVariant: AppColors._lightText,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  extensions: const [
    AppColorScheme(
      success: AppColors._lightSuccess,
      background: AppColors._lightBackground,
      text: AppColors._lightText,
    ),
  ],
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors._darkPrimary,
    secondary: AppColors._darkSecondary,
    surface: AppColors._darkGray,
    surfaceContainerLow: const Color.fromARGB(255, 56, 56, 56),
    onSurface: Colors.black,
    onSurfaceVariant: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),
  appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  extensions: const [
    AppColorScheme(
      success: AppColors._darkPrimary,
      background: AppColors._darkBackground,
      text: AppColors._darkText,
    ),
  ],
);

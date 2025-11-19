import 'package:flutter/material.dart';

class AppColors {
  static const Color lightPrimary = Color(0xFF007BFF);
  static const Color lightSecondary = Color(0xFFFFC107);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightGray = Color.fromARGB(255, 221, 221, 221);
  static const Color darkGray = Color.fromARGB(255, 197, 197, 197);
  static const Color lightText = Color(0xFF212529);
  static const Color lightSuccess = Color(0xFF28A745);
  static const Color darkPrimary = Color(0xFF4CAF50);
  static const Color darkSecondary = Color(0xFFFF9800);
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2C2C2C);
  static const Color darkText = Color.fromARGB(255, 237, 237, 238);
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
    primary: AppColors.lightPrimary,
    secondary: AppColors.lightSecondary,
    surface: AppColors.lightGray,
    onSurface: AppColors.lightText,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  extensions: const [
    AppColorScheme(
      success: AppColors.lightSuccess,
      background: AppColors.lightBackground,
      text: AppColors.lightText,
    ),
  ],
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkSecondary,
    surface: AppColors.darkGray,
    onSurface: Colors.black,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),
  extensions: const [
    AppColorScheme(
      success: AppColors.darkPrimary,
      background: AppColors.darkBackground,
      text: AppColors.darkText,
    ),
  ],
);

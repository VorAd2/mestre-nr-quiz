import 'package:flutter/material.dart';

class ThemeController {
  static final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  static void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
  }
}

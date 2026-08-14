// lib/design_system/app_theme.dart
import 'package:flutter/material.dart';
import 'package:my_car/design_system/theme/style/app_radius.dart';
import 'package:my_car/design_system/theme/style/colors.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: DefaultColors.white,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: DefaultColors.orange,
          onPrimary: DefaultColors.orange,
          surface: DefaultColors.orange,
          error: DefaultColors.error,
          onError: DefaultColors.error,
          secondary: DefaultColors.white,
          onSecondary: DefaultColors.white,
          onSurface: DefaultColors.white,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.all(AppRadius.md)),
        ),
      );

  static ThemeData get dark => light.copyWith(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: DefaultColors.black,
      );
}

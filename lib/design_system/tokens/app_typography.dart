import 'package:flutter/material.dart';

/// Escala tipográfica. A família e a cor são aplicadas pelo `AppTheme`;
/// aqui ficam só tamanho, peso e ritmo.
abstract final class AppTypography {
  static const fontFamily = 'Manrope';

  static const textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.25,
    ),
    titleLarge:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.3),
    titleMedium:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
    bodyLarge:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodyMedium:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: 0.2,
    ),
    labelMedium:
        TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.2),
    labelSmall:
        TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.2),
  );
}

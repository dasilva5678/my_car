import 'package:flutter/material.dart';

/// Paleta do app (tema escuro). Use os nomes semânticos — nunca cores
/// literais nas telas — para que trocar a identidade visual seja só
/// alterar este arquivo.
abstract final class AppColors {
  // Marca
  static const primary = Color(0xFFFF6F00);
  static const onPrimary = Color(0xFFFFFFFF);

  // Superfícies
  static const background = Color(0xFF0F0F11);
  static const surface = Color(0xFF1A1A1D);
  static const surfaceVariant = Color(0xFF26262B);
  static const border = Color(0xFF3A3A41);

  // Texto
  static const textPrimary = Color(0xFFF5F5F7);
  static const textSecondary = Color(0xFFA1A1AA);
  static const textDisabled = Color(0xFF6B6B74);

  // Feedback
  static const error = Color(0xFFEF5350);
  static const success = Color(0xFF43A047);
  static const warning = Color(0xFFFFB300);
  static const info = Color(0xFF42A5F5);
  static const onFeedback = Color(0xFFFFFFFF);
}

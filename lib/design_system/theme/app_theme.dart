import 'package:flutter/material.dart';
import 'package:my_car/design_system/tokens/app_colors.dart';
import 'package:my_car/design_system/tokens/app_radius.dart';
import 'package:my_car/design_system/tokens/app_spacing.dart';
import 'package:my_car/design_system/tokens/app_typography.dart';

/// Tema único do app (escuro). Todo estilo de componente nasce aqui para
/// que as telas não precisem de estilos inline.
abstract final class AppTheme {
  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(AppRadius.md),
  );

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      error: AppColors.error,
      onError: AppColors.onFeedback,
      outline: AppColors.border,
    );

    final textTheme = AppTypography.textTheme.apply(
      fontFamily: AppTypography.fontFamily,
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.background,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      dividerTheme: const DividerThemeData(color: AppColors.border),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primary),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withValues(alpha: 0.35),
        selectionHandleColor: AppColors.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          disabledForegroundColor: AppColors.onPrimary,
          minimumSize: const Size(64, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          elevation: 0,
          shape: _shape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(48, 44),
          shape: _shape,
          textStyle: textTheme.labelMedium,
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(textTheme),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceVariant,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: AppColors.onFeedback),
        shape: _shape,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(TextTheme textTheme) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: const BorderRadius.all(AppRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    Color stateColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.error)) return AppColors.error;
      if (states.contains(WidgetState.focused)) return AppColors.primary;
      return AppColors.textSecondary;
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: border(AppColors.border),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.primary, 1.5),
      errorBorder: border(AppColors.error),
      focusedErrorBorder: border(AppColors.error, 1.5),
      disabledBorder: border(AppColors.border.withValues(alpha: 0.5)),
      labelStyle:
          textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
        (states) => textTheme.bodyMedium!.copyWith(color: stateColor(states)),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textDisabled),
      errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
      prefixIconColor: WidgetStateColor.resolveWith(stateColor),
      suffixIconColor: WidgetStateColor.resolveWith(stateColor),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_car/design_system/components/custom_text.dart';
import 'package:my_car/design_system/tokens/app_colors.dart';
import 'package:my_car/design_system/tokens/app_spacing.dart';

enum AppSnackBarType {
  success(AppColors.success, Icons.check_circle_outline),
  error(AppColors.error, Icons.error_outline),
  info(AppColors.surfaceVariant, Icons.info_outline);

  final Color background;
  final IconData icon;

  const AppSnackBarType(this.background, this.icon);
}

/// Feedback padronizado. Prefira os atalhos de `BuildContext`:
/// `context.showError(...)`, `context.showSuccess(...)`.
abstract final class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: type.background,
          content: Row(
            children: [
              Icon(type.icon, color: AppColors.onFeedback),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: CustomText(message, color: AppColors.onFeedback),
              ),
            ],
          ),
        ),
      );
  }
}

extension AppSnackBarContext on BuildContext {
  void showError(String message) =>
      AppSnackBar.show(this, message: message, type: AppSnackBarType.error);

  void showSuccess(String message) =>
      AppSnackBar.show(this, message: message, type: AppSnackBarType.success);

  void showInfo(String message) => AppSnackBar.show(this, message: message);
}

import 'package:flutter/material.dart';
import 'package:my_car/design_system/tokens/app_colors.dart';

enum _AppButtonVariant { primary, text }

/// Botão do design system com estado de carregamento embutido: enquanto
/// [isLoading] for `true`, mostra um indicador e ignora toques.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;
  final _AppButtonVariant _variant;

  /// Ação principal da tela (preenchido, cor da marca).
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expanded = true,
  }) : _variant = _AppButtonVariant.primary;

  /// Ação secundária / link.
  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
  }) : _variant = _AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final onPressed = isLoading ? null : this.onPressed;
    final child = isLoading ? _loader : _content;

    final button = switch (_variant) {
      _AppButtonVariant.primary =>
        ElevatedButton(onPressed: onPressed, child: child),
      _AppButtonVariant.text => TextButton(onPressed: onPressed, child: child),
    };

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }

  Widget get _content {
    final text = Text(label, textAlign: TextAlign.center);
    if (icon == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Flexible(child: text)
      ],
    );
  }

  Widget get _loader => SizedBox.square(
        dimension: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: _variant == _AppButtonVariant.primary
              ? AppColors.onPrimary
              : AppColors.primary,
        ),
      );
}

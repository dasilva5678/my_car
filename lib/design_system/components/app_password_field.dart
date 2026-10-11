import 'package:flutter/material.dart';
import 'package:my_car/design_system/components/app_text_field.dart';

/// Campo de senha: começa oculto e alterna a visibilidade pelo ícone.
class AppPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool enabled;

  const AppPasswordField({
    super.key,
    this.controller,
    this.label = 'Senha',
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
    this.autofillHints = const [AutofillHints.password],
    this.enabled = true,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscured = true;

  void _toggleVisibility() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      prefixIcon: Icons.lock_outline,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      enabled: widget.enabled,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscured,
      suffix: IconButton(
        onPressed: _toggleVisibility,
        tooltip: _obscured ? 'Mostrar senha' : 'Ocultar senha',
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
    );
  }
}

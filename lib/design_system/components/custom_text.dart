import 'package:flutter/material.dart';

typedef _StyleResolver = TextStyle? Function(TextTheme theme);

/// Texto do design system. Cada construtor nomeado aplica um estilo do
/// `TextTheme`; os parâmetros opcionais sobrescrevem só o que for passado.
///
/// ```dart
/// CustomText.headline('My Car')
/// CustomText('Descrição', color: AppColors.textSecondary)
/// CustomText.label('Salvar', fontWeight: FontWeight.w800)
/// ```
class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final _StyleResolver _resolveStyle;

  /// Corpo de texto padrão (`bodyMedium`, 14).
  const CustomText(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _resolveStyle = _body;

  /// Título principal de tela (`headlineLarge`, 32).
  const CustomText.headline(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _resolveStyle = _headline;

  /// Título de seção (`headlineMedium`, 24).
  const CustomText.subheadline(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _resolveStyle = _subheadline;

  /// Título de card / item (`titleLarge`, 20).
  const CustomText.title(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _resolveStyle = _title;

  /// Subtítulo (`titleMedium`, 16 semibold).
  const CustomText.subtitle(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _resolveStyle = _subtitle;

  /// Corpo de texto maior (`bodyLarge`, 16).
  const CustomText.bodyLarge(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _resolveStyle = _bodyLarge;

  /// Rótulos de botões e chips (`labelLarge`, 15 bold).
  const CustomText.label(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _resolveStyle = _label;

  /// Texto auxiliar, legendas e metadados (`bodySmall`, 12).
  const CustomText.caption(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _resolveStyle = _caption;

  static TextStyle? _headline(TextTheme t) => t.headlineLarge;
  static TextStyle? _subheadline(TextTheme t) => t.headlineMedium;
  static TextStyle? _title(TextTheme t) => t.titleLarge;
  static TextStyle? _subtitle(TextTheme t) => t.titleMedium;
  static TextStyle? _bodyLarge(TextTheme t) => t.bodyLarge;
  static TextStyle? _body(TextTheme t) => t.bodyMedium;
  static TextStyle? _label(TextTheme t) => t.labelLarge;
  static TextStyle? _caption(TextTheme t) => t.bodySmall;

  @override
  Widget build(BuildContext context) {
    final base =
        _resolveStyle(Theme.of(context).textTheme) ?? const TextStyle();

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: base.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

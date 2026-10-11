import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final Color? colorText;
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const CustomText(
    this.text, {
    super.key,
    this.colorText,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: textAlign,
      style: TextStyle(
        color: colorText ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

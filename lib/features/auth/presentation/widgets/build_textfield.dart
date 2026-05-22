import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class BuildTextfield extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final String hint;
  final IconData? prefixIconData;
  final Widget? suffixIcon;

  const BuildTextfield({
    super.key, 
    required this.controller, 
    this.keyboardType, 
    this.obscure = false, 
    required this.hint, 
    this.prefixIconData, 
    this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: AppDecorations.inputField,
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(prefixIconData),
        suffixIcon: suffixIcon,
      ),
    ),
  );
  }
}
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/features/auth/presentation/widgets/label_text.dart';
import 'package:flutter/material.dart';

class EditProfileField extends StatelessWidget {
  const EditProfileField({super.key, required this.label, required this.controller, required this.icon, this.keyboard = TextInputType.text, required this.hintText});
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboard;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelText(text: label),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.containerDecoration,
            child: TextField(
              controller: controller,
              keyboardType: keyboard,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                prefixIcon: Icon(icon),
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
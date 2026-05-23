// Add this helper method inside _ProductFormState
import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProductTextfield extends StatelessWidget {
  const ProductTextfield({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboard = TextInputType.text, 
    this.maxLines = 1,
  });
  
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboard; 
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 8),
          Container(
            decoration: AppDecorations.containerDecoration,
            child: TextField(
              controller:   controller,
              keyboardType: keyboard,
              maxLines:     maxLines,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText:  hint ?? 'Enter $label',
                hintStyle: AppTextStyles.labelMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:   BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:   BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A1A1A),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
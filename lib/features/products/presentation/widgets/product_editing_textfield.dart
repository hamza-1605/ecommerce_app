// Add this helper method inside _ProductFormState
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
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller:   controller,
              keyboardType: keyboard,
              maxLines:     maxLines,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1A1A1A),
              ),
              decoration: InputDecoration(
                hintText:  hint ?? 'Enter $label',
                hintStyle: const TextStyle(
                  color: Color(0xFFBBBBBB),
                  fontSize: 14,
                ),
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
                filled:          true,
                fillColor:       Colors.white,
                contentPadding:  const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical:   16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
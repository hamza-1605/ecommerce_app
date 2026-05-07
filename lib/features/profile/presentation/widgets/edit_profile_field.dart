import 'package:ecommerce/features/auth/presentation/widgets/build_label.dart';
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboard,
              style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A), fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: const Color(0xFF888888), size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
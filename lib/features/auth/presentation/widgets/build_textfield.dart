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
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 15),
        prefixIcon: Icon(prefixIconData, color: const Color(0xFF888888), size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    ),
  );
  }
}
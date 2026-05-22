import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.shade50),
        child: Icon(
          Icons.close_rounded,
          size: 14,
          color: Colors.red.shade400,
        ),
      ),
    );
  }
}
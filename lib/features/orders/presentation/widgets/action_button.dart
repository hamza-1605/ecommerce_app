import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.label, required this.icon, required this.onTap, required this.isDelete});
  final String label;
  final IconData icon;
  final bool isDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDelete ? const Color(0xFFE53935) : const Color(0xFFFFEBEE) ,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: isDelete ? const Color(0xFFFFEBEE) : const Color(0xFFE53935)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDelete ? const Color(0xFFFFEBEE) : const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
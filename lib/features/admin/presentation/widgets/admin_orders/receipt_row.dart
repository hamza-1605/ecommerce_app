// ── Helper widgets ──────────────────────────────────
import 'package:flutter/material.dart';

class ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final double? valueSize;

  const ReceiptRow({super.key, required this.label, required this.value, this.valueColor, this.valueSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF888888))),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: valueSize ?? 13, fontWeight: FontWeight.w600, color: valueColor ?? const Color(0xFF1A1A1A)),
            ),
          ),
        ],
      ),
    );
  }
}
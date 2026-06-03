import 'package:flutter/material.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration get inputField => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 15,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Add more as needed
  static BoxDecoration get addProfileImageButton => BoxDecoration(
    color: const Color(0xFF1A1A1A),
    shape: BoxShape.circle,
    border: Border.all(
      color: Colors.white,
      width: 2,
    ),
  );

  static BoxDecoration get containerDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: BoxBorder.all(width: 0.5, color: Colors.black12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get tileIconDecoration => BoxDecoration(
    color: Colors.black12,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration get favIconDecoration => BoxDecoration(
    color: Colors.red.shade50,
    borderRadius: BorderRadius.circular(10),
  );

  static BoxDecoration get orderCardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: BoxBorder.all(color: Colors.black26, width: 0.5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get orderHeader => BoxDecoration(
    color: Color.fromARGB(255, 235, 235, 235),
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  );

  static BoxDecoration get cardItems => BoxDecoration(
    color: const Color(0xFFF2F0ED),
    borderRadius: BorderRadius.circular(6),
  );
  
  static BoxDecoration get saleTag => BoxDecoration(
    color: const Color(0xFFE53935),
    borderRadius: BorderRadius.circular(6),
  );

  static BoxDecoration get addImageBox => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: const Color(0xFFE0E0E0),
      width: 1.5,
    ),
  );

  static BoxDecoration get pillContainer => BoxDecoration(
    borderRadius: BorderRadius.circular(30),
  );
  

}
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
  
  // static BoxDecoration get card => BoxDecoration(
  //   color: Colors.white,
  //   borderRadius: BorderRadius.circular(16),
  //   boxShadow: [
  //     BoxShadow(
  //       color: Colors.black.withValues(alpha: 0.05),
  //       blurRadius: 10,
  //       offset: const Offset(0, 2),
  //     ),
  //   ],
  // );
}
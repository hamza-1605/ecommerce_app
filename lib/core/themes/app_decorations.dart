// lib/core/themes/app_decorations.dart

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
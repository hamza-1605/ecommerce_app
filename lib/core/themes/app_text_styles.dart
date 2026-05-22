import 'package:ekart/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // displayLarge
  static const TextStyle authPageHeading = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.1,
    color: AppColors.appMainColor,
    letterSpacing: -0,
  );

  // bodyMedium
  static const TextStyle authPageMessage = TextStyle(
    fontSize: 15,
    color: AppColors.textSecondary,
  );

  // labelMedium
  static const TextStyle authForgotPassword = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.fadedBlack,
  );

  // labelLarge
  static const TextStyle gradientButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: Colors.white
  );

  // bodyMedium
  static const TextStyle authBottomText = TextStyle(
    color: AppColors.textSecondary, 
    fontSize: 14
  );

  // bodyMedium CopyWith
  static TextStyle authBottomLink = bodyMedium.copyWith(
    color: AppColors.appMainColor,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.appMainColor,
  );

  // displayMedium 
  static const TextStyle appbar = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
    color: Colors.white,
  );

  // labelLarge
  static const TextStyle whiteButtonText = TextStyle(
    color: Colors.white, 
    fontWeight: FontWeight.w600,
    fontSize: 16
  );


// ----------------------------------------------------------
  // ✅
  static const TextStyle displayLarge = TextStyle(
    fontSize: 34, 
    fontWeight: FontWeight.w800, 
    color: AppColors.appMainColor, 
    letterSpacing: -0.5
  );

  // ✅
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28, 
    fontWeight: FontWeight.w800, 
    color: Colors.white, 
    letterSpacing: -0.5
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20, 
    fontWeight: FontWeight.w700, 
    color: AppColors.textPrimary
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w700, 
    color: AppColors.textPrimary
  );

  // ✅
  static const TextStyle titleSmall = TextStyle(
    fontSize: 13, 
    fontWeight: FontWeight.w600, 
    color: AppColors.textPrimary,
    letterSpacing: 0.2
  );

  // ✅
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15, 
    fontWeight: FontWeight.w400, 
    color: AppColors.textPrimary, 
    height: 1.2
  );

  // ✅
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, 
    fontWeight: FontWeight.w500, 
    color: AppColors.textSecondary, 
    height: 1.6
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, 
    fontWeight: FontWeight.w400, 
    color: AppColors.textSecondary
  );

  // ✅
  static const TextStyle labelLarge = TextStyle(
    fontSize: 15, 
    fontWeight: FontWeight.w700, 
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 13, 
    fontWeight: FontWeight.w600, 
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10, 
    fontWeight: FontWeight.w600, 
    color: AppColors.textSecondary, 
    letterSpacing: 0.6
  );

  // ✅
  static const TextStyle underlineLabel = TextStyle(
    fontSize: 13, 
    fontWeight: FontWeight.w600, 
    color: AppColors.textSecondary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.fadedBlack,
  );   
}
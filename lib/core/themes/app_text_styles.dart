import 'package:ekart/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  
  static const TextStyle authPageHeading = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.1,
    color: AppColors.appMainColor,
    letterSpacing: -0,
  );

  static const TextStyle authPageMessage = TextStyle(
    fontSize: 15,
    color: AppColors.fadedIconColor,
  );

  static const TextStyle authForgotPassword = TextStyle(
    color: AppColors.fadedIconColor,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    decorationColor: Color.fromARGB(125, 0, 0, 0),
  );

  static const TextStyle authButtonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle authBottomText = TextStyle(
    color: Color(0xFF888888), 
    fontSize: 14
  );

  static const TextStyle authBottomLink = TextStyle(
    color: AppColors.appMainColor,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.appMainColor,
  );

  static const TextStyle appbar = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
    color: Colors.white,
  );




  static const TextStyle whiteButtonText = TextStyle(
    color: Colors.white, 
    fontWeight: FontWeight.w600,
    fontSize: 16
  );
}
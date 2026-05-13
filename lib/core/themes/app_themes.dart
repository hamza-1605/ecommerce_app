import 'package:ekart/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class AppThemes {
  static ThemeData lightMode = ThemeData(
    colorScheme: .fromSeed(seedColor: Colors.blueGrey),
    
    appBarTheme: AppBarThemeData(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent
    ),



    inputDecorationTheme: InputDecorationThemeData(
      hintStyle: const TextStyle(color: AppColors.hintTextColor, fontSize: 15),
      prefixIconColor: AppColors.fadedIconColor,
      suffixIconColor: AppColors.fadedIconColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(18),
    ),




    extensions: <ThemeExtension<dynamic>>[
      GradientButtonThemeExtension(
        style: GradientElevatedButton.styleFrom(
          shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(16)),
          foregroundColor: Colors.white,
          backgroundGradient: const LinearGradient(
            colors: [
              AppColors.appMainColor, 
              AppColors.appMainDarkColor
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          disabledBackgroundGradient: LinearGradient(
            colors: [
              const Color.fromARGB(249, 245, 133, 72),
              const Color.fromARGB(249, 245, 133, 72)
            ]
          )
        ),
      ),
    ],
  );
}
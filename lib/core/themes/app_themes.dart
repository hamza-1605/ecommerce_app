import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class AppThemes {
  static ThemeData lightMode = ThemeData(
    appBarTheme: AppBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.appMainColor,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.appMainColor,
      foregroundColor: Colors.white
    ),

    tabBarTheme: TabBarThemeData(
      tabAlignment: TabAlignment.start,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black,
      indicatorColor: Colors.white
    ),


    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.bottomNavbar,
      elevation: 0,
      indicatorColor: Colors.black,

      iconTheme: WidgetStateProperty.resolveWith( (states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            size: 24,
            color: Colors.white
          );
        }
        return const IconThemeData(
          size: 22,
          color: Colors.black
        );
      }),

      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontWeight: FontWeight.w700,
          );
        }
        return const TextStyle(
          color: Colors.black
        );
      }),      
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
          iconColor: Colors.white,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.gradientButtonText,
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
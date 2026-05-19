import 'package:ekart/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.appMainColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
import 'package:ekart/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.chipBackground,
      child: const Center(
        child: Icon(Icons.inventory_2_outlined, size: 40),
      ),
    );
  }
}
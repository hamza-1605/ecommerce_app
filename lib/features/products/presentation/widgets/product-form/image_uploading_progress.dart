import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class ImageUploadingProgress extends StatelessWidget {
  const ImageUploadingProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text(
            'Uploading images...',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
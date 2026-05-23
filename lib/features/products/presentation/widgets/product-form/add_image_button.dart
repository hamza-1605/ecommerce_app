import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: AppDecorations.addImageBox,
        child: const Column(
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 32,),
            SizedBox(height: 6),
            Text(
              'Tap to add images',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key, required this.onTap, required this.iconData, required this.title, required this.subtitle});
  final VoidCallback onTap;
  final IconData iconData;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppDecorations.containerDecoration,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: AppDecorations.tileIconDecoration,
              child: Icon( iconData, color: iconData == Icons.favorite ? Colors.red : Colors.black, size: 20 ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( title, style: AppTextStyles.titleMedium),
                  SizedBox(height: 3),
                  Text( subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          ],
        ),
      ),
    );
  }
}
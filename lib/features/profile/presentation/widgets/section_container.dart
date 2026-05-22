import 'package:ekart/core/themes/app_decorations.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({super.key, required this.title, required this.rows});
  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.containerDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }
}
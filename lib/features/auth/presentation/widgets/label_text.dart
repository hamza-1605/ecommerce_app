import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String text;
  const LabelText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text( text,  style: AppTextStyles.titleSmall );
  }
}
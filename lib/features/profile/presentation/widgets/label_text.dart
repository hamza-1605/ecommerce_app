import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:flutter/widgets.dart';

class LabelText extends StatelessWidget {
  const LabelText({super.key, required this.text});
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.titleSmall
    );
  }
}
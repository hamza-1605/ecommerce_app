import 'package:flutter/widgets.dart';

class LabelText extends StatelessWidget {
  const LabelText({super.key, required this.text});
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        letterSpacing: 0.3,
      ),
    );
  }
}
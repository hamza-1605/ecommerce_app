import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({super.key, this.fontSize, this.fontWeight});
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      'E-Kart',
      style: TextStyle(
        fontSize: fontSize ?? 40,
        fontWeight: fontWeight ?? FontWeight.w800,
        height: 1.4,
        color: Color(0xFF1A1A1A),
        letterSpacing: -1,
      ),
    );
  }
}
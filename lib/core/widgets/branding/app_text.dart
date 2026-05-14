import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({super.key, this.fontSize, this.fontWeight, this.color});
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'E-Kart',
      style: TextStyle(
        fontSize: fontSize ?? 40,
        fontWeight: fontWeight ?? FontWeight.w800,
        height: 1.4,
        color: color ?? Colors.black,
        letterSpacing: -1,
      ),
    );
  }
}
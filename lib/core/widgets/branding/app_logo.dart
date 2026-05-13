import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.width});
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/ekart-logo.png',
      width: width ?? 100.0,
    );
  }
}
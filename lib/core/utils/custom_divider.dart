import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.indent});
  final double? indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1, 
      indent: indent ?? 10, 
      endIndent: indent ?? 10,
    );
  }
}
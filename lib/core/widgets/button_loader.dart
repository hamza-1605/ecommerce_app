import 'package:flutter/material.dart';

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22, height: 22,
      child: CircularProgressIndicator(
        color: Colors.white, strokeWidth: 2.5),
    );
  }
}
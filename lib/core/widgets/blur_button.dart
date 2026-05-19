import 'dart:ui';
import 'package:flutter/material.dart';

class BlurButton extends StatelessWidget {
  const BlurButton({super.key, required this.buttonIconData, required this.onPressed});

  final IconData buttonIconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Material(
          color: Colors.white.withAlpha(10),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              height: 30,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withAlpha(80),
                  width: 1,
                ),
              ),
              child: Icon(buttonIconData, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
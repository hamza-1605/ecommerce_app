import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: SafeArea(
        child: Stack( 
          fit: StackFit.expand,
          alignment: AlignmentGeometry.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: SvgPicture.asset(
                'assets/svg/ecommerce_wallpaper.svg',
                fit: BoxFit.cover,
                alignment: AlignmentGeometry.center,
              ),
            ),
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: child
            ),
          ]
        )
      )
    );
  }
}
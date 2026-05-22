import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundSvg extends StatelessWidget {
  const BackgroundSvg({super.key, this.opacity = 0.4});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SvgPicture.asset(
        'assets/svg/ecommerce_wallpaper.svg',
        fit: BoxFit.cover,
        alignment: AlignmentGeometry.center,
      ),
    );
  }
}
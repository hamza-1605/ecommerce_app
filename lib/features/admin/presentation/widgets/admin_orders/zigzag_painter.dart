// ── Zigzag edge painter ─────────────────────────────
import 'package:flutter/material.dart';

class ZigzagEdge extends StatelessWidget {
  final bool flip;
  const ZigzagEdge({super.key, required this.flip});

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipY: flip,
      child: CustomPaint(
        size: const Size(double.infinity, 12),
        painter: _ZigzagPainter(),
      ),
    );
  }
}

class _ZigzagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path();
    const step = 16.0;
    path.moveTo(0, size.height);
    for (double x = 0; x < size.width; x += step) {
      path.lineTo(x + step / 2, 0);
      path.lineTo(x + step, size.height);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
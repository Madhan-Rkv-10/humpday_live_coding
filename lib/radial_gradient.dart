import 'package:flutter/material.dart';

void main() {
  runApp(
    ColoredBox(
      color: Colors.black,
      child: InteractiveViewer(
        maxScale: 1000,
        child: CustomPaint(
          painter: _ButterSmoothRadialGradientPainter(),
          child: SizedBox.expand(),
        ),
      ),
    ),
  );
}

/// Nope; I just need a customPainter
class _ButterSmoothRadialGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = RadialGradient(
      focal: Alignment.center,
      colors: const [
        Color(0xFF1E2036), // Deep Blue-Gray
        Color(0xFF343C59), // Muted Slate Blue
      ],
    );

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///https://www.youtube.com/watch?v=QiLPSsD9kRc&t=8117s
void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
      value: 0.25,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return PieProgressIndicator(progress: _controller.value);
            },
          ),
        ),
      ),
    );
  }
}

class PieProgressIndicator extends StatelessWidget {
  const PieProgressIndicator({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 2.0,
          child: CustomPaint(
            painter: _PieProgressIndicatorPainter(
              progress: progress,
              sectionColors: [
                Colors.red,
                Colors.deepOrange,
                Colors.amber,
                Colors.lime,
                Colors.green,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PieProgressIndicatorPainter extends CustomPainter {
  _PieProgressIndicatorPainter({
    required this.progress,
    required this.sectionColors,
  });

  double progress;
  List<Color> sectionColors;

  @override
  void paint(Canvas canvas, Size size) {
    final dialRect = Offset.zero & Size(size.width, size.height * 2);
    final dialRectCenter = dialRect.center;

    const allSectionPaddingAngle = math.pi * 0.1;
    final sectionPaddingAngle =
        allSectionPaddingAngle / math.max(0, sectionColors.length - 1);
    final sectionAngle =
        ((math.pi - allSectionPaddingAngle) / sectionColors.length);

    for (int i = 0; i < sectionColors.length; i++) {
      final piePath = Path.combine(
        PathOperation.difference,
        Path()
          ..addArc(
            dialRect,
            math.pi + (sectionAngle * i) + (sectionPaddingAngle * i),
            sectionAngle,
          )
          ..lineTo(dialRectCenter.dx, dialRectCenter.dy)
          ..close(),
        Path()..addOval(
          Rect.fromCircle(
            center: dialRectCenter,
            radius: dialRect.longestSide * 0.10,
          ),
        ),
      );

      canvas.drawPath(piePath, Paint()..color = sectionColors[i]);
    }

    final indicatorSize = dialRect.shortestSide * 0.025;
    final indicatorExtent = Offset.fromDirection(
      math.pi + (math.pi * progress),
      (dialRect.shortestSide * 0.5) - indicatorSize * 3,
    );

    final indicatorLeft = Offset.fromDirection(
      math.pi + (math.pi * progress) - (math.pi * 0.5),
      indicatorSize,
    );

    final indicatorRight = Offset.fromDirection(
      math.pi + (math.pi * progress) + (math.pi * 0.5),
      indicatorSize,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..moveTo(indicatorExtent.dx, indicatorExtent.dy)
          ..lineTo(indicatorRight.dx, indicatorRight.dy)
          ..arcToPoint(indicatorLeft, radius: Radius.circular(indicatorSize)),
        Path()..addOval(
          Rect.fromCircle(center: Offset.zero, radius: indicatorSize / 3),
        ),
      ).shift(dialRectCenter),
      Paint()..color = Colors.grey.shade900,
    );
  }

  @override
  bool shouldRepaint(covariant _PieProgressIndicatorPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        !listEquals(sectionColors, oldDelegate.sectionColors);
  }
}

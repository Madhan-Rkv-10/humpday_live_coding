import 'package:flutter/material.dart';

void main() {
  runApp(
    Material(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: Flow(
            delegate: FlowBoundaryDelegate(),
            children: List.generate(
              5,
              (i) => Container(
                color: Colors.primaries[i].withAlpha(50 * i),
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Text("$i"),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class FlowBoundaryDelegate extends FlowPainterDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    double dy = 0;
    for (int i = 0; i < context.childCount; i++) {
      context.paintChild(
        i,
        transform:
            Matrix4.identity() //
              ..translate(0, dy),
      );
      dy += context.getChildSize(i)!.height + 24;
    }
  }

  @override
  void foregroundPaint(Canvas canvas, Size size) {}

  @override ///*can we make it work
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height).deflate(40);
    final Paint paint = Paint()..color = Colors.red;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }
}

/// My goal is to expose the [FlowPaintingContext],what gonna be good way
/// - childSize and layout  position
///
abstract class FlowPainterDelegate extends FlowDelegate {
  const FlowPainterDelegate();

  void paint(Canvas canvas, Size size);
  void foregroundPaint(Canvas canvas, Size size);
}

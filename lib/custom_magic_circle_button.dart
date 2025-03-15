// MIT License
//
// Copyright (c) 2024 Simon Lightfoot
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Placeholder(
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: Center(
              child: MagicCircle(
                onTap: () {
                  //                   showDialog(
                  //                     context: context,
                  //                     builder: (context) {
                  //                       return AlertDialog(
                  //                         content: Text('You\'ve been alerted!'),
                  //                         actions: [
                  //                           TextButton(
                  //                             onPressed: () => Navigator.of(context).pop(),
                  //                             child: Text('Dismiss'),
                  //                           ),
                  //                         ],
                  //                       );
                  //                     },
                  //                   );
                },
                child: Center(
                  child: Text(
                    'TESTING',
                    maxLines: 1,
                    style: TextStyle(fontSize: 32.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MagicCircle extends SingleChildRenderObjectWidget {
  const MagicCircle({super.key, this.onTap, super.child});

  final VoidCallback? onTap;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMagicCircle(onTap: onTap);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderMagicCircle renderObject,
  ) {
    renderObject.onTap = onTap;
  }
}

class RenderMagicCircle extends RenderShiftedBox {
  RenderMagicCircle({required this.onTap, RenderBox? child}) : super(child);

  VoidCallback? onTap;

  bool _pressed = false;

  @override
  void performLayout() {
    final dimension = constraints.biggest.shortestSide;
    size = Size(dimension, dimension);
    if (child case RenderBox child) {
      child.layout(BoxConstraints(), parentUsesSize: true);
      (child.parentData as BoxParentData).offset =
          Alignment.center.inscribe(child.size, Offset.zero & size).topLeft;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = _pressed ? Colors.yellow : Colors.red;
    final rect = offset & size;
    context.canvas.drawCircle(rect.center, size.shortestSide / 2, paint);
    context.clipPathAndPaint(
      Path()..addOval(rect),
      Clip.antiAlias,
      rect,
      () => super.paint(context, offset),
    );
  }

  @override
  bool hitTestSelf(Offset position) {
    return isPointInsideCircle(position, Offset.zero & size);
  }

  bool isPointInsideCircle(Offset point, Rect bounds) {
    // Calculate the distance between the point and the center of the circle
    double distance = math.sqrt(
      math.pow(point.dx - bounds.center.dx, 2) +
          math.pow(point.dy - bounds.center.dy, 2),
    );

    // If the distance is less than or equal to the radius, the point is
    // inside or on the circle
    return distance <= (bounds.shortestSide / 2);
  }

  @override
  void handleEvent(
    PointerEvent event,
    covariant HitTestEntry<HitTestTarget> entry,
  ) {
    if (event is PointerDownEvent) {
      _pressed = true;
      markNeedsPaint();
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _pressed = false;
      markNeedsPaint();
      if (onTap case VoidCallback onTap when hitTestSelf(event.localPosition)) {
        onTap();
      }
    }
  }
}

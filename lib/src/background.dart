import 'package:flutter/material.dart';

abstract class NodeEditorBackgroundBase {
  const NodeEditorBackgroundBase();
  void paint(Canvas canvas, Size size);
}

class SolidBackground extends NodeEditorBackgroundBase {
  final Color color;
  const SolidBackground(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()..color = color;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
  }
}

class GridBackground extends NodeEditorBackgroundBase {
  final Color backgroundColor;
  final Color lineColor;
  final double spacing;
  final double strokeWidth;

  const GridBackground(
      {this.backgroundColor = const Color.fromRGBO(74, 72, 67, 1.0),
      this.lineColor = const Color.fromRGBO(30, 30, 30, 1.0),
      this.spacing = 20.0,
      this.strokeWidth = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth;

    Paint backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double j = 0; j < size.height; j += spacing) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), paint);
    }
  }
}

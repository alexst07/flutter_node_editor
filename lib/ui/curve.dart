import 'dart:ui';

class ConnectionCurve {
  Path path;
  Paint paint;

  ConnectionCurve({required this.path, required this.paint});
}

ConnectionCurve drawCurve(
    Offset startPoint, Offset endPoint, Color color, double strokeWidth) {
  var paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth
    ..style = PaintingStyle.stroke;

  // Adjust the amount of curve
  double curveDistance = 200.0; // You can adjust this value as needed

  // Control points for the bezier curve
  Offset controlPoint1;
  Offset controlPoint2;

  if (startPoint.dx > endPoint.dx) {
    // When startPoint is to the right of endPoint, curve outwards
    controlPoint1 = Offset(startPoint.dx + curveDistance, startPoint.dy);
    controlPoint2 = Offset(endPoint.dx - curveDistance, endPoint.dy);
  } else {
    // Regular straight bezier curve
    controlPoint1 = Offset((startPoint.dx + endPoint.dx) / 2, startPoint.dy);
    controlPoint2 = Offset((startPoint.dx + endPoint.dx) / 2, endPoint.dy);
  }

  var path = Path()
    ..moveTo(startPoint.dx, startPoint.dy)
    ..cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

  return ConnectionCurve(path: path, paint: paint);
}

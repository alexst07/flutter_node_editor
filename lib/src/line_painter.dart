import 'package:flutter/material.dart';
import 'package:node_editor/node_editor.dart';

import 'nodes.dart';

class LinePainter extends CustomPainter {
  const LinePainter(
      {required this.controller,
      required this.context,
      required this.background});

  final NodeEditorController controller;
  final BuildContext context;
  final NodeEditorBackgroundBase background;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the background
    background.paint(canvas, size);

    if (controller.startPointConnection != null &&
        controller.mousePoint != null) {
      Offset? pos =
          getPortPosition(controller.outNodeName!, controller.outPortName!);
      _drawConnection(
          canvas,
          size,
          pos!,
          controller.mousePoint!,
          Color.fromRGBO(
              controller.outTheme!.color.red,
              controller.outTheme!.color.green,
              controller.outTheme!.color.blue,
              0.7),
          controller.outTheme!.strokeWidth);
    }

    drawConnections(canvas, size);
  }

  _drawConnection(Canvas canvas, Size size, Offset startPoint, Offset endPoint,
      Color color, double strokeWidth) {
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

    canvas.drawPath(path, paint);
  }

  Offset? getPortPosition(String nodeName, String portName) {
    Port? port = controller.getPort(nodeName, portName);

    if (port == null) {
      return null;
    }

    if (port is InPort) {
      Offset? pos = getObjectPosition(port.globalKey);
      Size iconSize = getObjectSize(port.globalKey);

      return Offset(
          pos.dx + iconSize.width * 3 / 4, pos.dy + iconSize.height / 2);
    } else if (port is OutPort) {
      Offset? pos = getObjectPosition(port.globalKey);
      Size iconSize = getObjectSize(port.globalKey);

      return Offset(
          pos.dx + iconSize.width * 3 / 4, pos.dy + iconSize.height / 2);
    } else {
      throw Exception('Port type not valid');
    }
  }

  /// get the position of object in the screen, correcting by the position of
  /// vertical and horizontal scroll
  Offset getObjectPosition(GlobalKey key) {
    var obj = key.currentContext?.findRenderObject();
    final RenderBox stackRenderBox = obj as RenderBox;

    // fix position by scroll position
    return stackRenderBox.localToGlobal(Offset.zero) -
        controller.stackPos! +
        Offset(controller.horizontalScrollController.offset,
            controller.verticalScrollController.offset);
  }

  Size getObjectSize(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  void drawConnections(Canvas canvas, Size size) {
    for (Connection conn in controller.connections) {
      Offset? startPoint = getPortPosition(conn.outNode, conn.outPort);
      Offset? endPoint = getPortPosition(conn.inNode, conn.inPort);

      if (startPoint == null || endPoint == null) continue;

      _drawConnection(canvas, size, startPoint, endPoint, conn.theme.color,
          conn.theme.strokeWidth + (conn.selected ? 2 : 0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

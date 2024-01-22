import 'dart:ui';

import 'package:flutter/material.dart';

import 'controller.dart';
import 'curve.dart';
import 'nodes.dart';
import 'render_info.dart';

class ConnectionTheme {
  final Color color;
  final double strokeWidth;

  ConnectionTheme({required this.color, required this.strokeWidth});
}

class Connection {
  NodeModel inNode;
  NodeModel outNode;
  Port inPort;
  Port outPort;
  bool selected;
  late ConnectionPathBase connectionPath;

  Connection({
    required this.inPort,
    required this.inNode,
    required this.outNode,
    required this.outPort,
    this.selected = false,
  }) {
    connectionPath =
        SolidConnectionPath(inputPort: inPort, outputPort: outPort);
  }
}

class ConnectionPoint {
  String outNode;
  String outPort;

  ConnectionPoint({required this.outNode, required this.outPort});
}

class ConnectionsManager {
  List<Connection> connections = [];
  ConnectionPoint? startConnection;
  String? outPortName;
  String? outNodeName;
  ConnectionTheme? outTheme;
  bool? outDominant;
  Offset? startPointConnection;
  Offset? mousePoint;
  List<Connection> selectedConnections = [];
  bool isShiftPressed = false;

  void addConnectionByTap(Map<String, NodeModel> nodes,
      {required String inPort, required String inNode}) {
    if (outNodeName == null || outPortName == null) {
      return;
    }

    bool Function(String, String)? onConnect =
        (nodes[inNode]?.ports[inPort] as InPort).onConnect;

    if (onConnect == null || !onConnect.call(outNodeName!, outPortName!)) {
      outNodeName = null;
      outPortName = null;
      startPointConnection = null;
      mousePoint = null;
      return;
    }

    var conn = Connection(
        inNode: nodes[inNode]!,
        inPort: nodes[inNode]!.ports[inPort]!,
        outNode: nodes[outNodeName]!,
        outPort: nodes[outNodeName]!.ports[outPortName]!);

    connections.add(conn);
    outNodeName = null;
    outPortName = null;
    startPointConnection = null;
    mousePoint = null;
  }

  void removeConnection(Connection connection) {
    connections.removeWhere((conn) =>
        conn.inNode.name == connection.inNode.name &&
        conn.inPort.name == connection.inPort.name &&
        conn.outNode.name == connection.outNode.name &&
        conn.outPort.name == connection.outPort.name);
  }

  void removeSelected() {
    for (var connSelected in selectedConnections) {
      removeConnection(connSelected);
    }
  }

  void setConnecting(NodeEditorController controller,
      Map<String, NodeModel> nodes, String nameNode, String namePort) {
    NodeItem? item = nodes[nameNode]?.ports[namePort];
    outTheme = nodes[nameNode]?.ports[namePort]?.connectionTheme;
    outDominant = nodes[nameNode]?.ports[namePort]?.dominant;

    if (item is OutPort) {
      var obj = item.globalKey.currentContext?.findRenderObject();
      if (obj == null) {
        return;
      }
      final RenderBox stackRenderBox = obj as RenderBox;
      startPointConnection =
          stackRenderBox.localToGlobal(Offset.zero) - controller.stackPos!;
      outNodeName = nameNode;
      outPortName = namePort;
    }
  }

  void unsetConnecting() {
    outNodeName = null;
    outPortName = null;
    startPointConnection = null;
    mousePoint = null;
  }

  bool isInputPortConnected(String nodeName, String portName) {
    return connections.any((connection) =>
        connection.inNode.name == nodeName &&
        connection.inPort.name == portName);
  }

  bool isOutputPortConnected(String nodeName, String portName) {
    return connections.any((connection) =>
        connection.outNode.name == nodeName &&
        connection.outPort.name == portName);
  }

  List<Connection> getSelected() {
    List<Connection> conns = [];
    for (var conn in connections) {
      if (conn.selected) {
        conns.add(conn);
      }
    }

    return conns;
  }

  void selectOnTap(NodeEditorController controller, Offset tapPosition) {
    debugPrint('selectOnTap->tapPosition: $tapPosition');
    for (var conn in connections) {
      Offset? startPoint = getPortPosition(controller, conn.outPort);
      Offset? endPoint = getPortPosition(controller, conn.inPort);

      if (startPoint == null || endPoint == null) continue;

      bool v = conn.connectionPath
          .checkTapInLine(tapPosition, startPoint, endPoint, 5);
      if (!(isShiftPressed && conn.selected)) {
        conn.selected = v;
      }

      if (v) {
        controller.onSelectListener?.call(conn);
      }
    }
  }

  mousePosition(Offset pos) {
    if (startPointConnection != null) {
      mousePoint = pos;
      debugPrint('Mouse set_pos: $pos');
    }
  }
}

abstract class ConnectionPathBase {
  final Port inputPort;
  final Port outputPort;

  ConnectionPathBase({required this.inputPort, required this.outputPort});

  Color get color;
  double get strokeWidth;

  bool checkTapInLine(Offset tapPosition, Offset startPoint, Offset endPoint,
      double tolerance) {
    var curve = drawCurve(startPoint, endPoint, selected: false);
    for (PathMetric pathMetric in curve.path.computeMetrics()) {
      final double pathLength = pathMetric.length;

      // Iterate through each point in the path and check its distance to the
      // tap position
      for (double distance = 0.0; distance < pathLength; distance += 1.0) {
        final Tangent? tangent = pathMetric.getTangentForOffset(distance);
        final Offset? point = tangent?.position;

        if (point != null && (point - tapPosition).distance <= tolerance) {
          return true;
        }
      }
    }
    return false;
  }

  void drawConnection(Canvas canvas, Size size,
      {required Offset startPoint,
      required Offset endPoint,
      bool selected = false}) {
    ConnectionCurve curve = drawCurve(startPoint, endPoint, selected: selected);
    canvas.drawPath(curve.path, curve.paint);
  }

  ConnectionCurve drawCurve(Offset startPoint, Offset endPoint,
      {required bool selected});
}

class SolidConnectionPath extends ConnectionPathBase {
  final Color _color;
  final double _strokeWidth;

  SolidConnectionPath({required super.inputPort, required super.outputPort})
      : _color = outputPort.dominant
            ? outputPort.connectionTheme.color
            : inputPort.dominant
                ? inputPort.connectionTheme.color
                : outputPort.connectionTheme.color,
        _strokeWidth = outputPort.dominant
            ? outputPort.connectionTheme.strokeWidth
            : inputPort.dominant
                ? inputPort.connectionTheme.strokeWidth
                : outputPort.connectionTheme.strokeWidth;

  @override
  Color get color => _color;

  @override
  double get strokeWidth => _strokeWidth;

  @override
  ConnectionCurve drawCurve(Offset startPoint, Offset endPoint,
      {required bool selected}) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth + (selected ? 3 : 0)
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
}

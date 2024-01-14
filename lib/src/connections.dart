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
  String inNode;
  String outNode;
  String inPort;
  String outPort;
  ConnectionTheme theme;
  bool selected;

  Connection({
    required this.inPort,
    required this.inNode,
    required this.outNode,
    required this.outPort,
    required this.theme,
    this.selected = false,
  });
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

  void addConnectionByTap(Map<String, NodeModel> nodes,
      {required String inPort, required String inNode}) {
    if (outNodeName == null || outPortName == null) {
      return;
    }
    ConnectionTheme connectionTheme;

    if (outDominant == true) {
      connectionTheme = outTheme!;
    } else if (nodes[inNode]!.ports[inPort]!.dominant == true) {
      connectionTheme = nodes[inNode]!.ports[inPort]!.connectionTheme;
    } else {
      connectionTheme = outTheme!;
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

    Connection conn = Connection(
        inNode: inNode,
        inPort: inPort,
        outNode: outNodeName!,
        outPort: outPortName!,
        theme: connectionTheme);
    connections.add(conn);
    outNodeName = null;
    outPortName = null;
    startPointConnection = null;
    mousePoint = null;
  }

  void removeConnection(
      {required String inNodeName,
      required String inPortName,
      required String outNodeName,
      required String outPortName}) {
    connections.removeWhere((conn) =>
        conn.inNode == inNodeName &&
        conn.inPort == inPortName &&
        conn.outNode == outNodeName &&
        conn.outPort == outPortName);
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

  bool isInputPortConnected(String nodeName, String portName) {
    return connections.any((connection) =>
        connection.inNode == nodeName && connection.inPort == portName);
  }

  bool isOutputPortConnected(String nodeName, String portName) {
    return connections.any((connection) =>
        connection.outNode == nodeName && connection.outPort == portName);
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
      Offset? startPoint =
          getPortPosition(controller, conn.outNode, conn.outPort);
      Offset? endPoint = getPortPosition(controller, conn.inNode, conn.inPort);

      if (startPoint == null || endPoint == null) continue;

      var curve = drawCurve(
          startPoint, endPoint, conn.theme.color, conn.theme.strokeWidth);
      bool v = checkTapOnLine(tapPosition, curve, 3);
      conn.selected = v;
      if (v) {
        controller.onSelectListener?.call(conn);
      }
    }
    controller.notify();
  }

  bool checkTapOnLine(
      Offset tapPosition, ConnectionCurve curve, double tolerance) {
    for (PathMetric pathMetric in curve.path.computeMetrics()) {
      final double pathLength = pathMetric.length;

      // Iterate through each point in the path and check its distance to the tap position
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

  mousePosition(Offset pos) {
    if (startPointConnection != null) {
      mousePoint = pos;
      debugPrint('Mouse set_pos: $pos');
    }
  }
}

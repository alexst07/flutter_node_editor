import 'dart:ui';

import 'package:flutter/material.dart';

import 'curve.dart';
import 'node_widget.dart';

abstract class NodeItem {
  final String name;

  const NodeItem({required this.name});
}

abstract class Port extends NodeItem {
  final bool multiConnections;
  final int? maxConnections;
  final GlobalKey globalKey;
  final bool dominant;
  final ConnectionTheme connectionTheme;

  const Port(
      {required super.name,
      required this.globalKey,
      this.multiConnections = false,
      this.dominant = false,
      required this.connectionTheme,
      this.maxConnections});
}

class InPort extends Port {
  final Widget inputIcon;
  final bool Function(String, String)? onConnect;

  const InPort(
      {required super.name,
      required super.globalKey,
      required this.inputIcon,
      required super.connectionTheme,
      this.onConnect,
      super.multiConnections = false,
      super.maxConnections});
}

class OutPort extends Port {
  final Widget outputIcon;

  const OutPort(
      {required super.name,
      required super.globalKey,
      required this.outputIcon,
      required super.connectionTheme,
      super.multiConnections = false,
      super.maxConnections});
}

class PortData {}

class Property extends NodeItem {
  Property({required super.name, this.value});

  dynamic value;
}

class NodeModel {
  Map<String, Port> ports = {};
  Map<String, Property> properties = {};
  final BlueprintNode blueprintNode;
  final BlueprintNodeInheritedWidget inheritedWidget;
  final GlobalKey globalKey;
  Offset pos;
  bool minimized = false;

  NodeModel(
      {required this.blueprintNode, required this.globalKey, required this.pos})
      : inheritedWidget = BlueprintNodeInheritedWidget(
          key: globalKey,
          blueprintNode: blueprintNode,
        );

  addPort(Port port) {
    ports[port.name] = port;
  }

  addProperty(Property property) {
    properties[property.name] = property;
  }

  Map<String, dynamic> getPorts() {
    Map<String, dynamic> portsMap = {};
    for (var p in ports.entries) {
      portsMap[p.key] = {
        'type': p.value is OutPort ? 'output' : 'input',
        'multiConnections': p.value.multiConnections,
        'maxConnections': p.value.maxConnections,
      };
    }

    return portsMap;
  }

  Map<String, dynamic> getProperties() {
    Map<String, dynamic> propMap = {};
    for (var p in properties.entries) {
      propMap[p.key] = p.value.value;
    }

    return propMap;
  }

  Map<String, dynamic> toMap() {
    return {
      'ports': getPorts(),
      'properties': getProperties(),
    };
  }
}

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

class BlueprintController with ChangeNotifier {
  Map<String, NodeModel> nodes = {};
  List<Connection> connections = [];
  ConnectionPoint? startConnection;
  String? outPortName;
  String? outNodeName;
  ConnectionTheme? outTheme;
  bool? outDominant;
  Offset? startPointConnection;
  Offset? mousePoint;
  Offset? stackPos;
  Offset canvasSize = Offset.zero;
  Size? currentScreenSize;
  List<Connection> selectedConnections = [];
  late ScrollController horizontalScrollController;
  late ScrollController verticalScrollController;
  void Function(Connection conn)? onSelectListener;

  void addSelectListener(void Function(Connection conn)? fn) {
    onSelectListener = fn;
  }

  void addNode(BlueprintNode nodeWidget) {
    GlobalKey globalKey = GlobalKey();
    NodeModel nodeModel = NodeModel(
        globalKey: globalKey,
        blueprintNode: nodeWidget,
        pos: nodeWidget.initPosition);

    nodes[nodeWidget.name] = nodeModel;
    notifyListeners();
  }

  void addInPort(String nodeName, InPort inPortInfo) {
    nodes[nodeName]?.addPort(inPortInfo);
  }

  void addOutPort(String nodeName, OutPort outPortInfo) {
    nodes[nodeName]?.addPort(outPortInfo);
  }

  void addProperty(String nodeName, Property property) {
    nodes[nodeName]?.addProperty(property);
  }

  void addConnection({required String inPort, required String inNode}) {
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
      notifyListeners();
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
    notifyListeners();
  }

  void moveNodePosition(String name, Offset delta) {
    debugPrint('moveNodePosition');
    nodes[name]?.pos += delta;
    notifyListeners();
  }

  void setConnecting(String nameNode, String namePort) {
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
          stackRenderBox.localToGlobal(Offset.zero) - stackPos!;
      outNodeName = nameNode;
      outPortName = namePort;
      notifyListeners();
    }
  }

  Port? getPort(String nodeName, String portName) {
    var port = nodes[nodeName]?.ports[portName];

    if (port is Port) {
      return port;
    } else {
      return null;
    }
  }

  mousePosition(Offset pos) {
    if (startPointConnection != null) {
      mousePoint = pos;
      debugPrint('Mouse set_pos: $pos');
      notifyListeners();
    }
  }

  Size getNodeWidgetSize(String nodeName) {
    GlobalKey? key = nodes[nodeName]?.globalKey;

    if (key == null) {
      throw Exception('node: $nodeName not found');
    }

    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  Size getMaxScreenSize() {
    double px = 0;
    double py = 0;
    for (var nodeName in nodes.keys) {
      Offset pos = nodes[nodeName]!.pos;
      Size size = getNodeWidgetSize(nodeName);
      px = pos.dx + size.width > px ? pos.dx + size.width : px;
      py = pos.dy + size.height > py ? pos.dy + size.height : py;
    }

    return Size(px, py);
  }

  /// get the position of object in the screen, correcting by the position of
  /// vertical and horizontal scroll
  Offset getObjectPosition(GlobalKey key) {
    var obj = key.currentContext?.findRenderObject();
    final RenderBox stackRenderBox = obj as RenderBox;

    // fix position by scroll position
    return stackRenderBox.localToGlobal(Offset.zero) -
        stackPos! +
        Offset(
            horizontalScrollController.offset, verticalScrollController.offset);
  }

  Size getObjectSize(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  Offset? getPortPosition(String nodeName, String portName) {
    Port? port = getPort(nodeName, portName);

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

  void selectOnTap(Offset tapPosition) {
    debugPrint('selectOnTap->tapPosition: $tapPosition');
    for (var conn in connections) {
      Offset? startPoint = getPortPosition(conn.outNode, conn.outPort);
      Offset? endPoint = getPortPosition(conn.inNode, conn.inPort);

      if (startPoint == null || endPoint == null) continue;

      var curve = drawCurve(
          startPoint, endPoint, conn.theme.color, conn.theme.strokeWidth);
      bool v = checkTapOnLine(tapPosition, curve, 3);
      conn.selected = v;
      if (v) {
        onSelectListener?.call(conn);
      }
    }
    notifyListeners();
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

  notify() {
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> m = {};

    for (var entry in nodes.entries) {
      m[entry.key] = entry.value.toMap();
    }

    return m;
  }
}

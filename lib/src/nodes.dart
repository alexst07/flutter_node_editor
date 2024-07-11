import 'package:flutter/material.dart';

import 'connections.dart';
import 'node_widget.dart';
import 'position.dart';

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
  final NodeWidgetBase blueprintNode;
  final NodeEditorInheritedWidget inheritedWidget;
  final GlobalKey globalKey;
  Offset pos;
  bool minimized = false;
  bool selected = false;

  NodeModel(
      {required this.blueprintNode, required this.globalKey, required this.pos})
      : inheritedWidget = NodeEditorInheritedWidget(
          key: globalKey,
          blueprintNode: blueprintNode,
        );

  String get name => blueprintNode.name;

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

class NodesManager {
  Map<String, NodeModel> nodes = {};
  Offset _positionAfterLast = Offset.zero;
  bool isShiftPressed = false;

  Offset _calculateInitPos(NodePosition pos) {
    if (pos.type == NodePositionType.startScreen) {
      return const Offset(0, 0);
    } else if (pos.type == NodePositionType.custom) {
      // In this case NodePosition guarantee that position attribute is filled
      return pos.position!;
    }

    return _positionAfterLast;
  }

  _calculateLastPosition() {
    double maxPos = 0;
    double yPos = 0;
    for (var node in nodes.entries) {
      double width = getNodeWidgetSize(node.key).width;
      double posX = node.value.pos.dx;
      if (maxPos < (posX + width)) {
        maxPos = posX + width;
        yPos = node.value.pos.dy;
      }
    }

    _positionAfterLast = Offset(maxPos, yPos);
  }

  void addNode(NodeWidgetBase nodeWidget, NodePosition position) {
    GlobalKey globalKey = GlobalKey();

    // Calculate the start position of the widget node
    Offset initPos = _calculateInitPos(position);

    NodeModel nodeModel = NodeModel(
        globalKey: globalKey, blueprintNode: nodeWidget, pos: initPos);

    nodes[nodeWidget.name] = nodeModel;

    // If the start position of the widget node plus the widget node width is
    // greater than _positionAfterLast, update _positionAfterLast
    if ((initPos.dx + nodeWidget.width) > _positionAfterLast.dx) {
      _positionAfterLast = Offset(initPos.dx + nodeWidget.width, initPos.dy);
    }
  }

  void removeNode(ConnectionsManager connectionManager, String nodeName) {
    connectionManager.removeConnectionsFromNode(nodeName);
    nodes.remove(nodeName);
    _calculateLastPosition();
  }

  void removeSelectedNodes(ConnectionsManager connectionManager) {
    for (var node in nodes.values) {
      if (node.selected) {
        connectionManager.removeConnectionsFromNode(node.name);
      }
    }

    nodes.removeWhere((key, value) => value.selected);
  }

  void selectNode(String nodeName) {
    nodes[nodeName]?.selected = true;
  }

  void selectNodeAction(String nodeName) {
    if (!isShiftPressed) {
      unselectAllNodes();
      nodes[nodeName]?.selected = true;
    } else {
      nodes[nodeName]?.selected = !(nodes[nodeName]?.selected ?? false);
    }
  }

  void unselectAllNodes() {
    for (var node in nodes.values) {
      node.selected = false;
    }
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

  void moveNodePosition(String name, Offset delta) {
    if ((nodes[name]!.pos + delta).dy < 0 ||
        (nodes[name]!.pos + delta).dx < 0) {
      return;
    }
    nodes[name]?.pos += delta;
    _calculateLastPosition();
  }

  Port? getPort(String nodeName, String portName) {
    var port = nodes[nodeName]?.ports[portName];

    if (port is Port) {
      return port;
    } else {
      return null;
    }
  }

Size getNodeWidgetSize(String nodeName) {
  NodeModel? nodeModel = nodes[nodeName];
  if (nodeModel == null) {
    throw Exception('node: $nodeName not found');
  }

  final GlobalKey key = nodeModel.globalKey;

  Size size = Size.zero;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      size = renderBox.size;
    }
  });

  return size;
}
}

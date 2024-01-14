import 'package:flutter/material.dart';
import 'package:node_editor/src/nodes.dart';

import 'connections.dart';
import 'node_widget.dart';

class NodeEditorController with ChangeNotifier {
  final NodesManager nodesManager = NodesManager();
  final ConnectionsManager connectionsManager = ConnectionsManager();

  /// Store the start position of stack widget in the canvas.
  /// This position is used to calculate the position of the connections in
  /// the canvas
  Offset? stackPos;

  /// The current size of the stack widget
  /// It's available only after the first frame is rendered
  Size? currentScreenSize;

  /// ScrollController is set by the canvas, it is used by others class to
  /// control the scroll when the user move the nodes for a area outside the
  /// visible canvas
  late ScrollController horizontalScrollController;
  late ScrollController verticalScrollController;

  /// Listener that is used when the user select a connection
  void Function(Connection conn)? onSelectListener;

  List<Connection> get connections => connectionsManager.connections;

  Offset? get startPointConnection => connectionsManager.startPointConnection;

  Offset? get mousePoint => connectionsManager.mousePoint;

  ConnectionTheme? get outTheme => connectionsManager.outTheme;

  String? get outNodeName => connectionsManager.outNodeName;

  String? get outPortName => connectionsManager.outPortName;

  Map<String, NodeModel> get nodes => nodesManager.nodes;

  void addSelectListener(void Function(Connection conn)? fn) {
    onSelectListener = fn;
  }

  Size getMaxScreenSize() {
    double px = 0;
    double py = 0;
    for (var nodeName in nodesManager.nodes.keys) {
      Offset pos = nodesManager.nodes[nodeName]!.pos;
      Size size = nodesManager.getNodeWidgetSize(nodeName);
      px = pos.dx + size.width > px ? pos.dx + size.width : px;
      py = pos.dy + size.height > py ? pos.dy + size.height : py;
    }

    return Size(px, py);
  }

  notify() {
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> m = {};

    for (var entry in nodesManager.nodes.entries) {
      m[entry.key] = entry.value.toMap();
    }

    return m;
  }

  void addNode(NodePropWidget nodeWidget) {
    nodesManager.addNode(nodeWidget);
  }

  void addInPort(String nodeName, InPort inPortInfo) {
    nodesManager.addInPort(nodeName, inPortInfo);
  }

  bool isInputPortConnected(String nodeName, String portName) {
    return connectionsManager.isInputPortConnected(nodeName, portName);
  }

  void addConnectionByTap({required String inNode, required String inPort}) {
    connectionsManager.addConnectionByTap(nodesManager.nodes,
        inPort: inPort, inNode: inNode);
    notifyListeners();
  }

  void addOutPort(String nodeName, OutPort outPortInfo) {
    nodesManager.addOutPort(nodeName, outPortInfo);
  }

  bool isOutputPortConnected(String nodeName, String portName) {
    return connectionsManager.isOutputPortConnected(nodeName, portName);
  }

  void setConnecting(String nameNode, String namePort) {
    connectionsManager.setConnecting(
        this, nodesManager.nodes, nameNode, namePort);
    notifyListeners();
  }

  void moveNodePosition(String name, Offset delta) {
    nodesManager.moveNodePosition(name, delta);
    notifyListeners();
  }

  Port? getPort(String nodeName, String portName) {
    return nodesManager.getPort(nodeName, portName);
  }

  void addProperty(String nodeName, Property property) {
    nodesManager.addProperty(nodeName, property);
  }

  void selectOnTap(Offset tapPosition) {
    connectionsManager.selectOnTap(this, tapPosition);
    notifyListeners();
  }

  void mousePosition(Offset pos) {
    connectionsManager.mousePosition(pos);
    notifyListeners();
  }
}

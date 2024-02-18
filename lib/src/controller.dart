import 'package:flutter/material.dart';
import 'package:node_editor/src/nodes.dart';

import '../node_editor.dart';
import 'connections.dart';

///
/// This controller handle all information that is used by Node Editor Widget
/// The nodes, its ports and its properties is managed by this class
/// The screen information as canvas size is managed by this class too
class NodeEditorController with ChangeNotifier {
  /// Manager the nodes. The nodes represent the widgets node properties
  /// in the canvas.
  /// Every node and its properties is inside this manager
  /// Using nodesManager the user is able to insert and remove nodes, and its
  /// properties and ports
  final NodesManager nodesManager = NodesManager();

  /// Manager the connections between the ports.
  /// The connections between the ports of the widget nodes is stored in this
  /// manager
  /// Using this manager is possible to add, remover or search by connections
  /// between the ports of the nodes
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

  /// Focus node that request a focus when some node is tap or moved
  /// this attribute must be initialized in the init of the main widget
  /// node editor
  late FocusNode focusNode;

  set isShiftPressed(bool v) {
    connectionsManager.isShiftPressed = v;
    nodesManager.isShiftPressed = v;
  }

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

  void addNode(NodeWidgetBase nodeWidget, NodePosition position) {
    nodesManager.addNode(nodeWidget, position);
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
    focusNode.requestFocus();
    notifyListeners();
  }

  void unsetConnecting() {
    connectionsManager.unsetConnecting();
    notifyListeners();
  }

  void deleteSelectedConnections() {
    connectionsManager.removeSelected();
    notifyListeners();
  }

  void moveNodePosition(String name, Offset delta) {
    nodesManager.moveNodePosition(name, delta);
    focusNode.requestFocus();
    notifyListeners();
  }

  Port? getPort(String nodeName, String portName) {
    return nodesManager.getPort(nodeName, portName);
  }

  void addProperty(String nodeName, Property property) {
    nodesManager.addProperty(nodeName, property);
  }

  void selectOnTap(Offset tapPosition) {
    nodesManager.unselectAllNodes();
    connectionsManager.selectOnTap(this, tapPosition);
    focusNode.requestFocus();
    notifyListeners();
  }

  void selectNodeAction(String nodeName) {
    nodesManager.selectNodeAction(nodeName);
    notifyListeners();
  }

  void mousePosition(Offset pos) {
    connectionsManager.mousePosition(pos);
    notifyListeners();
  }
}

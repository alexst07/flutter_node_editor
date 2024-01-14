import 'package:flutter/material.dart';

import 'controller.dart';
import 'nodes.dart';

Size getObjectSize(GlobalKey key) {
  final RenderBox renderBox =
      key.currentContext?.findRenderObject() as RenderBox;
  return renderBox.size;
}

/// get the position of object in the screen, correcting by the position of
/// vertical and horizontal scroll
Offset getObjectPosition(NodeEditorController controller, GlobalKey key) {
  var obj = key.currentContext?.findRenderObject();
  final RenderBox stackRenderBox = obj as RenderBox;

  // fix position by scroll position
  return stackRenderBox.localToGlobal(Offset.zero) -
      controller.stackPos! +
      Offset(controller.horizontalScrollController.offset,
          controller.verticalScrollController.offset);
}

Offset? getPortPosition(
    NodeEditorController controller, String nodeName, String portName) {
  Port? port = controller.getPort(nodeName, portName);

  if (port == null) {
    return null;
  }

  if (port is InPort) {
    Offset? pos = getObjectPosition(controller, port.globalKey);
    Size iconSize = getObjectSize(port.globalKey);

    return Offset(
        pos.dx + iconSize.width * 3 / 4, pos.dy + iconSize.height / 2);
  } else if (port is OutPort) {
    Offset? pos = getObjectPosition(controller, port.globalKey);
    Size iconSize = getObjectSize(port.globalKey);

    return Offset(
        pos.dx + iconSize.width * 3 / 4, pos.dy + iconSize.height / 2);
  } else {
    throw Exception('Port type not valid');
  }
}

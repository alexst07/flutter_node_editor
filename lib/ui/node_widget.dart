import 'package:flutter/material.dart';

import 'controller.dart';
import 'inherit.dart';
import 'nodes.dart';

abstract class NodeItemWidgetInterface {
  NodeItem get nodeInfo;
}

class NodeWidgetAtt {
  bool selected = false;
}

/// Base class to create NodeWidgets
abstract class NodeWidgetBase {
  NodeWidgetBase(
      {required this.width, required this.name, required this.typeName});

  final String name;
  final String typeName;
  final double width;

  @protected
  final NodeWidgetAtt att = NodeWidgetAtt();

  Widget customBuild(BuildContext context);

  /// Flag to specify if the node is selected
  bool get isSelected => att.selected;

  /// Mark node as selected
  ///
  /// The node must be marked as selected on the controller
  /// so the controller is called, and the name of the node is given
  /// as argument, so the controller mark the node as selected
  void selectNode(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    controller.selectNodeAction(name);
  }
}

class NodeEditorInheritedWidget extends InheritedWidget {
  NodeEditorInheritedWidget({
    super.key,
    required this.blueprintNode,
  }) : super(
            child: NodeWidget(
              blueprintNode: blueprintNode,
            ));

  final NodeWidgetBase blueprintNode;

  static NodeEditorInheritedWidget of(BuildContext context) {
    final NodeEditorInheritedWidget? result =
        context.dependOnInheritedWidgetOfExactType<NodeEditorInheritedWidget>();
    assert(result != null, 'No NodeEditorInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(NodeEditorInheritedWidget oldWidget) {
    return blueprintNode != oldWidget.blueprintNode;
  }
}

class NodeWidget extends StatelessWidget {
  const NodeWidget({super.key, required this.blueprintNode});

  final NodeWidgetBase blueprintNode;

  @override
  Widget build(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        // check if the node is selected
        blueprintNode.att.selected =
            controller.nodesManager.nodes[blueprintNode.name]?.selected ??
                false;
        return blueprintNode.customBuild(context);
      },
    );
  }
}

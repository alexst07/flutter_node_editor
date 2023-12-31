import 'package:flutter/material.dart';

import 'controller.dart';
import 'inherit.dart';

abstract class NodeItemWidgetInterface {
  NodeItem get nodeInfo;
}

abstract class NodePropWidget {
  const NodePropWidget(
      {this.icon,
      this.title,
      this.arrow,
      this.initPosition = const Offset(10, 10),
      required this.name,
      required this.typeName,
      required this.child});

  final Offset initPosition;
  final String name;
  final String typeName;
  final Widget? icon;
  final Widget? title;
  final Widget? arrow;
  final Widget child;

  Widget customBuild(BuildContext context);
}

class BlueprintNodeInheritedWidget extends InheritedWidget {
  BlueprintNodeInheritedWidget({
    Key? key,
    required this.blueprintNode,
  }) : super(
            key: key,
            child: NodeWidget(
              blueprintNode: blueprintNode,
            ));

  final NodePropWidget blueprintNode;

  static BlueprintNodeInheritedWidget of(BuildContext context) {
    final BlueprintNodeInheritedWidget? result = context
        .dependOnInheritedWidgetOfExactType<BlueprintNodeInheritedWidget>();
    assert(result != null, 'No BlueprintNodeInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(BlueprintNodeInheritedWidget oldWidget) {
    return blueprintNode != oldWidget.blueprintNode;
  }
}

class DefaultDarkNode extends NodePropWidget {
  const DefaultDarkNode(
      {super.icon,
      super.title,
      super.arrow,
      super.initPosition = const Offset(10, 10),
      this.width = 150,
      this.titleBarColor = Colors.black87,
      required super.name,
      required super.typeName,
      required super.child});

  final double width;
  final Color titleBarColor;

  @override
  Widget customBuild(BuildContext context) {
    BlueprintController controller =
        ControllerInheritedWidget.of(context).controller;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.7), // Container color
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), // Shadow color
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              controller.moveNodePosition(name, details.delta);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54, // Container color
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        icon ?? SizedBox(),
                        DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                          child: title ?? Text(''),
                        )
                      ],
                    ),
                  ),
                  arrow ?? Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
          DefaultTextStyle(
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class NodeWidget extends StatelessWidget {
  const NodeWidget({Key? key, required this.blueprintNode}) : super(key: key);

  final NodePropWidget blueprintNode;

  @override
  Widget build(BuildContext context) {
    return blueprintNode.customBuild(context);
  }
}

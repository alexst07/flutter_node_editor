import 'package:flutter/material.dart';

import 'controller.dart';
import 'inherit.dart';
import 'nodes.dart';
import 'position.dart';

abstract class NodeItemWidgetInterface {
  NodeItem get nodeInfo;
}

abstract class NodePropWidget {
  const NodePropWidget(
      {required this.width,
      this.initPosition = NodePosition.startScreen,
      required this.name,
      required this.typeName,
      required this.child});

  final NodePosition initPosition;
  final String name;
  final String typeName;
  final Widget child;
  final double width;

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

class DefaultNode extends NodePropWidget {
  const DefaultNode(
      {required this.icon,
      required this.title,
      super.initPosition = NodePosition.startScreen,
      super.width = 150,
      this.titleBarColor,
      this.backgroundColor,
      this.boxShadow,
      this.radius,
      this.border,
      this.gradient,
      this.backgroundBlendMode,
      this.image,
      this.titleBarBorder,
      this.titleBarGradient,
      this.titleBarBackgroundBlendMode,
      this.titleBarImage,
      this.iconTileSpacing,
      required super.name,
      required super.typeName,
      required super.child});

  final Color? titleBarColor;
  final Color? backgroundColor;
  final double? radius;
  final Widget icon;
  final Widget title;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final DecorationImage? image;
  final BoxBorder? titleBarBorder;
  final Gradient? titleBarGradient;
  final BlendMode? titleBarBackgroundBlendMode;
  final DecorationImage? titleBarImage;
  final double? iconTileSpacing;

  @override
  Widget customBuild(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor, // Container color
        border: border,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        image: image,
        borderRadius: BorderRadius.circular(radius ?? 0), // Rounded corners
        boxShadow: boxShadow,
      ),
      child: Column(
        children: [
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              controller.moveNodePosition(name, details.delta);
            },
            child: Container(
              decoration: BoxDecoration(
                color: titleBarColor, // Container color
                border: titleBarBorder,
                image: titleBarImage,
                backgroundBlendMode: titleBarBackgroundBlendMode,
                gradient: titleBarGradient,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius ?? 0),
                    topRight: Radius.circular(radius ?? 0)), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        icon,
                        SizedBox(
                          width: iconTileSpacing,
                        ),
                        DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                          child: title,
                        )
                      ],
                    ),
                  ),
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

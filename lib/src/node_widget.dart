import 'package:flutter/material.dart';

import 'controller.dart';
import 'inherit.dart';
import 'nodes.dart';
import 'port.dart';

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
    Key? key,
    required this.blueprintNode,
  }) : super(
            key: key,
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

class TitleBarNodeWidget extends NodeWidgetBase {
  TitleBarNodeWidget(
      {required this.icon,
      required this.title,
      super.width = 150,
      this.titleBarColor,
      this.backgroundColor,
      this.boxShadow,
      this.radius,
      this.border,
      this.selectedBorder,
      this.gradient,
      this.backgroundBlendMode,
      this.image,
      this.titleBarBorder,
      this.titleBarGradient,
      this.titleBarBackgroundBlendMode,
      this.titleBarImage,
      this.iconTileSpacing,
      this.titleBarPadding,
      required super.name,
      required super.typeName,
      required this.child});

  final Widget child;
  final Color? titleBarColor;
  final Color? backgroundColor;
  final double? radius;
  final Widget icon;
  final Widget title;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final BoxBorder? selectedBorder;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final DecorationImage? image;
  final BoxBorder? titleBarBorder;
  final Gradient? titleBarGradient;
  final BlendMode? titleBarBackgroundBlendMode;
  final DecorationImage? titleBarImage;
  final double? iconTileSpacing;
  final EdgeInsetsGeometry? titleBarPadding;

  @override
  Widget customBuild(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor, // Container color
        border: isSelected ? selectedBorder : border,
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
              child: Padding(
                padding: titleBarPadding ?? const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              selectNode(context);
                            },
                            child: icon,
                          ),
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

class ContainerNodeWidget extends NodeWidgetBase {
  ContainerNodeWidget(
      {required this.icon,
      super.width = 150,
      this.backgroundColor,
      this.boxShadow,
      this.radius,
      this.border,
      this.selectedBorder,
      this.gradient,
      this.backgroundBlendMode,
      this.image,
      required super.name,
      required super.typeName,
      required this.child});

  final Widget child;
  final Color? backgroundColor;
  final double? radius;
  final Widget icon;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final BoxBorder? selectedBorder;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final DecorationImage? image;

  @override
  Widget customBuild(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor, // Container color
        border: isSelected ? selectedBorder : border,
        gradient: gradient,
        backgroundBlendMode: backgroundBlendMode,
        image: image,
        borderRadius: BorderRadius.circular(radius ?? 0), // Rounded corners
        boxShadow: boxShadow,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 0.8),
        ),
        child: child,
      ),
    );
  }
}

class UnaryOperationNode extends NodeWidgetBase {
  UnaryOperationNode(
      {super.width = 150,
      this.backgroundColor,
      this.boxShadow,
      this.radius,
      this.border,
      this.gradient,
      this.backgroundBlendMode,
      this.image,
      required this.inputPort,
      required this.outputPort,
      required this.label,
      required super.name,
      required super.typeName});

  final Color? backgroundColor;
  final double? radius;
  final Widget label;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final DecorationImage? image;
  final InPortWidget inputPort;
  final OutPortWidget outputPort;

  @override
  Widget customBuild(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        controller.moveNodePosition(name, details.delta);
      },
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            inputPort,
            label,
            outputPort,
          ],
        ),
      ),
    );
  }
}

class BinaryOperationNode extends NodeWidgetBase {
  BinaryOperationNode(
      {super.width = 150,
      this.backgroundColor,
      this.boxShadow,
      this.radius,
      this.border,
      this.gradient,
      this.backgroundBlendMode,
      this.image,
      required this.inputPort1,
      required this.inputPort2,
      required this.outputPort,
      required this.label,
      required super.name,
      required super.typeName});

  final Color? backgroundColor;
  final double? radius;
  final Widget label;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final DecorationImage? image;
  final InPortWidget inputPort1;
  final InPortWidget inputPort2;
  final OutPortWidget outputPort;

  @override
  Widget customBuild(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        controller.moveNodePosition(name, details.delta);
      },
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [inputPort1, inputPort2],
            ),
            label,
            outputPort,
          ],
        ),
      ),
    );
  }
}

class NodeWidget extends StatelessWidget {
  const NodeWidget({Key? key, required this.blueprintNode}) : super(key: key);

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

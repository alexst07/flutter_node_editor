import 'package:flutter/material.dart';

import 'connections.dart';
import 'controller.dart';
import 'inherit.dart';
import 'node_widget.dart';
import 'nodes.dart';

abstract class PropertyWidgetInterface extends NodeItemWidgetInterface
    implements Widget {}

class InPortWidget extends StatefulWidget {
  const InPortWidget({
    super.key,
    required this.multiConnections,
    this.maxConnections,
    required this.name,
    required this.icon,
    this.connectionTheme,
    this.onConnect,
    this.iconConnected,
    this.optional = false,
  });

  final bool multiConnections;
  final bool? optional;
  final int? maxConnections;
  final String name;
  final Widget icon;
  final Widget? iconConnected;
  final ConnectionTheme? connectionTheme;
  final bool Function(String, String)? onConnect;

  @override
  State<InPortWidget> createState() => _InPortWidgetState();
}

class _InPortWidgetState extends State<InPortWidget> {
  final GlobalKey globalKey = GlobalKey();
  late final InPort inPortInfo;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inPortInfo = InPort(
          name: widget.name,
          globalKey: globalKey,
          maxConnections: widget.maxConnections,
          multiConnections: widget.multiConnections,
          optional: widget.optional ?? false,
          onConnect: widget.onConnect,
          connectionTheme: widget.connectionTheme ??
              ConnectionTheme(
                color: Colors.blue,
                strokeWidth: 1,
              ),
          inputIcon: widget.icon);
      NodeEditorController controller =
          ControllerInheritedWidget.of(context).controller;
      NodeEditorInheritedWidget node = NodeEditorInheritedWidget.of(context);
      controller.addInPort(node.blueprintNode.name, inPortInfo);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    NodeEditorInheritedWidget node = NodeEditorInheritedWidget.of(context);
    String nodeName = node.blueprintNode.name;

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        bool connected = controller.isInputPortConnected(nodeName, widget.name);
        return InkWell(
          onTap: () {
            NodeEditorController controller =
                ControllerInheritedWidget.of(context).controller;
            NodeEditorInheritedWidget node =
                NodeEditorInheritedWidget.of(context);
            controller.addConnectionByTap(
                inNode: node.blueprintNode.name, inPort: widget.name);
          },
          child: SizedBox(
            key: globalKey,
            child:
                connected ? widget.iconConnected ?? widget.icon : widget.icon,
          ),
        );
      },
    );
  }
}

class OutPortWidget extends StatefulWidget {
  const OutPortWidget({
    super.key,
    required this.multiConnections,
    this.maxConnections,
    required this.name,
    required this.icon,
    this.connectionTheme,
    this.iconConnected,
  });

  final bool multiConnections;
  final int? maxConnections;
  final String name;
  final Widget icon;
  final Widget? iconConnected;
  final ConnectionTheme? connectionTheme;

  @override
  State<OutPortWidget> createState() => _OutPortWidgetState();
}

class _OutPortWidgetState extends State<OutPortWidget> {
  final GlobalKey globalKey = GlobalKey();
  late final OutPort outPortInfo;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      outPortInfo = OutPort(
          name: widget.name,
          globalKey: globalKey,
          maxConnections: widget.maxConnections,
          multiConnections: widget.multiConnections,
          connectionTheme: widget.connectionTheme ??
              ConnectionTheme(
                color: Colors.blue,
                strokeWidth: 1,
              ),
          outputIcon: widget.icon);
      NodeEditorController controller =
          ControllerInheritedWidget.of(context).controller;
      NodeEditorInheritedWidget node = NodeEditorInheritedWidget.of(context);
      controller.addOutPort(node.blueprintNode.name, outPortInfo);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    NodeEditorInheritedWidget node = NodeEditorInheritedWidget.of(context);
    String nodeName = node.blueprintNode.name;

    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        bool connected =
            controller.isOutputPortConnected(nodeName, widget.name);

        return InkWell(
          onTap: () {
            NodeEditorController controller =
                ControllerInheritedWidget.of(context).controller;
            NodeEditorInheritedWidget node =
                NodeEditorInheritedWidget.of(context);
            controller.setConnecting(node.blueprintNode.name, widget.name);
          },
          child: SizedBox(
            key: globalKey,
            child:
                connected ? widget.iconConnected ?? widget.icon : widget.icon,
          ),
        );
      },
    );
  }
}

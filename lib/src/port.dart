import 'package:flutter/material.dart';

import 'controller.dart';
import 'inherit.dart';
import 'node_widget.dart';

abstract class PropertyWidgetInterface extends NodeItemWidgetInterface
    implements Widget {}

class InPortWidget extends StatefulWidget {
  const InPortWidget(
      {Key? key,
      required this.multiConnections,
      this.maxConnections,
      required this.name,
      required this.icon,
      this.connectionTheme,
      this.onConnect,
      this.iconConnected})
      : super(key: key);

  final bool multiConnections;
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
          onConnect: widget.onConnect,
          connectionTheme: widget.connectionTheme ??
              ConnectionTheme(
                color: Colors.blue,
                strokeWidth: 1,
              ),
          inputIcon: widget.icon);
      NodeEditorController controller =
          ControllerInheritedWidget.of(context).controller;
      BlueprintNodeInheritedWidget node =
          BlueprintNodeInheritedWidget.of(context);
      controller.addInPort(node.blueprintNode.name, inPortInfo);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    BlueprintNodeInheritedWidget node =
        BlueprintNodeInheritedWidget.of(context);
    String nodeName = node.blueprintNode.name;
    bool connected = controller.isInputPortConnected(nodeName, widget.name);
    return InkWell(
      onTap: () {
        NodeEditorController controller =
            ControllerInheritedWidget.of(context).controller;
        BlueprintNodeInheritedWidget node =
            BlueprintNodeInheritedWidget.of(context);
        controller.addConnectionByTap(
            inNode: node.blueprintNode.name, inPort: widget.name);
      },
      child: SizedBox(
        key: globalKey,
        child: connected ? widget.iconConnected ?? widget.icon : widget.icon,
      ),
    );
  }
}

class OutPortWidget extends StatefulWidget {
  const OutPortWidget(
      {Key? key,
      required this.multiConnections,
      this.maxConnections,
      required this.name,
      required this.icon,
      this.connectionTheme,
      this.iconConnected})
      : super(key: key);

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
      BlueprintNodeInheritedWidget node =
          BlueprintNodeInheritedWidget.of(context);
      controller.addOutPort(node.blueprintNode.name, outPortInfo);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NodeEditorController controller =
        ControllerInheritedWidget.of(context).controller;
    BlueprintNodeInheritedWidget node =
        BlueprintNodeInheritedWidget.of(context);
    String nodeName = node.blueprintNode.name;
    bool connected = controller.isOutputPortConnected(nodeName, widget.name);
    return InkWell(
      onTap: () {
        NodeEditorController controller =
            ControllerInheritedWidget.of(context).controller;
        BlueprintNodeInheritedWidget node =
            BlueprintNodeInheritedWidget.of(context);
        controller.setConnecting(node.blueprintNode.name, widget.name);
      },
      child: SizedBox(
        key: globalKey,
        child: connected ? widget.iconConnected ?? widget.icon : widget.icon,
      ),
    );
  }
}

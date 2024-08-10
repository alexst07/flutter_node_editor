import 'package:flutter/material.dart';

import 'controller.dart';
import 'inherit.dart';
import 'node_widget.dart';
import 'nodes.dart';

mixin PropertyMixin<T> {
  late Property property;
  late String nodeName;
  late NodeEditorController controller;

  void registerProperty(BuildContext context, String name, T defaultValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      property = Property(name: name, value: defaultValue);
      controller = ControllerInheritedWidget.of(context).controller;
      NodeEditorInheritedWidget node = NodeEditorInheritedWidget.of(context);
      nodeName = node.blueprintNode.name;
      controller.addProperty(nodeName, property);
    });
  }

  void setPropertyValue(T value) {
    property.value = value;
    controller.addProperty(nodeName, property);
  }
}

import 'package:flutter/material.dart';

import 'controller.dart';
import 'inherit.dart';
import 'node_widget.dart';

mixin PropertyMixin {
  late Property property;
  late String nodeName;
  late NodeEditorController controller;

  void registerProperty(
      BuildContext context, String name, dynamic defaultValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      property = Property(name: name, value: defaultValue);
      controller = ControllerInheritedWidget.of(context).controller;
      BlueprintNodeInheritedWidget node =
          BlueprintNodeInheritedWidget.of(context);
      nodeName = node.blueprintNode.name;
      controller.addProperty(nodeName, property);
    });
  }

  void setPropertyValue(dynamic value) {
    property.value = value;
    controller.addProperty(nodeName, property);
  }
}

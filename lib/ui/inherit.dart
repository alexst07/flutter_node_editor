import 'package:flutter/material.dart';

import 'controller.dart';

class ControllerInheritedWidget extends InheritedWidget {
  final NodeEditorController controller;

  const ControllerInheritedWidget({
    super.key,
    required this.controller,
    required super.child,
  });

  static ControllerInheritedWidget of(BuildContext context) {
    final ControllerInheritedWidget? result =
        context.dependOnInheritedWidgetOfExactType<ControllerInheritedWidget>();
    assert(result != null, 'No ColorInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ControllerInheritedWidget oldWidget) {
    return controller != oldWidget.controller;
  }
}

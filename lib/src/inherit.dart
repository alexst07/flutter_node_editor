import 'package:flutter/material.dart';

import 'controller.dart';

class ControllerInheritedWidget extends InheritedWidget {
  final NodeEditorController controller;

  const ControllerInheritedWidget({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

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

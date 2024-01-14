import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:node_editor/node_editor.dart';

import 'inherit.dart';
import 'line_painter.dart';

class NodeEditor extends StatefulWidget {
  const NodeEditor(
      {Key? key, required this.controller, required this.background})
      : super(key: key);

  final NodeEditorController controller;
  final NodeEditorBackgroundBase background;

  @override
  State<NodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends State<NodeEditor> {
  GlobalKey stackKey = GlobalKey();
  bool afterBuild = false;
  ScrollController horizontalScrollController = ScrollController();
  ScrollController verticalScrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var obj = stackKey.currentContext?.findRenderObject();
      if (obj == null) {
        debugPrint('exit null');
        return;
      }
      final RenderBox stackRenderBox = obj as RenderBox;
      final stackPosition = stackRenderBox.localToGlobal(Offset.zero);
      widget.controller.stackPos = stackPosition;
      debugPrint('Set stackPos');
      afterBuild = true;
      widget.controller.verticalScrollController = verticalScrollController;
      widget.controller.horizontalScrollController = horizontalScrollController;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        widget.controller.mousePosition(event.localPosition);
      },
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          debugPrint("onTapDown");
          widget.controller.selectOnTap(details.localPosition);
        },
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (BuildContext context, Widget? child) {
            return ControllerInheritedWidget(
              controller: widget.controller,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // get the required size of the stack
                  Size stackSize = Size.zero;
                  if (afterBuild) {
                    stackSize = widget.controller.getMaxScreenSize();
                  }

                  widget.controller.currentScreenSize =
                      Size(constraints.maxWidth, constraints.maxHeight);

                  final stackWidth = stackSize.width;
                  final stackHeight = stackSize.height;

                  return SingleChildScrollView(
                    controller: horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          minHeight: constraints.maxHeight,
                          maxWidth: max(constraints.maxWidth, stackWidth),
                          maxHeight: max(constraints.maxHeight, stackHeight),
                        ),
                        child: CustomPaint(
                          painter: LinePainter(
                            context: context,
                            controller: widget.controller,
                            background: widget.background,
                          ),
                          child: Stack(
                            key: stackKey,
                            children: widget.controller.nodes.values
                                .map(
                                  (e) => Positioned(
                                    left: e.pos.dx,
                                    top: e.pos.dy,
                                    child: e.inheritedWidget,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

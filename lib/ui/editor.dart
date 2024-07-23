import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'background.dart';
import 'controller.dart';
import 'inherit.dart';
import 'line_painter.dart';

class NodeEditor extends StatefulWidget {
  const NodeEditor(
      {super.key,
      required this.controller,
      required this.background,
      required this.focusNode,
      required this.infiniteCanvasSize});

  final NodeEditorController controller;
  final NodeEditorBackgroundBase background;
  final FocusNode focusNode;
  final double infiniteCanvasSize;

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

      // Get the global position of stack widget
      // This is used to calculate the relative position in the canvas
      final RenderBox stackRenderBox = obj as RenderBox;
      final stackPosition = stackRenderBox.localToGlobal(Offset.zero);

      // set the stack widget position in the controller
      widget.controller.stackPos = stackPosition;

      // set the focus in the controller
      widget.controller.focusNode = widget.focusNode;

      // debugPrint('Set stackPos');
      afterBuild = true;
      widget.controller.verticalScrollController = verticalScrollController;
      widget.controller.horizontalScrollController = horizontalScrollController;
    });

    horizontalScrollController.addListener(_onScroll);
    verticalScrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    horizontalScrollController.removeListener(_onScroll);
    verticalScrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    widget.controller.updateViewportOffset(Offset(
        horizontalScrollController.offset, verticalScrollController.offset));
    setState(() {
      // Redraw the canvas on scroll
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      onKey: (FocusNode node, RawKeyEvent event) {
        _onKey(event);
        return KeyEventResult.ignored; // Let event propagate
      },
      child: MouseRegion(
        onHover: (PointerHoverEvent event) {
          Offset adjustedPosition = event.localPosition +
              Offset(horizontalScrollController.offset,
                  verticalScrollController.offset);
          widget.controller.mousePosition(adjustedPosition);
        },
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            // debugPrint("onTapDown");
            widget.controller.selectOnTap(details.localPosition);
          },
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (BuildContext context, Widget? child) {
              return ControllerInheritedWidget(
                controller: widget.controller,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    widget.controller.currentScreenSize =
                        Size(constraints.maxWidth, constraints.maxHeight);
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        controller: verticalScrollController,
                        scrollDirection: Axis.vertical,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                            minHeight: constraints.maxHeight,
                            maxWidth: widget.infiniteCanvasSize,
                            maxHeight: widget.infiniteCanvasSize,
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
      ),
    );
  }

  void _onKey(RawKeyEvent event) {
    bool isShift = event.logicalKey == LogicalKeyboardKey.shiftLeft ||
        event.logicalKey == LogicalKeyboardKey.shiftRight;

    if (isShift) {
      widget.controller.isShiftPressed = event is RawKeyDownEvent;
    }

    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      widget.controller.unsetConnecting();
    }

    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.delete) {
      widget.controller.deleteSelectedNodes();
      widget.controller.deleteSelectedConnections();
    }
  }
}

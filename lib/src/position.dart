import 'dart:ui';

enum NodePositionType {
  custom,
  startScreen,
  centerScreen,
  afterLast,
}

class NodePosition {
  final Offset? position;
  final NodePositionType type;

  const NodePosition.custom(Offset pos)
      : position = pos,
        type = NodePositionType.custom;

  const NodePosition._set(NodePositionType typePos)
      : position = null,
        type = typePos;

  static const NodePosition startScreen =
      NodePosition._set(NodePositionType.startScreen);

  static const NodePosition centerScreen =
      NodePosition._set(NodePositionType.centerScreen);

  static const NodePosition afterLast =
      NodePosition._set(NodePositionType.afterLast);
}

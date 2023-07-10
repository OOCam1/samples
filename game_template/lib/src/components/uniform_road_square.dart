

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:game_template/src/components/road_square.dart';

class UniformRoadSquare extends RoadSquare {


  late final PositionComponent _base;
  static const Color _baseColor = Color.fromRGBO(24, 52, 82, 1.0);
  @override
  Future<void> onLoad() async {
    add(_base);
  }
  // @override
  // Anchor get anchor => Anchor.center;

  UniformRoadSquare(double gridSquareHorizontalSize, double gridSquareVerticalSize, Vector2 position, int priority) {
    this.position = position;
    this.priority = priority;
    anchor = Anchor.center;
    size = Vector2(2*gridSquareHorizontalSize, 2*gridSquareVerticalSize);
    var relation = [
      Vector2(0, 1),
      Vector2(1, 0),
      Vector2(0, -1),
      Vector2(-1, 0)
    ];
    var basePaint = Paint();
    basePaint.color = _baseColor;
    _base = PolygonComponent.relative(relation, parentSize: size, paint: basePaint);
  }

}
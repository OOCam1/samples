


import 'dart:ui';

import 'package:flame/components.dart';

class UniformGridSquare extends PositionComponent {
  late List<Vector2> _relation;
  late Paint paint;



  @override
  Future<void> onLoad() async {
    add(PolygonComponent.relative(_relation, parentSize: size, paint: paint));
  }

  UniformGridSquare(Vector2 position, Color color, double gridHorizontalSize, double gridVerticalSize) {
    this.position = position;
    size = Vector2(2*gridHorizontalSize,2*gridVerticalSize);
    anchor = Anchor.center;
    _relation = [
      Vector2(0, 1),
      Vector2(1, 0),
      Vector2(0, -1),
      Vector2(-1, 0)
    ];
    paint = Paint();
    paint.color = color;

  }
}


import 'dart:ui';
import 'package:flame/components.dart';
import 'uniform_grid_square.dart';

class BuildingBaseSquare extends PositionComponent {

  late final PositionComponent _base;
  static const Color _baseColor = Color.fromRGBO(51, 55, 61, 1.0);
  @override
  Future<void> onLoad() async {
    add(_base);
  }


  BuildingBaseSquare(double gridSquareHorizontalSize, double gridSquareVerticalSize, Vector2 position, int priority) {
    this.position = position;
    this.priority = priority;
    anchor = Anchor.center;
    size = Vector2(2*gridSquareHorizontalSize, 2*gridSquareVerticalSize);
    _base = UniformGridSquare(Vector2(width/2, height/2), _baseColor, gridSquareHorizontalSize, gridSquareVerticalSize);
  }
}
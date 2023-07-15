
import 'dart:ui';

import 'package:flame/components.dart';

import 'uniform_grid_square.dart';

class BoundarySquare extends PositionComponent {

  late final PositionComponent _base;
  static const Color _baseColor = Color.fromRGBO(20, 112, 6, 1.0);
  @override
  Future<void> onLoad() async {
    add(_base);
  }
  // @override
  // Anchor get anchor => Anchor.center;

  BoundarySquare(double gridSquareHorizontalSize, double gridSquareVerticalSize, Vector2 position, int priority) {
    this.position = position;
    this.priority = priority;
    anchor = Anchor.center;
    size = Vector2(2*gridSquareHorizontalSize, 2*gridSquareVerticalSize);
    _base = UniformGridSquare(Vector2(width/2, height/2), _baseColor, gridSquareHorizontalSize, gridSquareVerticalSize);
  }
}
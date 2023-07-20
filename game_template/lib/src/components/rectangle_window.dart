import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';

import 'window.dart';

//window is centered on bottom inner corner
class RectangleWindow extends Window {
  bool _leftSideOfBuilding;
  double _yOffsetFromCenterVertexToOuterVertex;
  double _viewedHeight;
  Paint _paint = Paint();
  late List<Vector2> _vertices;

  @override
  Future<void> onLoad() async {
    add(PolygonComponent(_vertices, paint: _paint));
  }

  RectangleWindow(
    double width,
    Vector2 newPosition,
    this._viewedHeight,
    this._yOffsetFromCenterVertexToOuterVertex,
    this._leftSideOfBuilding,
    Color color,
  ) {
    var shapeHeight = _viewedHeight + _yOffsetFromCenterVertexToOuterVertex;
    size = Vector2(width, shapeHeight);
    anchor = (_leftSideOfBuilding) ? Anchor.bottomRight : Anchor.bottomLeft;
    position = newPosition;

    _paint.color = color;
    if (_leftSideOfBuilding) {
      _vertices = [
        Vector2(0, 0),
        Vector2(0, _viewedHeight),
        Vector2(width, height),
        Vector2(width, _yOffsetFromCenterVertexToOuterVertex)
      ];
      // for (int i = 0; i < 4; i++) {
      //   _vertices[i] += position - Vector2(width, height);
      // }
    } else {
      _vertices = [
        Vector2(0, _yOffsetFromCenterVertexToOuterVertex),
        Vector2(0, height),
        Vector2(width, _viewedHeight),
        Vector2(width, 0)
      ];
    }
  }
}

import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/components/roads/road_square.dart';

import '../../game_internals/position_and_height_states/grid_item.dart';
import '../uniform_grid_square.dart';

class BlockRoadSquare extends RoadSquare {
  static const _roadWidthToGridSideRatio = 0.4;
  static const _baseColor = Color.fromARGB(255, 66, 63, 63);
  static const _roadColor = Colors.indigo;

  final Set<List<Vector2>> _roadsToRender = HashSet();
  late UniformGridSquare _baseSquare;

  @override
  Future<void> onLoad() async {
    add(_baseSquare);
    var roadPaint = Paint();
    roadPaint.color = _roadColor;
    for (var vertexList in _roadsToRender) {
      add(PolygonComponent(vertexList, paint: roadPaint, priority: 1));
    }
  }

  BlockRoadSquare(double gridSquareHorizontalSize,
      double gridSquareVerticalSize, Vector2 position, GridItem roadType,
      {int priority = -1}) {
    size = Vector2(2 * gridSquareHorizontalSize, 2 * gridSquareVerticalSize);
    this.position = position;
    anchor = Anchor.center;
    this.priority = priority;

    _baseSquare = UniformGridSquare(Vector2(width / 2, height / 2), _baseColor,
        gridSquareHorizontalSize, gridSquareVerticalSize);

    double gapRatio = (1 - _roadWidthToGridSideRatio) / 2;
    double xOffsetFromEdgeToLeftmostVertex = width * gapRatio / 2;
    double roadWidth = width * _roadWidthToGridSideRatio / 2;
    double yOffsetFromTopToTopmostVertex = height * gapRatio / 2;
    double roadHeight = height * _roadWidthToGridSideRatio / 2;

    var horizontalRoadVertices = [
      Vector2(xOffsetFromEdgeToLeftmostVertex,
          height / 2 + yOffsetFromTopToTopmostVertex),
      Vector2(width / 2 - xOffsetFromEdgeToLeftmostVertex,
          height - yOffsetFromTopToTopmostVertex),
      Vector2(width - xOffsetFromEdgeToLeftmostVertex,
          height / 2 - yOffsetFromTopToTopmostVertex),
      Vector2(width / 2 + xOffsetFromEdgeToLeftmostVertex,
          yOffsetFromTopToTopmostVertex),
    ];
    List<Vector2> verticalRoadVertices = [
      Vector2(0, 0),
      Vector2(0, 0),
      Vector2(0, 0),
      Vector2(0, 0),
    ];
    if (roadType == GridItem.verticalRoad ||
        roadType == GridItem.intersectionRoad) {
      for (int i = 0; i < horizontalRoadVertices.length; i++) {
        var horizontalVerticesPosition = horizontalRoadVertices[i];
        var verticalDifferenceFromCenter =
            horizontalVerticesPosition.y - height / 2;
        var reflectedY =
            horizontalVerticesPosition.y - 2 * verticalDifferenceFromCenter;
        var newPosition = Vector2(horizontalVerticesPosition.x, reflectedY);
        verticalRoadVertices[horizontalRoadVertices.length - 1 - i] =
            newPosition;
      }
    }

    if (roadType == GridItem.horizontalRoad ||
        roadType == GridItem.intersectionRoad) {
      _roadsToRender.add(horizontalRoadVertices);
    }
    if (roadType == GridItem.verticalRoad ||
        roadType == GridItem.intersectionRoad) {
      _roadsToRender.add(verticalRoadVertices);
    }
  }
}

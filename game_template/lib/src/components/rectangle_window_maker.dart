import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/components/window.dart';
import 'package:game_template/src/components/window_maker_interface.dart';

import 'rectangle_window.dart';

class RectangleWindowMaker extends WindowMaker {
  final double _windowTrueHeightRatioToWidth;
  final double _horizontalGapBetweenWindowsRatioToWindowWidth;
  final double _windowWidthToBuildingWidth;
  double _verticalWindowOffsetFromCeilingRatioToWindowHeight;
  final int _windowsPerRow;
  final double _verticalGapBetweenRowsRatioToWindowHeight;
  final Color _color;

  factory RectangleWindowMaker(
      double windowTrueHeightRatioToWidth,
      double horizontalGapBetweenWindowsRatioToWindowWidth,
      int windowsPerRow,
      Color color,
      double windowWidthToBuildingWidth,
      double verticalWindowOffsetFromCeilingRatioToWindowHeight,
      double verticalGapBetweenRowsRatioToWindowHeight) {
    if (windowsPerRow * windowWidthToBuildingWidth +
            (windowsPerRow - 1) *
                horizontalGapBetweenWindowsRatioToWindowWidth >
        1) {
      throw Exception('not enough horizontal space to fit these windows');
    }
    return RectangleWindowMaker._internal(
        windowTrueHeightRatioToWidth,
        horizontalGapBetweenWindowsRatioToWindowWidth,
        windowsPerRow,
        color,
        windowWidthToBuildingWidth,
        verticalWindowOffsetFromCeilingRatioToWindowHeight,
        verticalGapBetweenRowsRatioToWindowHeight);
  }

  factory RectangleWindowMaker.twoSquareBlueWindowsPerRow() {
    return RectangleWindowMaker._internal(
        3, 0.5, 2, Colors.blueGrey, 1 / 4, 0.3, 1);
  }
  factory RectangleWindowMaker.threeTallBlackWindowsPerRow() {
    return RectangleWindowMaker._internal(
        5, 0.5, 3, Colors.black, 1 / 5, 0.3, 0.5);
  }
  RectangleWindowMaker._internal(
      this._windowTrueHeightRatioToWidth,
      this._horizontalGapBetweenWindowsRatioToWindowWidth,
      this._windowsPerRow,
      this._color,
      this._windowWidthToBuildingWidth,
      this._verticalWindowOffsetFromCeilingRatioToWindowHeight,
      this._verticalGapBetweenRowsRatioToWindowHeight);

  @override
  Set<Window> getWindows(double viewedHeight, double buildingHalfWidth) {
    var trueHeightOfBuilding = viewedHeight / cos(WindowMaker.angleOfView);
    var windowWidth = buildingHalfWidth * _windowWidthToBuildingWidth;
    var windowTrueHeight = _windowTrueHeightRatioToWidth * windowWidth;
    var verticalWindowOffsetFromFloor =
        windowTrueHeight * _verticalWindowOffsetFromCeilingRatioToWindowHeight;
    var verticalGapBetweenRows =
        windowTrueHeight * _verticalGapBetweenRowsRatioToWindowHeight;

    //just gotta trust me: do the maths yourself again if u want
    int numberOfRows = (trueHeightOfBuilding -
            2 * verticalWindowOffsetFromFloor +
            verticalGapBetweenRows) ~/
        (windowTrueHeight + verticalGapBetweenRows);

    var horizontalGapBetweenWindows =
        _horizontalGapBetweenWindowsRatioToWindowWidth * windowWidth;
    double widthOffset = (buildingHalfWidth -
            _windowsPerRow * windowWidth -
            (_windowsPerRow - 1) * horizontalGapBetweenWindows) /
        2;

    //must change to make bottom and top gap symmetrical after forcing numRows to be integer
    _verticalWindowOffsetFromCeilingRatioToWindowHeight =
        (-numberOfRows * (windowTrueHeight + verticalGapBetweenRows) +
                trueHeightOfBuilding +
                verticalGapBetweenRows) /
            (2 * windowTrueHeight);
    var windowViewedHeight = windowTrueHeight * cos(WindowMaker.angleOfView);
    var windowYOffsetFromCenterVertexToOuterVertex =
        windowWidth * sin(WindowMaker.angleOfView);

    HashSet<Window> output = HashSet();
    for (int row = 0; row < numberOfRows; row++) {
      for (int column = 0; column < _windowsPerRow; column++) {
        Vector2 leftBottomPosition =
            _getLeftSideWindowInnerBottomVertexPosition(
                row, column, windowWidth, widthOffset, buildingHalfWidth);
        double rightBottomX = 2 * buildingHalfWidth - leftBottomPosition.x;
        Vector2 rightBottomPosition =
            Vector2(rightBottomX, leftBottomPosition.y);
        var leftWindow = RectangleWindow(
            windowWidth,
            leftBottomPosition,
            windowViewedHeight,
            windowYOffsetFromCenterVertexToOuterVertex,
            true,
            _color);
        var rightWindow = RectangleWindow(
            windowWidth,
            rightBottomPosition,
            windowViewedHeight,
            windowYOffsetFromCenterVertexToOuterVertex,
            false,
            _color);
        output.add(leftWindow);
        output.add(rightWindow);
      }
    }
    return output;
  }

  ///gives you viewed inner bottom vertex position of a window on left side of building given its row and column number (starting from top and outer from 0)
  ///returns vertices in this
  Vector2 _getLeftSideWindowInnerBottomVertexPosition(int row, int column,
      double windowWidth, double widthOffset, double buildingHalfWidth) {
    var x = widthOffset +
        windowWidth * (column + 1) +
        _horizontalGapBetweenWindowsRatioToWindowWidth * windowWidth * (column);
    var windowTrueHeight = _windowTrueHeightRatioToWidth * windowWidth;
    var verticalOffsetFromTop =
        windowTrueHeight * _verticalWindowOffsetFromCeilingRatioToWindowHeight;
    var gapBetweenRows =
        windowTrueHeight * _verticalGapBetweenRowsRatioToWindowHeight;
    var trueY = verticalOffsetFromTop +
        windowTrueHeight * (row + 1) +
        gapBetweenRows * row;
    var viewedY = _convertTrueYPositionToViewedYPosition(
        x, trueY, buildingHalfWidth, false);
    return Vector2(x, viewedY);
  }

  ///takes in x y coordinates of a point and
  ///returns the view adjusted y position (x should be unchanged)
  double _convertTrueYPositionToViewedYPosition(
      double x, double y, double buildingHalfWidth, bool rightSideOfBuilding) {
    var verticalToHorizontalRatioOnGridSquare = sin(WindowMaker.angleOfView);
    var verticalOffsetOfTopCornerOfShapeToTopCornerOfBuilding =
        buildingHalfWidth * verticalToHorizontalRatioOnGridSquare;
    if (rightSideOfBuilding) {
      x = buildingHalfWidth - x;
    }
    var scaledY = x * verticalToHorizontalRatioOnGridSquare +
        y * cos(WindowMaker.angleOfView);
    return verticalOffsetOfTopCornerOfShapeToTopCornerOfBuilding + scaledY;
  }
}

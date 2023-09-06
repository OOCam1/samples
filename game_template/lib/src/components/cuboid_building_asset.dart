import 'dart:collection';


import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/components/building_asset.dart';
import 'package:game_template/src/components/rectangle_window_maker.dart';
import 'package:game_template/src/components/window_maker_interface.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';

import 'window.dart';

class CuboidBuildingAsset extends BuildingAsset {
  static final HashMap<ArtistGlobalInfo, CuboidBuildingAsset>
      _artistInfoToCuboidAsset = HashMap();

  @override
  int get priority => _priority;

  late final PolygonComponent _leftSide;
  late final int _priority;
  late final PolygonComponent _rightSide;
  late final PolygonComponent _top;
  late final PolygonComponent _leftOutline;
  late final PolygonComponent _rightOutline;
  late final PolygonComponent _topOutline;
  static const Color _outlineColor = Colors.black;
  late double _cuboidHeight;
  late final ArtistGlobalInfo _artistGlobalInfo;
  static const double _rightDarkerThanLeftPercentage = 0.6;
  late final double _horizontalDifferenceFromCenterToSideCorner;
  late final double _heightDifferenceFromCenterToSideCorner;
  late final Color _leftColor;
  late Set<Window> _windows;

  late WindowMaker _windowMaker;

  @override
  ArtistGlobalInfo get artistGlobalInfo => _artistGlobalInfo;

  @override
  set height(double value) {
    _cuboidHeight = value;
  }

  @override
  Future<void> onLoad() async {
    add(_leftSide);
    add(_rightSide);
    add(_top);
    add(_leftOutline);
    add(_rightOutline);
    add(_topOutline);
    await addAll(_windows);
  }

  CuboidBuildingAsset(
      Vector2 position,
      this._cuboidHeight,
      this._artistGlobalInfo,
      this._horizontalDifferenceFromCenterToSideCorner,
      this._heightDifferenceFromCenterToSideCorner,
      this._leftColor,
      this._priority) {
    //center of base
    this.position = position;
    var leftPaint = _getPaintFromColor(_leftColor);
    var rightPaint = _getPaintFromColor(
        _getDarkerColor(_rightDarkerThanLeftPercentage, _leftColor));

    //change later
    var topPaint = leftPaint;

    //entire height of shape including top edges - not height of cuboid
    size = Vector2(2 * _horizontalDifferenceFromCenterToSideCorner,
        2 * _heightDifferenceFromCenterToSideCorner + _cuboidHeight);
    double yComponent =
        (height - _heightDifferenceFromCenterToSideCorner) / height;
    anchor = Anchor(0.5, yComponent);

    var leftVertices = ([
      Vector2(0, _heightDifferenceFromCenterToSideCorner),
      Vector2(0, _heightDifferenceFromCenterToSideCorner + _cuboidHeight),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, height),
      Vector2(_horizontalDifferenceFromCenterToSideCorner,
          2 * _heightDifferenceFromCenterToSideCorner)
    ]);
    _leftSide = PolygonComponent(paint: leftPaint, leftVertices);

    var rightVertices = ([
      Vector2(_horizontalDifferenceFromCenterToSideCorner,
          2 * _heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, height),
      Vector2(width, height - _heightDifferenceFromCenterToSideCorner),
      Vector2(width, _heightDifferenceFromCenterToSideCorner),
    ]);
    _rightSide = PolygonComponent(rightVertices, paint: rightPaint);

    var topVertices = ([
      Vector2(0, _heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner,
          2 * _heightDifferenceFromCenterToSideCorner),
      Vector2(width, _heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 0)
    ]);

    _top = PolygonComponent(topVertices, paint: topPaint);

    var outlinePaint =
        _getPaintFromColor(_outlineColor, style: PaintingStyle.stroke);
    _leftOutline =
        PolygonComponent(leftVertices, paint: outlinePaint, priority: 1);
    _rightOutline =
        PolygonComponent(rightVertices, paint: outlinePaint, priority: 1);
    _topOutline =
        PolygonComponent(topVertices, paint: outlinePaint, priority: 1);
    // _windowMaker = (_cuboidHeight > 100)
    //     ? RectangleWindowMaker.twoSquareBlueWindowsPerRow()
    //     : RectangleWindowMaker.threeTallBlackWindowsPerRow();
    _windowMaker = RectangleWindowMaker.twoSquareBlueWindowsPerRow();
    _windows = _windowMaker.getWindows(_cuboidHeight, width / 2);
    for (var element in _windows) {
      element.priority = 2;
    }
  }

  Paint _getPaintFromColor(Color color,
      {PaintingStyle style = PaintingStyle.fill}) {
    var paint = Paint();
    paint.style = style;
    paint.color = color;
    return paint;
  }

  Color _getDarkerColor(double percentageDarker, Color color) {
    // return Color.fromRGBO((color.red*(1-percentageDarker)).toInt(),
    //     (color.green*(1-percentageDarker)).toInt(),
    //     (color.blue*(1-percentageDarker)).toInt(),
    //     color.opacity);

    //its pretty sexy if you just darken the red component and set the others
    //to 0

    // //mega sex
    //   return Color.fromRGBO(75,0,0,color.opacity);

    //this one darkens the red component, rather than producing a flat value:
    // gives black square if building is blue or green tho

    return Color.fromRGBO(
        (color.red * (1 - percentageDarker)).clamp(30, 70).toInt(),
        0,
        0,
        color.opacity);
  }
}

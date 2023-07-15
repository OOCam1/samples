


import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:game_template/src/components/building_asset.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';



class CuboidBuildingAsset extends BuildingAsset {

  static final HashMap<ArtistGlobalInfo, CuboidBuildingAsset> _artistInfoToCuboidAsset = HashMap();


  @override
  int get priority => _priority;

  late final PolygonComponent leftSide;
  late int _priority;
  late final PolygonComponent rightSide;
  late final PolygonComponent top;
  late double _cuboidHeight;
  late final ArtistGlobalInfo _artistGlobalInfo;
  static const double _rightDarkerThanLeftPercentage = 0.6;
  late double _horizontalDifferenceFromCenterToSideCorner;
  late double _heightDifferenceFromCenterToSideCorner;
  late Color _leftColor;


  @override
  ArtistGlobalInfo get artistGlobalInfo => _artistGlobalInfo;

    @override
  set height(double value) {
    _cuboidHeight = value;
  }

  @override
  Future<void> onLoad() async {
    add(leftSide);
    add(rightSide);
    add(top);
  }



  factory CuboidBuildingAsset(Vector2 position, double height, ArtistGlobalInfo artistGlobalInfo,
      double horizontalDifferenceFromCenterToSideCorner, double heightDifferenceFromCenterToSideCorner,
      Color color, int priority) {
      // if (_artistInfoToCuboidAsset.containsKey(artistGlobalInfo)) {
      //   return _artistInfoToCuboidAsset[artistGlobalInfo]!;
      // }
      var newBuilding = CuboidBuildingAsset._internal(position, height, artistGlobalInfo, horizontalDifferenceFromCenterToSideCorner,
        heightDifferenceFromCenterToSideCorner, color, priority);
      _artistInfoToCuboidAsset[artistGlobalInfo] = newBuilding;
      return newBuilding;
  }

  
  CuboidBuildingAsset._internal(Vector2 position, this._cuboidHeight, this._artistGlobalInfo, this._horizontalDifferenceFromCenterToSideCorner,
      this._heightDifferenceFromCenterToSideCorner, this._leftColor, this._priority ) {

    //center of base
    this.position = position;
    var leftPaint = _getPaintFromColor(_leftColor);
    var rightPaint = _getPaintFromColor(_getDarkerColor(_rightDarkerThanLeftPercentage, _leftColor));

    //change later
    var topPaint = leftPaint;

    //entire height of shape including top edges - not height of cuboid
    size = Vector2(2*_horizontalDifferenceFromCenterToSideCorner, 2*_heightDifferenceFromCenterToSideCorner + _cuboidHeight);
    double yComponent = (height-_heightDifferenceFromCenterToSideCorner)/height;
    anchor = Anchor(0.5, yComponent);


    var leftVertices = ([
      Vector2(0, _heightDifferenceFromCenterToSideCorner),
      Vector2(0, _heightDifferenceFromCenterToSideCorner + _cuboidHeight),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, height),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 2*_heightDifferenceFromCenterToSideCorner)
    ]);
    leftSide = PolygonComponent(paint:leftPaint, leftVertices);

    var rightVertices = ([
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 2*_heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, height),
      Vector2(width, height-_heightDifferenceFromCenterToSideCorner),
      Vector2(width, _heightDifferenceFromCenterToSideCorner),


    ]);
    rightSide = PolygonComponent(rightVertices, paint:rightPaint);

    var topVertices = ([
      Vector2(0, _heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 2*_heightDifferenceFromCenterToSideCorner),
      Vector2(width, _heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 0)

    ]);
    top = PolygonComponent(topVertices, paint: topPaint);
}


  Paint _getPaintFromColor(Color color) {
      var paint = Paint();
      paint.style = PaintingStyle.fill;
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

      return Color.fromRGBO((color.red*(1-percentageDarker)).clamp(30,70).toInt(),
          0, 0, color.opacity);

  }


}
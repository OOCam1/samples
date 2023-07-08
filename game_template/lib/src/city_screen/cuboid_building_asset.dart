


import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:game_template/src/city_screen/building_asset.dart';
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

  late double _horizontalDifferenceFromCenterToSideCorner;
  late double _heightDifferenceFromCenterToSideCorner;
  late Paint _paint;


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
      double horizontalDifferenceFromCenterToSideCorner, double heightDifferenceFromCenterToSideCorner, Paint paint, int priority) {
      // if (_artistInfoToCuboidAsset.containsKey(artistGlobalInfo)) {
      //   return _artistInfoToCuboidAsset[artistGlobalInfo]!;
      // }
      var newBuilding = CuboidBuildingAsset._internal(position, height, artistGlobalInfo, horizontalDifferenceFromCenterToSideCorner,
        heightDifferenceFromCenterToSideCorner, paint, priority);
      _artistInfoToCuboidAsset[artistGlobalInfo] = newBuilding;
      return newBuilding;
  }

  
  CuboidBuildingAsset._internal(Vector2 position, this._cuboidHeight, this._artistGlobalInfo, this._horizontalDifferenceFromCenterToSideCorner,
      this._heightDifferenceFromCenterToSideCorner, this._paint, this._priority ) {
    //bottom center corner - bottom corner that's closest to viewer
    this.position = position;

    //entire height of shape including top edges - not height of cuboid
    size = Vector2(2*_horizontalDifferenceFromCenterToSideCorner, 2*_heightDifferenceFromCenterToSideCorner + _cuboidHeight);
    anchor = Anchor.bottomCenter;


    var leftVertices = ([
      Vector2(0, _heightDifferenceFromCenterToSideCorner),
      Vector2(0, _heightDifferenceFromCenterToSideCorner + _cuboidHeight),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, height),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 2*_heightDifferenceFromCenterToSideCorner)
    ]);
    leftSide = PolygonComponent(paint:_paint, leftVertices);

    var rightVertices = ([
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 2*_heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, height),
      Vector2(width, height-_heightDifferenceFromCenterToSideCorner),
      Vector2(width, _heightDifferenceFromCenterToSideCorner),


    ]);
    rightSide = PolygonComponent(rightVertices, paint:_paint);

    var topVertices = ([
      Vector2(0, _heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 2*_heightDifferenceFromCenterToSideCorner),
      Vector2(width, _heightDifferenceFromCenterToSideCorner),
      Vector2(_horizontalDifferenceFromCenterToSideCorner, 0)

    ]);
    top = PolygonComponent(topVertices, paint: _paint);
}


}
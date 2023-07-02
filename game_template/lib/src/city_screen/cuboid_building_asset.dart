


import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:game_template/src/city_screen/building_asset.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';

import 'display_constants.dart';

class CuboidBuildingAsset extends BuildingAsset {

  static final HashMap<ArtistGlobalInfo, CuboidBuildingAsset> _artistInfoToCuboidAsset = HashMap();

    @override
  Anchor get anchor => Anchor.bottomCenter;
    @override
  // TODO: implement priority
  int get priority => _priority;

  late final PolygonComponent leftSide;
  late int _priority;
  late final PolygonComponent rightSide;
  late final PolygonComponent top;
  late double _height;
  late final ArtistGlobalInfo _artistGlobalInfo;

  late double _horizontalDifferenceFromCenterToSideCorner;
  late double _heightDifferenceFromCenterToSideCorner;
  late Paint _paint;


  @override
  ArtistGlobalInfo get artistGlobalInfo => _artistGlobalInfo;

    @override
  set height(double value) {
    _height = value;
  }

  @override
  Future<void> onLoad() async {
    add(leftSide);
    add(rightSide);
    add(top);
  }

  factory CuboidBuildingAsset(Vector2 position, double _height, ArtistGlobalInfo _artistGlobalInfo,
      double horizontalDifferenceFromCenterToSideCorner, double heightDifferenceFromCenterToSideCorner, Paint paint, int priority) {
      if (_artistInfoToCuboidAsset.containsKey(_artistGlobalInfo)) {
        return _artistInfoToCuboidAsset[_artistGlobalInfo]!;
      }
      var newBuilding = CuboidBuildingAsset._internal(position, _height, _artistGlobalInfo, horizontalDifferenceFromCenterToSideCorner,
        heightDifferenceFromCenterToSideCorner, paint, priority);
      _artistInfoToCuboidAsset[_artistGlobalInfo] = newBuilding;
      return newBuilding;
  }

  
  CuboidBuildingAsset._internal(Vector2 position, this._height, this._artistGlobalInfo, this._horizontalDifferenceFromCenterToSideCorner,
      this._heightDifferenceFromCenterToSideCorner, this._paint, this._priority ) {
    //bottom center corner - bottom corner that's closest to viewer
    this.position = position;
    var leftVertices = ([
      position,
      Vector2(position.x-_horizontalDifferenceFromCenterToSideCorner,
          position.y - _heightDifferenceFromCenterToSideCorner),
      Vector2(position.x-_horizontalDifferenceFromCenterToSideCorner,
          - _height + position.y - _heightDifferenceFromCenterToSideCorner),
      Vector2(position.x, position.y - _height)
    ]);
    leftSide = PolygonComponent(paint:_paint, leftVertices);

    var rightVertices = ([
      position,
      Vector2(position.x, position.y - _height),
      Vector2(position.x+ _horizontalDifferenceFromCenterToSideCorner,
          position.y - _height - _heightDifferenceFromCenterToSideCorner),
      Vector2(position.x + _horizontalDifferenceFromCenterToSideCorner,
          position.y - _heightDifferenceFromCenterToSideCorner)
    ]);
    rightSide = PolygonComponent(rightVertices, paint:_paint);

    var topVertices = ([
      Vector2(position.x, position.y - _height),
      Vector2(position.x - _horizontalDifferenceFromCenterToSideCorner,
          position.y - _height - _heightDifferenceFromCenterToSideCorner),
      Vector2(position.x, position.y - _height - 2*_heightDifferenceFromCenterToSideCorner),
      Vector2(position.x + _horizontalDifferenceFromCenterToSideCorner,
          position.y - _height - _heightDifferenceFromCenterToSideCorner)

    ]);
    top = PolygonComponent(topVertices, paint: _paint);
}


}
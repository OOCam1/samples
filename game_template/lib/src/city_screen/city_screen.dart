import 'dart:collection';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/city_screen/building_asset.dart';
import 'package:game_template/src/city_screen/cuboid_building_asset.dart';

import '../game_internals/models/artist_global_info.dart';
import '../game_internals/models/genre.dart';

class CityScreen extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //add(CuboidBuildingAsset(Vector2(100,200), 200));
    for (BuildingAsset asset in _buildingAssets) {
      add(asset);
    }

  }
  static final CityScreen _instance = CityScreen._internal();
  late double _gridSquareHorizontalSize;
  late double _viewedHeightToActualHeightRatio;
  final double _cameraRadiansFromHorizontal = 80 * pi/180;
  late double _gridSquareVerticalToHorizontalRatio;
  static const double _buildingSideToGridSquareSideRatio = 0.3;
  static const double _xMaxPixel = 300;
  static const double _yMaxPixel = 300;
  final Set<BuildingAsset> _buildingAssets = HashSet();
  //screen position of grid square closest to camera: we will say the camera is looking from the south west towards the origin
  final Vector2 _minCentrePosition = Vector2(_xMaxPixel/2, _yMaxPixel);
  //gridPosition of the square that will go at the minCentrePosition
  final Vector2 _gridPositionOfSouthWestCorner = Vector2(0,0);
  final Vector2 _gridPositionOfNorthEastCorner = Vector2(0,0);
  final Map<Genre, Paint> _genreToPaint = HashMap();

  factory CityScreen(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    _instance.addBuildings(artistPositions);
    return _instance;
  }
  CityScreen._internal() {
    _gridSquareVerticalToHorizontalRatio = sin(_cameraRadiansFromHorizontal);
    _viewedHeightToActualHeightRatio = cos(_cameraRadiansFromHorizontal);
  }


  //takes an argument of a map from ArtistGlobalInfo to a list containing (in order) x grid Position, y grid Position, height
  void addBuildings(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    _setExtremeGridPositions(artistPositions);
    int numOfSquaresOnGridAxes = max(_gridPositionOfNorthEastCorner.x - _gridPositionOfSouthWestCorner.x,
    _gridPositionOfNorthEastCorner.y - _gridPositionOfSouthWestCorner.y).toInt();
    _gridSquareHorizontalSize = min(100, _xMaxPixel/numOfSquaresOnGridAxes);
    for (var buildingPositionEntry in artistPositions.entries) {
      if (buildingPositionEntry.value.length != 3) {
        throw Exception("Map entry for building creation does not have length 3 - x, y, height");
      }
      var gridPosition = Vector2(buildingPositionEntry.value[0].toDouble(), buildingPositionEntry.value[1].toDouble());
      Vector2 position = _convertGridPositionToScreenPosition(gridPosition);

      int squareDistance = -pow(buildingPositionEntry.value[0]-_gridPositionOfSouthWestCorner.x, 2).toInt() -
          pow(buildingPositionEntry.value[1]-_gridPositionOfSouthWestCorner.y, 2).toInt();

      double height = buildingPositionEntry.value[2] * _viewedHeightToActualHeightRatio;
      //create new buildingAsset
      _buildingAssets.add(CuboidBuildingAsset(position,
          height,
          buildingPositionEntry.key,
        _gridSquareHorizontalSize*_buildingSideToGridSquareSideRatio,
          _gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio*_buildingSideToGridSquareSideRatio,
          _getArtistPaint(buildingPositionEntry.key),
      squareDistance));
    }

  }
  Paint _getArtistPaint(ArtistGlobalInfo artistGlobalInfo) {
    var genre = artistGlobalInfo.primaryGenre;
    if (_genreToPaint.containsKey(genre)) {
      return _genreToPaint[genre]!;
    }
    var random = Random();
    var redValue = random.nextInt(255);
    var greenValue = random.nextInt(255);
    var blueValue = random.nextInt(255);
    Paint newPaint = Paint();
    newPaint.color = Color.fromRGBO(redValue, greenValue, blueValue, 1);
    newPaint.style = PaintingStyle.fill;
    _genreToPaint[genre] = newPaint;
    return newPaint;
  }

  void _setExtremeGridPositions(Map<ArtistGlobalInfo, List<int>> buildingPositions) {
    for (MapEntry<ArtistGlobalInfo, List<int>> mapEntry in buildingPositions.entries) {
      if (mapEntry.value.length != 3) {
        throw Exception("List assigned to mapEntry was not of length 3");
      }
      _gridPositionOfSouthWestCorner.x =
          min(mapEntry.value[0] as double, _gridPositionOfSouthWestCorner.x);
      _gridPositionOfNorthEastCorner.x = max(mapEntry.value[0] as double, _gridPositionOfNorthEastCorner.x);
      _gridPositionOfSouthWestCorner.y =
          min(mapEntry.value[1] as double, _gridPositionOfSouthWestCorner.y);
      _gridPositionOfNorthEastCorner.y = max(mapEntry.value[1] as double, _gridPositionOfSouthWestCorner.y);
    }

  }
  Vector2 _convertGridPositionToScreenPosition(Vector2 gridPosition) {
    Vector2 gridDifference = gridPosition - _gridPositionOfSouthWestCorner;
    var xInSquareOffset = _gridSquareHorizontalSize * (1-_buildingSideToGridSquareSideRatio) / 2;
    var xPosition = _minCentrePosition.x + _gridSquareHorizontalSize * gridDifference.x + xInSquareOffset;
    var yInSquareOffset = (_gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio)*(1-_buildingSideToGridSquareSideRatio) / 2;
    var yPosition = _minCentrePosition.y - _gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio*gridDifference.y -yInSquareOffset;
    return Vector2(xPosition, yPosition);
  }

  /* pseudocode:
    find southwest building
    calculate required number of gridsquares down x and y axes (range of max x - min x and range of max y - min y)
    calculate horizontal size of gridsquare ( (screenSize/2)/required number of gridsquares))
    for each building:
      xGridDifference = building.x - southWestBuilding.x
      xInSquareOffset = _gridSquareHorizontalSize * (1-buildingToGridSquareRatio) / 2
      xPosition = _minCentrePosition.x + _gridSquareHorizontalSize * xGridDifference + xInSquareOffset
      yGridDifference = building.y - southWestBuilding.y
      yInSquareOffset = (_gridSquareHorizontalSize * squareVerticalToHorizontalRatio) * (1-buildingToGridSquareRatio) /2
      yPosition = _minCentrePosition.y - _gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio*yGridDifference - yInSquareOffset

   */
}


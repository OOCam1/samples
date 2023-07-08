import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/city_screen/building_asset.dart';
import 'package:game_template/src/city_screen/cuboid_building_asset.dart';

import '../game_internals/models/artist_global_info.dart';
import '../game_internals/models/genre.dart';
import '../game_internals/position_and_height_states/genre_grouped_position_state.dart';
import '../game_internals/position_and_height_states/position_state_interface.dart';

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), '', '', [primaryGenre]);
}

/*TODO:
2. make each position of building permanent - currently setUpBuildings does everything from scratch
3. zooooooom
4. make sure setUpBuildings is run after addartists
*/
class CityScreen extends FlameGame {

  static final CityScreen _instance = CityScreen._internal();
  final world = World();
  late final CameraComponent cameraComponent;
  final PositionStateInterface positionStateInterface = GenreGroupedPositionState();
  late double _gridSquareHorizontalSize;
  late double _viewedHeightToActualHeightRatio;
  final double _cameraRadiansFromHorizontal = 80 * pi/180;
  late double _gridSquareVerticalToHorizontalRatio;
  static const double _buildingSideToGridSquareSideRatio = 0.5;
  late double _xMaxPixel;
  late double _yMaxPixel;
  late double _xMinPixel;
  late double _yMinPixel;
  late int _diagonalVerticalMaxGrid;
  late int _diagonalVerticalMinGrid;
  late int _diagonalHorizontalMaxGrid;
  late int _diagonalHorizontalMinGrid;
  late int _buildingMaxHeight;
  final Set<BuildingAsset> _buildingAssets = HashSet();
  final Map<Genre, Paint> _genreToPaint = HashMap();
  late final Map<ArtistGlobalInfo, int> _artists;
  late final List<Set<List<int>>> _obstaclePositions;

  factory CityScreen(Map<ArtistGlobalInfo, int> artists) {
    _instance._artists = artists;
    return _instance;
  }
  CityScreen._internal() {
    _gridSquareVerticalToHorizontalRatio = sin(_cameraRadiansFromHorizontal);
    _viewedHeightToActualHeightRatio = cos(_cameraRadiansFromHorizontal);

  }

  @override
  Future<void> onLoad() async {


    await super.onLoad();
    cameraComponent = CameraComponent(world: world);
    //world.add(cameraComponent);

    await addAll([cameraComponent, world]);
    _xMaxPixel = size.x/2;
    _yMaxPixel = size.y/2;
    _xMinPixel = -_xMaxPixel;
    _yMinPixel = -_yMaxPixel;
    //Rect visibleRect = cameraComponent.visibleWorldRect;


    _setUpBuildings();
    await world.addAll(_buildingAssets);
    //world.add(RectangleComponent.square(size:100.0, position: _minCentrePosition - Vector2(0,100), ));
    // var target = CuboidBuildingAsset(_minCentrePosition + Vector2(300,-100), 200, generateTestArtistGlobalInfo(1),20, 10, _getArtistPaint(generateTestArtistGlobalInfo(1)), 0 );
    // world.add(target);
    print('done');

    // _zoomInOnLocation(target.position - Vector2(0,target.height/2), 1.5);
  }




  void addBuildings(Map<ArtistGlobalInfo, int> artists) {
    _artists.addAll(artists);
    //we will need to run _setUpBuildings at some point
  }
  //takes an argument of a map from ArtistGlobalInfo to a list containing (in order) x grid Position, y grid Position, height
  void _setUpBuildings() {
    //_setExtremeGridPositions(artistPositions);

    positionStateInterface.placeBuildings(_artists);

    _obstaclePositions = _generateObstacleGridPositions();
    var artistPositions = positionStateInterface.getPositionsAndHeights(_obstaclePositions[0], _obstaclePositions[1]);
    //fix this

    _setGridHorizontalSize(artistPositions);
    for (var buildingPositionEntry in artistPositions.entries) {
      if (buildingPositionEntry.value.length != 3) {
        throw Exception("Map entry for building creation does not have length 3 - x, y, height");
      }
      var gridPosition = Vector2(buildingPositionEntry.value[0].toDouble(), buildingPositionEntry.value[1].toDouble());
      Vector2 position = _convertGridPositionToScreenPosition(gridPosition);

      int squareDistance = -pow(buildingPositionEntry.value[0]-positionStateInterface.xMin, 2).toInt() -
          pow(buildingPositionEntry.value[1]-positionStateInterface.yMin, 2).toInt();
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

  void _zoomInOnLocation(Vector2 position, double zoomValue) {
    cameraComponent.moveTo(position, speed:_gridSquareHorizontalSize*15 );
    cameraComponent.viewfinder.zoom = zoomValue;
  }

  void _setGridExtremes(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    var positionValuesList = artistPositions.values.toList();

    positionValuesList.sort((a,b) => (a[0] + a[1]).compareTo(b[0] + b[1]));
    _diagonalVerticalMaxGrid = positionValuesList.last[0] + positionValuesList.last[1];
    _diagonalVerticalMinGrid = positionValuesList[0][0] + positionValuesList[0][1];
    positionValuesList.sort((a,b) => (a[1] - a[0]).compareTo(b[1]-b[0]));
    _diagonalHorizontalMaxGrid = positionValuesList.last[1] - positionValuesList.last[0];
    _diagonalHorizontalMinGrid = positionValuesList[0][1] - positionValuesList[0][0];
    positionValuesList.sort((a,b) => b[2].compareTo(a[2]));
    //find max height of building
    _buildingMaxHeight = positionValuesList[0][2];
    _yMinPixel += _buildingMaxHeight*_viewedHeightToActualHeightRatio;

  }
  void _setGridHorizontalSize(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    _setGridExtremes(artistPositions);
    int numOfSquaresFromTopToBottom = _diagonalVerticalMaxGrid-_diagonalVerticalMinGrid + 1;
    int numOfSquaresFromLeftToRight = _diagonalHorizontalMaxGrid-_diagonalHorizontalMinGrid + 1;
    var horizontalLimit = (_xMaxPixel-_xMinPixel)/(numOfSquaresFromLeftToRight+1);
    var verticalLimit = (_yMaxPixel-_yMinPixel)/(numOfSquaresFromTopToBottom+1)*_gridSquareVerticalToHorizontalRatio;
    // var horizontalLimit = (_xMaxPixel-_xMinPixel)/(numOfSquaresOnGridAxes*2);
    // var verticalLimit = (_yMaxPixel-_yMinPixel)/(numOfSquaresOnGridAxes*_gridSquareVerticalToHorizontalRatio*2);

    _gridSquareHorizontalSize = min(horizontalLimit, verticalLimit);
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

  //returns vertical obstacles, then horizontal obstacles
  List<Set<List<int>>> _generateObstacleGridPositions() {
    return _generateRoadSquares();
  }
  
  //generates the squares in which there will be roads - randomly spaced between 3 and 6 apart
  List<Set<List<int>>> _generateRoadSquares() {
    HashSet<List<int>> verticalRoadSquares = HashSet();
    List<int> verticalRoadPositions = _generate1DRoadPositions(positionStateInterface.xMin, positionStateInterface.xMax);
    List<int> horizontalRoadPositions = _generate1DRoadPositions(positionStateInterface.yMin, positionStateInterface.yMax);
    for (int x in verticalRoadPositions) {
      for (int y = positionStateInterface.yMin; y <=
          positionStateInterface.yMax + horizontalRoadPositions.length; y ++) {
        verticalRoadSquares.add([x, y]);
      }
    }
    HashSet<List<int>> horizontalRoadSquares = HashSet();
    for (int y in horizontalRoadPositions) {
      for (int x = positionStateInterface.xMin; x <=
          positionStateInterface.xMax; x ++) {
        horizontalRoadSquares.add([x, y]);
      }
    }
    return [horizontalRoadSquares, verticalRoadSquares];
  }
  
  //generates 1d coords for location of road
  List<int> _generate1DRoadPositions(int minPosition, int maxPosition) {
    var random = Random();
    List<int> output = [];
    var lastPosition = minPosition;
    var maxPositionOfRoad = maxPosition -2;

    //lmao get fucked
    while (true) {
      var interval = random.nextInt(2) + 3;
      lastPosition += interval;
      if (lastPosition > maxPositionOfRoad) {
        return output;
      }
      output.add(lastPosition);
    }
  }

  /*
  pseudocode:
    calculate xScreenDistanceContribution from x grid coordinate:
      xContribution = gridDifferenceX*HorizontalGridSquareDistance
      yContribution = gridDifferenceY*VerticalGridSquareDistance
      return xContribution - yContribution
    calculate yScreenDistance:
       xContribution = gridDifferenceX * VerticalGridSquareDistance;
       yContribution = gridDifferenceY*VerticalGridSquareDistance;
       return xContribution + yContribution;
   */
  
  Vector2 _convertGridPositionToScreenPosition(Vector2 gridPosition) {

    double horizontalDiagonalCentre = (_diagonalHorizontalMaxGrid+ _diagonalHorizontalMinGrid)/2;
    double verticalDiagonalCentre = (_diagonalVerticalMaxGrid+_diagonalVerticalMinGrid)/2;
    double horizontalGridDifference = (gridPosition.y-gridPosition.x)-horizontalDiagonalCentre;
    double xPosition = horizontalGridDifference*_gridSquareHorizontalSize;
    double verticalGridDifference = (gridPosition.x + gridPosition.y)-verticalDiagonalCentre;
    double yOffset = (_gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio)*(1-_buildingSideToGridSquareSideRatio) / 2;
    double yPosition = verticalGridDifference*_gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio + yOffset;
    return Vector2(xPosition, yPosition);
  }




  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height) {
    throw UnimplementedError();
  }

  void clear() {
    positionStateInterface.clear();
  }



}


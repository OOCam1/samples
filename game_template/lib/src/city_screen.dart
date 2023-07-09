import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/components/building_asset.dart';
import 'package:game_template/src/components/cuboid_building_asset.dart';

import 'game_internals/models/artist_global_info.dart';
import 'game_internals/models/genre.dart';
import 'game_internals/position_and_height_states/genre_grouped_position_state.dart';
import 'game_internals/position_and_height_states/position_state_interface.dart';

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), '', '', [primaryGenre]);
}

/*TODO:
1. Refactor positioning on screen code into new class
2. standardise heights
3. increase definition on edges of cuboids
4. draw roads/river
3. zooooooom
4. make sure setUpBuildings is run after addartists
*/
class CityScreen extends FlameGame {

  static final CityScreen _instance = CityScreen._internal();
  final world = World();
  late final CameraComponent cameraComponent;
  final PositionStateInterface positionStateInterface = GenreGroupedPositionState();
  late double _gridSquareHorizontalSize;
  late final double _viewedHeightToActualHeightRatio;
  static const double _cameraRadiansFromHorizontal = 80 * pi/180;
  late double _gridSquareVerticalToHorizontalRatio;
  static const double _buildingSideToGridSquareSideRatio = 0.5;


  static const int _minDistanceBetweenRoads = 3;
  static const int _maxDistanceBetweenRoads = 5;
  late double _xMaxPixel;
  late double _yMaxPixel;
  late double _xMinPixel;
  late double _yMinPixel;
  late int _diagonalVerticalMaxGrid;
  late int _diagonalVerticalMinGrid;
  late int _diagonalHorizontalMaxGrid;
  late int _diagonalHorizontalMinGrid;
  late int _buildingMaxHeight;
  final Set<PositionComponent> _buildingAssets = HashSet();
  final Map<Genre, Color> _genreToColor = HashMap();
  late final Map<ArtistGlobalInfo, int> _artists;
  late final List<Set<List<int>>> _obstaclePositions;
  final Set<List<int>> _roadPositions = HashSet();


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


    _setUpAssets();
    await world.addAll(_buildingAssets);
    //world.add(RectangleComponent.square(size:100.0, position: _minCentrePosition - Vector2(0,100), ));
    // var target = CuboidBuildingAsset(_minCentrePosition + Vector2(300,-100), 200, generateTestArtistGlobalInfo(1),20, 10, _getArtistPaint(generateTestArtistGlobalInfo(1)), 0 );
    // world.add(target);
    print('done');

    // _zoomInOnLocation(target.position - Vector2(0,target.height/2), 1.5);
  }




  void addBuildings(Map<ArtistGlobalInfo, int> artists) {
    for (int height in artists.values) {
      if (height <= 0) {
        throw Exception('Height assigned to artist should be greater than 0');
      }
    }
    _artists.addAll(artists);
    //we will need to run _setUpBuildings at some point
  }

  //Places buildings in grid positions, then sets each of their positions and heights, creating building components
  //takes an argument of a map from ArtistGlobalInfo to a list containing (in order) x grid Position, y grid Position, height
  void _setUpAssets() {

    positionStateInterface.placeBuildings(_artists);

    _obstaclePositions = _generateObstacleGridPositions();
    var artistPositions = positionStateInterface.getPositionsAndHeights(_obstaclePositions[0], _obstaclePositions[1]);

    _setGridHorizontalSize(artistPositions);
    _setUpBuildings(artistPositions);



  }

  void _setUpBuildings(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    for (var buildingPositionEntry in artistPositions.entries) {
      if (buildingPositionEntry.value.length != 3) {
        throw Exception("Map entry for building creation does not have length 3 - x, y, height");
      }
      var gridPosition = Vector2(buildingPositionEntry.value[0].toDouble(), buildingPositionEntry.value[1].toDouble());
      Vector2 position = _convertGridPositionToScreenPosition(gridPosition);

      //what order buildings will be rendered
      int priority = (gridPosition[0] + gridPosition[1]).toInt();
      double height = buildingPositionEntry.value[2] * _viewedHeightToActualHeightRatio;
      //create new buildingAsset
      _buildingAssets.add(CuboidBuildingAsset(position,
          height,
          buildingPositionEntry.key,
          _gridSquareHorizontalSize*_buildingSideToGridSquareSideRatio,
          _gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio*_buildingSideToGridSquareSideRatio,
          _getArtistColor(buildingPositionEntry.key),
          priority));
    }

  }



  //needs reworking
  void _zoomInOnLocation(Vector2 position, double zoomValue) {
    cameraComponent.moveTo(position, speed:_gridSquareHorizontalSize*15 );
    cameraComponent.viewfinder.zoom = zoomValue;
  }


  //sets the boundaries of the positions on the grid
  void _setGridExtremes(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    var positionValuesList = artistPositions.values.toList();


    //if you look at grid diagonally, what are the top and bottom rows?
    positionValuesList.sort((a,b) => (a[0] + a[1]).compareTo(b[0] + b[1]));
    _diagonalVerticalMaxGrid = positionValuesList.last[0] + positionValuesList.last[1];
    _diagonalVerticalMinGrid = positionValuesList[0][0] + positionValuesList[0][1];

    //if you look at grid diagonally, what are left and right columns?
    positionValuesList.sort((a,b) => (a[1] - a[0]).compareTo(b[1]-b[0]));
    _diagonalHorizontalMaxGrid = positionValuesList.last[1] - positionValuesList.last[0];
    _diagonalHorizontalMinGrid = positionValuesList[0][1] - positionValuesList[0][0];


    //find max height of building
    positionValuesList.sort((a,b) => b[2].compareTo(a[2]));
    _buildingMaxHeight = positionValuesList[0][2];
    _yMinPixel += _buildingMaxHeight*_viewedHeightToActualHeightRatio;

  }

  //set the horizontal size of a grid square based on grid extremes
  void _setGridHorizontalSize(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    _setGridExtremes(artistPositions);
    int numOfSquaresFromTopToBottom = _diagonalVerticalMaxGrid-_diagonalVerticalMinGrid + 1;
    int numOfSquaresFromLeftToRight = _diagonalHorizontalMaxGrid-_diagonalHorizontalMinGrid + 1;
    var horizontalLimit = (_xMaxPixel-_xMinPixel)/(numOfSquaresFromLeftToRight+1);
    var verticalLimit = (_yMaxPixel-_yMinPixel)/(numOfSquaresFromTopToBottom+1)*_gridSquareVerticalToHorizontalRatio;

    _gridSquareHorizontalSize = min(horizontalLimit, verticalLimit);
  }

  //assign a colour to a an artist based on GENRE
  Color _getArtistColor(ArtistGlobalInfo artistGlobalInfo) {
    var genre = artistGlobalInfo.primaryGenre;
    if (_genreToColor.containsKey(genre)) {
      return _genreToColor[genre]!;
    }
    var random = Random();
    var redValue = random.nextInt(255);
    var greenValue = random.nextInt(255);
    var blueValue = random.nextInt(255);
    var newColor = Color.fromRGBO(redValue, greenValue, blueValue, 1);

    _genreToColor[genre] =  newColor;
    return newColor;
  }

  //adds obstacle assets to assets
  //returns vertical obstacle squares, then horizontal obstacle squares
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
      var interval = random.nextInt(_maxDistanceBetweenRoads - _minDistanceBetweenRoads) + _minDistanceBetweenRoads;
      lastPosition += interval;
      if (lastPosition > maxPositionOfRoad) {
        return output;
      }
      output.add(lastPosition);
    }
  }

  _addRoads() {

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




}


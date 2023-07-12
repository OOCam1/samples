import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/components/boundary_square.dart';

import 'package:game_template/src/components/cuboid_building_asset.dart';

import 'package:game_template/src/components/uniform_road_square.dart';

import 'components/building_base_square.dart';
import 'game_internals/models/artist_global_info.dart';
import 'game_internals/models/genre.dart';
import 'game_internals/position_and_height_states/genre_grouped_position_state.dart';
import 'game_internals/position_and_height_states/grid_item.dart';
import 'game_internals/position_and_height_states/pixel.dart';
import 'game_internals/position_and_height_states/position_state_interface.dart';

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), '', '', [primaryGenre]);
}

/*TODO:
1. Refactor positioning on screen code into new class
2. make roads permanent and dynamically add them
2. standardise heights
3. increase definition on edges of cuboids
4. improve roads/river
3. zooooooom
4. make sure setUpBuildings is run after addartists
5.adjust max based on obstacles
6.do grid
7.make uniform square
8. green border squares
9. make sure roads do not run over: they should stop when there are no buildings on either side
10. make new obstacles push buildings but not obstacles
11. obstacles push up and down and left/right not just up or right
12. max and min in position interface are unclear and misused based on obstacle adjusted or not
13. sort out verticalGridSize - should not have to do horizontal*ratio all the time
*/
class CityScreen extends FlameGame {

  static final CityScreen _instance = CityScreen._internal();
  final world = World();
  late final CameraComponent cameraComponent;
  final PositionStateInterface positionStateInterface = GenreGroupedPositionState();
  late double _gridSquareHorizontalSize;
  late final double _viewedHeightToActualHeightRatio;
  static const double _cameraRadiansFromHorizontal = 60 * pi/180;
  late double _gridSquareVerticalToHorizontalRatio;
  static const double _buildingSideToGridSquareSideRatio = 0.4;


  late double _xMaxPixel;
  late double _yMaxPixel;
  late double _xMinPixel;
  late double _yMinPixel;
  late int _diagonalVerticalMaxGrid;
  late int _diagonalVerticalMinGrid;
  late int _diagonalHorizontalMaxGrid;
  late int _diagonalHorizontalMinGrid;
  late int _buildingMaxHeight;
  int _minPriority = 0;
  final Set<PositionComponent> _componentsToRender = HashSet();
  final Map<Genre, Color> _genreToColor = HashMap();
  late final Map<ArtistGlobalInfo, int> _artists;
  late final Map<ArtistGlobalInfo, List<int>> _buildingPositionsAfterObstacles;


  factory CityScreen(Map<ArtistGlobalInfo, int> artists) {
    _instance._artists = artists;
    return _instance;
  }
  CityScreen._internal() {
    _gridSquareVerticalToHorizontalRatio = sin(_cameraRadiansFromHorizontal);
    _viewedHeightToActualHeightRatio = cos(_cameraRadiansFromHorizontal);

  }


  void display(Map<List<int>, GridItem> positions) {
  HashMap<Pixel, GridItem> positionToItem = HashMap();
  var xCoordMin = 0;
  var xCoordMax = 0;
  var yCoordMin = 0;
  var yCoordMax = 0;
  for (var mapEntry in positions.entries) {
    var position = mapEntry.key;
    var pixelPosition = Pixel(position[0], position[1]);
    xCoordMin = min(xCoordMin, position[0]);
    xCoordMax = max(xCoordMax, position[0]);
    yCoordMin = min(yCoordMin, position[1]);
    yCoordMax = max(yCoordMax, position[1]);
    positionToItem[pixelPosition] = mapEntry.value;
  }
  for (int i = 0; i < 5; i ++) {
    print('');
  }

  for (int y = yCoordMax; y >= yCoordMin; y --) {
    String str = "";
    for (int x = xCoordMin; x <= xCoordMax; x ++) {
      if (positionToItem.containsKey(Pixel(x,y))) {
        GridItem value = positionToItem[Pixel(x,y)]!;
        String gd;
        switch(value) {
          case GridItem.building:
            gd = 'b ';
          case GridItem.road:
            gd = 'r ';
          case GridItem.boundary:
            gd = 'g';
        }
        str += "|" + gd + " |";
      }
      else{str += "|  |";}

    }
    print(str);
  }
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
    await world.addAll(_componentsToRender);

    // var target = CuboidBuildingAsset(Vector2(0,0), 200, generateTestArtistGlobalInfo(1),20, 10, Colors.red, 0 );
    // world.add(target);
    print('done');

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

    positionStateInterface.setupBuildingsAndObstacles(roads: true);
    _buildingPositionsAfterObstacles = positionStateInterface.getPositionsAndHeightsOfBuildings();
    for (List<int> position in _buildingPositionsAfterObstacles.values) {
      print(position);
    }
    print("stuff");
    Map<List<int>, GridItem> gridItemPositions = positionStateInterface.getPositionsOfItems();
    for (MapEntry<List<int>, GridItem> mapEntry in gridItemPositions.entries) {
      if (mapEntry.value == GridItem.building) {
        print(mapEntry.key);
      }
    }
    //Set<List<int>> visibleObstaclePositions = _cutDownObstaclePositionsToVisibleOnes();


    //fix
    _setGridHorizontalSize(_buildingPositionsAfterObstacles);
    _setUpBuildings(_buildingPositionsAfterObstacles);
    _setUpGridItemComponents(gridItemPositions);
    display(gridItemPositions);

  }

  void _setUpBuildings(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    for (var buildingPositionEntry in artistPositions.entries) {
      if (buildingPositionEntry.value.length != 3) {
        throw Exception("Map entry for building creation does not have length 3 - x, y, height");
      }
      var gridPosition = Vector2(buildingPositionEntry.value[0].toDouble(), buildingPositionEntry.value[1].toDouble());
      Vector2 positionOfCenterOfSquare = _convertGridPositionToScreenPosition(gridPosition);

      //what order buildings will be rendered
      int priority = -(gridPosition[0] + gridPosition[1]).toInt();

      //so that obstacles can be rendered behind all buildings
      _minPriority = min(priority, _minPriority);

      double height = buildingPositionEntry.value[2] * _viewedHeightToActualHeightRatio;
      //create new buildingAsset
      _componentsToRender.add(CuboidBuildingAsset(positionOfCenterOfSquare,
          height,
          buildingPositionEntry.key,
          _gridSquareHorizontalSize*_buildingSideToGridSquareSideRatio,
          _gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio*_buildingSideToGridSquareSideRatio,
          _getArtistColor(buildingPositionEntry.key),
          priority));
    }

  }

  void _setUpGridItemComponents(Map<List<int>, GridItem> gridItemPositions) {
    for (MapEntry<List<int>, GridItem> mapEntry in gridItemPositions.entries) {
      Vector2 position = _convertGridPositionToScreenPosition(Vector2(mapEntry.key[0].toDouble(), mapEntry.key[1].toDouble()));
      int priority = _minPriority-1-(mapEntry.key[0] + mapEntry.key[1]);
      GridItem itemType = mapEntry.value;
      switch (itemType) {
        case GridItem.building:
          var component = BuildingBaseSquare(_gridSquareHorizontalSize,
          _gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio,
          position,
          priority);
          _componentsToRender.add(component);
        case GridItem.road:
          var component = UniformRoadSquare(_gridSquareHorizontalSize,
              _gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio,
              position, priority);
          _componentsToRender.add(component);
        case GridItem.boundary:
          var component = BoundarySquare(_gridSquareHorizontalSize,
              _gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio,
              position, priority);
          _componentsToRender.add(component);

      }
    }


  }



  //needs reworking
  void _zoomInOnLocation(Vector2 position, double zoomValue) {
    cameraComponent.moveTo(position, speed:_gridSquareHorizontalSize*15 );
    cameraComponent.viewfinder.zoom = zoomValue;
  }


  //sets the boundaries of the positions on the grid
  void _setGridExtremes(Map<ArtistGlobalInfo, List<int>> artistPositions) {
    // Set<List<int>> totalObstaclePositions = _obstaclePositions[0].union(_obstaclePositions[1]);
    var totalObstaclePositions = HashSet<List<int>>();
    var positionValuesList = artistPositions.values.toSet().union(totalObstaclePositions).toList();
    var buildingValuesList = artistPositions.values.toList();
    //if you look at grid diagonally, what are the top and bottom rows?
    positionValuesList.sort((a,b) => (a[0] + a[1]).compareTo(b[0] + b[1]));
    _diagonalVerticalMaxGrid = positionValuesList.last[0] + positionValuesList.last[1];
    _diagonalVerticalMinGrid = positionValuesList[0][0] + positionValuesList[0][1];

    //if you look at grid diagonally, what are left and right columns?
    positionValuesList.sort((a,b) => (a[1] - a[0]).compareTo(b[1]-b[0]));
    _diagonalHorizontalMaxGrid = positionValuesList.last[1] - positionValuesList.last[0];
    _diagonalHorizontalMinGrid = positionValuesList[0][1] - positionValuesList[0][0];


    //find max height of building
    buildingValuesList.sort((a,b) => b[2].compareTo(a[2]));
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


  Vector2 _convertGridPositionToScreenPosition(Vector2 gridPosition) {

    double horizontalDiagonalCentre = (_diagonalHorizontalMaxGrid+ _diagonalHorizontalMinGrid)/2;
    double verticalDiagonalCentre = (_diagonalVerticalMaxGrid+_diagonalVerticalMinGrid)/2;
    double horizontalGridDifference = (-gridPosition.y+gridPosition.x)-horizontalDiagonalCentre;
    double xPosition = horizontalGridDifference*_gridSquareHorizontalSize;
    double verticalGridDifference = (gridPosition.x + gridPosition.y)-verticalDiagonalCentre;
    
    double yPosition = -verticalGridDifference*_gridSquareHorizontalSize*_gridSquareVerticalToHorizontalRatio;
    return Vector2(xPosition, yPosition);
  }




  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height) {
    throw UnimplementedError();
  }




}


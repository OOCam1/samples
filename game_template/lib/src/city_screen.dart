import 'dart:collection';
import 'dart:math';

import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_template/src/components/boundary_square.dart';

import 'package:game_template/src/components/cuboid_building_asset.dart';

import 'package:game_template/src/components/roads/uniform_road_square.dart';
import 'package:game_template/src/components/window_maker_interface.dart';
import 'package:game_template/src/game_internals/models/positioned_building_info.dart';

import 'components/building_base_square.dart';
import 'components/roads/block_road_square.dart';
import 'game_internals/models/artist_global_info.dart';
import 'game_internals/models/genre.dart';
import 'game_internals/models/unpositioned_building_info.dart';
import 'game_internals/position_and_height_states/genre_grouped_position_state.dart';
import 'game_internals/position_and_height_states/grid_item.dart';
import 'game_internals/position_and_height_states/pixel.dart';
import 'game_internals/position_and_height_states/position_state_interface.dart';

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), '', '', [primaryGenre]);
}

/*TODO:
1. (Refactor positioning on screen code into new class)
buildings go off screen if angle low
2. genres are still not organised by height for real bro
4. add river
3. zooooooom
5. extremely shaky logic in genre_grouped_position_state: _purePositionMap should not exist, now that position
is stored in building
6. check that largest genres are placed in centre
13. (sort out verticalGridSize - should not have to do horizontal*ratio all the time)
*/

class CityScreen extends FlameGame {
  static final CityScreen _instance = CityScreen._internal();
  final world = World();
  late final CameraComponent cameraComponent;
  final PositionStateInterface positionStateInterface =
      GenreGroupedPositionState();
  late double _gridSquareHorizontalSize;
  late final double _viewedHeightToActualHeightRatio;
  static const double _cameraRadiansFromHorizontal = 50 * pi / 180;
  late double _gridSquareVerticalToHorizontalRatio;
  static const double _buildingSideToGridSquareSideRatio = 0.5;

  late double _xMaxPixel;
  late double _yMaxPixel;
  late double _xMinPixel;
  late double _yMinPixel;

  late Vector2 _screenPositionOfCenterGridSquare;
  late int _diagonalVerticalMaxGrid;
  late int _diagonalVerticalMinGrid;
  late int _diagonalHorizontalMaxGrid;
  late int _diagonalHorizontalMinGrid;
  late double _buildingMaxHeight;
  int _minPriority = 0;
  final Set<PositionComponent> _componentsToRender = HashSet();
  final Map<Genre, Color> _genreToColor = HashMap();
  final Set<BuildingInfo> _buildingInfos = HashSet();
  Set<PositionedBuildingInfo> _buildingPositionsAfterObstacles = HashSet();
  Map<List<int>, GridItem> _gridItemPositions = HashMap();

  factory CityScreen() {
    return _instance;
  }
  CityScreen._internal() {
    _gridSquareVerticalToHorizontalRatio = sin(_cameraRadiansFromHorizontal);
    _viewedHeightToActualHeightRatio = cos(_cameraRadiansFromHorizontal);
    WindowMaker.setAngleOfView(_cameraRadiansFromHorizontal);
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
    for (int i = 0; i < 5; i++) {
      print('');
    }

    for (int y = yCoordMax; y >= yCoordMin; y--) {
      String str = "";
      for (int x = xCoordMin; x <= xCoordMax; x++) {
        if (positionToItem.containsKey(Pixel(x, y))) {
          GridItem value = positionToItem[Pixel(x, y)]!;
          String gd;
          switch (value) {
            case GridItem.building:
              gd = 'b';
            case GridItem.boundary:
              gd = 'g';
            case GridItem.horizontalRoad:
              gd = 'h';
            case GridItem.verticalRoad:
              gd = 'v';
            case GridItem.intersectionRoad:
              gd = 'i';
          }
          str += "|" + gd + " |";
        } else {
          str += "|  |";
        }
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
    _xMaxPixel = size.x / 2;
    _yMaxPixel = size.y / 2 - 20;
    _xMinPixel = -_xMaxPixel;
    _yMinPixel = -size.y / 2;

    _setUpAssets();
    //Rect visibleRect = cameraComponent.visibleWorldRect;
    await world.addAll(_componentsToRender);

    // var target = CuboidBuildingAsset(Vector2(0,0), 200, generateTestArtistGlobalInfo(1),20, 10, Colors.red, 0 );
    // world.add(target);
    print('done');
  }

  void addBuildings(Iterable<BuildingInfo> newBuildingInfos) {
    for (BuildingInfo buildingInfo in newBuildingInfos) {
      if (buildingInfo.height <= 0) {
        throw Exception('Height assigned to artist should be greater than 0');
      }
    }
    var newBuildingInfoSet =
        newBuildingInfos.toSet().difference(_buildingInfos);
    _buildingInfos.addAll(newBuildingInfos);

    _setBuildingPositions(newBuildingInfoSet);
  }

  void _setBuildingPositions(Set<BuildingInfo> newBuildingInfoSet) {
    positionStateInterface.placeBuildings(newBuildingInfoSet);

    _buildingPositionsAfterObstacles =
        positionStateInterface.getPositionsAndHeightsOfBuildings();

    _gridItemPositions = positionStateInterface.getPositionsOfItems();
  }

  //Places buildings in grid positions, then sets each of their positions and heights, creating building components
  //takes an argument of a map from ArtistGlobalInfo to a list containing (in order) x grid Position, y grid Position, height
  void _setUpAssets() {
    HashMap<ArtistGlobalInfo, List<num>> artistToPosition = HashMap();
    for (PositionedBuildingInfo buildingInfo
        in _buildingPositionsAfterObstacles) {
      artistToPosition[buildingInfo.artistGlobalInfo] = [
        buildingInfo.x,
        buildingInfo.y,
        buildingInfo.height
      ];
    }
    _setGridHorizontalSize(artistToPosition, _gridItemPositions.keys);
    _setUpBuildings(artistToPosition);
    _setUpGridItemComponents(_gridItemPositions);
    display(_gridItemPositions);
  }

  void _setUpBuildings(Map<ArtistGlobalInfo, List<num>> artistPositions) {
    for (var buildingPositionEntry in artistPositions.entries) {
      if (buildingPositionEntry.value.length != 3) {
        throw Exception(
            "Map entry for building creation does not have length 3 - x, y, height");
      }
      var gridPosition = Vector2(buildingPositionEntry.value[0].toDouble(),
          buildingPositionEntry.value[1].toDouble());
      Vector2 positionOfCenterOfSquare =
          _convertGridPositionToScreenPosition(gridPosition);

      //what order buildings will be rendered
      int priority = -(gridPosition[0] + gridPosition[1]).toInt();

      //so that obstacles can be rendered behind all buildings
      _minPriority = min(priority, _minPriority);

      //need to make sure height scales with grid size and angle of view, so multiplied by these
      double height = buildingPositionEntry.value[2] *
          _viewedHeightToActualHeightRatio *
          _gridSquareHorizontalSize;

      //create new buildingAsset
      _componentsToRender.add(CuboidBuildingAsset(
          positionOfCenterOfSquare,
          height,
          buildingPositionEntry.key,
          _gridSquareHorizontalSize * _buildingSideToGridSquareSideRatio,
          _gridSquareHorizontalSize *
              _gridSquareVerticalToHorizontalRatio *
              _buildingSideToGridSquareSideRatio,
          _getArtistColor(buildingPositionEntry.key),
          priority));
    }
  }

  void _setUpGridItemComponents(Map<List<int>, GridItem> gridItemPositions) {
    for (MapEntry<List<int>, GridItem> mapEntry in gridItemPositions.entries) {
      Vector2 position = _convertGridPositionToScreenPosition(
          Vector2(mapEntry.key[0].toDouble(), mapEntry.key[1].toDouble()));
      int priority = _minPriority - 1 - (mapEntry.key[0] + mapEntry.key[1]);
      GridItem itemType = mapEntry.value;
      switch (itemType) {
        case GridItem.building:
          var component = BuildingBaseSquare(
              _gridSquareHorizontalSize,
              _gridSquareHorizontalSize * _gridSquareVerticalToHorizontalRatio,
              position,
              priority);
          _componentsToRender.add(component);

        case GridItem.boundary:
          var component = BoundarySquare(
              _gridSquareHorizontalSize,
              _gridSquareHorizontalSize * _gridSquareVerticalToHorizontalRatio,
              position,
              priority);
          _componentsToRender.add(component);
        case GridItem.horizontalRoad:
          var component = BlockRoadSquare(
              _gridSquareHorizontalSize,
              _gridSquareHorizontalSize * _gridSquareVerticalToHorizontalRatio,
              position,
              GridItem.horizontalRoad,
              priority: priority);
          _componentsToRender.add(component);
        case GridItem.verticalRoad:
          var component = BlockRoadSquare(
              _gridSquareHorizontalSize,
              _gridSquareHorizontalSize * _gridSquareVerticalToHorizontalRatio,
              position,
              GridItem.verticalRoad,
              priority: priority);
          _componentsToRender.add(component);
        case GridItem.intersectionRoad:
          var component = BlockRoadSquare(
              _gridSquareHorizontalSize,
              _gridSquareHorizontalSize * _gridSquareVerticalToHorizontalRatio,
              position,
              GridItem.intersectionRoad,
              priority: priority);
          _componentsToRender.add(component);
      }
    }
  }

  //needs reworking
  void _zoomInOnLocation(Vector2 position, double zoomValue) {
    cameraComponent.moveTo(position, speed: _gridSquareHorizontalSize * 15);
    cameraComponent.viewfinder.zoom = zoomValue;
  }

  //sets the boundaries of the positions on the grid
  void _setGridExtremes(Iterable<List<int>> itemPositions) {
    // Set<List<int>> totalObstaclePositions = _obstaclePositions[0].union(_obstaclePositions[1]);

    var positionValuesList = itemPositions.toList();
    //if you look at grid diagonally, what are the top and bottom rows?
    positionValuesList.sort((a, b) => (a[0] + a[1]).compareTo(b[0] + b[1]));
    _diagonalVerticalMaxGrid =
        positionValuesList.last[0].toInt() + positionValuesList.last[1].toInt();
    _diagonalVerticalMinGrid =
        positionValuesList[0][0].toInt() + positionValuesList[0][1].toInt();

    //if you look at grid diagonally, what are left and right columns?
    positionValuesList.sort((a, b) => (a[1] - a[0]).compareTo(b[1] - b[0]));
    _diagonalHorizontalMaxGrid =
        (positionValuesList.last[1] - positionValuesList.last[0]).toInt();
    _diagonalHorizontalMinGrid =
        (positionValuesList[0][1] - positionValuesList[0][0]).toInt();
  }

  /*
  PSEUDOCODE:
  calculate vertical size of grid and horizontal grid if grid square size was 1
  calculate max visible height of a building if gridsize was 1 (multiplied by viewing angle)
  add it to vertical size to get vertical world size
  calculate yScreenSize/verticalworldsize and xScreenSize/horizontalWorldSize
  the min of these two is scale ratio (gridSquareHorizontalSize).

  now need to calculate screen position of centre square:
    if limit was horizontal, (0,0)
    else:
      (0,visibleBuildingMaxHeight/2)   (just trust me bro)

   */

  //set the horizontal size of a grid square based on grid extremes
  void _setGridHorizontalSize(Map<ArtistGlobalInfo, List<num>> artistPositions,
      Iterable<List<int>> itemPositions) {
    _setGridExtremes(itemPositions);

    //find max height of building
    var buildingValuesList = artistPositions.values.toList();
    buildingValuesList.sort((a, b) => b[2].compareTo(a[2]));
    _buildingMaxHeight = buildingValuesList[0][2].toDouble();

    int numOfSquaresFromTopToBottom =
        _diagonalVerticalMaxGrid - _diagonalVerticalMinGrid + 1;
    int numOfSquaresFromLeftToRight =
        _diagonalHorizontalMaxGrid - _diagonalHorizontalMinGrid + 1;

    //calculates the size of the rectangle the world would fit in if gridSquareHorizontalSize was 1
    var horizontalWorldRelativeSize = numOfSquaresFromLeftToRight + 1;
    var verticalWorldRelativeSize = (numOfSquaresFromTopToBottom + 1) *
            _gridSquareVerticalToHorizontalRatio +
        _buildingMaxHeight * _viewedHeightToActualHeightRatio;

    var horizontalLimitedGridHorizontalSize =
        (_xMaxPixel - _xMinPixel) / horizontalWorldRelativeSize;
    var verticalLimitedGridHorizontalSize =
        (_yMaxPixel - _yMinPixel) / verticalWorldRelativeSize;

    if (horizontalLimitedGridHorizontalSize <=
        verticalLimitedGridHorizontalSize) {
      _gridSquareHorizontalSize = horizontalLimitedGridHorizontalSize;
      _screenPositionOfCenterGridSquare = Vector2(0, 0);
    } else {
      _gridSquareHorizontalSize = verticalLimitedGridHorizontalSize;
      _screenPositionOfCenterGridSquare = Vector2(
          0,
          _buildingMaxHeight *
              _gridSquareHorizontalSize *
              _viewedHeightToActualHeightRatio /
              2);
    }
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

    _genreToColor[genre] = newColor;
    return newColor;
  }

  Vector2 _convertGridPositionToScreenPosition(Vector2 gridPosition) {
    double horizontalDiagonalCentre =
        (_diagonalHorizontalMaxGrid + _diagonalHorizontalMinGrid) / 2;
    double verticalDiagonalCentre =
        (_diagonalVerticalMaxGrid + _diagonalVerticalMinGrid) / 2;
    double horizontalGridDifference =
        (-gridPosition.y + gridPosition.x) - horizontalDiagonalCentre;
    double xPosition = horizontalGridDifference * _gridSquareHorizontalSize;
    double verticalGridDifference =
        (gridPosition.x + gridPosition.y) - verticalDiagonalCentre;

    double yPosition = -verticalGridDifference *
        _gridSquareHorizontalSize *
        _gridSquareVerticalToHorizontalRatio;
    return _screenPositionOfCenterGridSquare + Vector2(xPosition, yPosition);
  }

  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height) {
    throw UnimplementedError();
  }
}

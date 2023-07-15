import 'dart:collection';
import 'dart:math';

import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/genre.dart';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'package:game_template/src/game_internals/position_and_height_states/position_state_interface.dart';
import '../models/positioned_building_info.dart';
import 'building.dart';
import 'grid_item.dart';
import 'position_genre.dart';


class GenreGroupedPositionState implements PositionStateInterface {
  //singleton pattern constructors
  static final GenreGroupedPositionState _instance = GenreGroupedPositionState._internal();

  factory GenreGroupedPositionState() {return _instance;}

  static const int _minDistanceBetweenRoads = 3;
  static const int _maxDistanceBetweenRoads = 5;
  static const int _borderSize = 1;
  //map of location to building
  final Map<Pixel, Building> _purePositionMap = HashMap();
  //map of artist to corresponding building
  final HashMap<ArtistGlobalInfo, Building> _artistGlobalInfoToBuildingMap = HashMap();

  Map<Pixel, GridItem> _obstacleAdjustedPositionMap = HashMap();

  Map<Pixel, Building> _obstacleAdjustedBuildingMap = HashMap();

  final HashMap<Genre, PositionGenre> _genreToPositionGenre = HashMap();
  //Set of empty adjacent squares
  final SplayTreeMap<int, Set<Pixel>> _adjacentEmpties = SplayTreeMap();
  //Central square
  final Pixel _origin = Pixel(0,0);

  late int _xPureBuildingMin;
  late int _xMax;
  late int _yMin;
  late int _yMax;



  @override
  void clear() {
    _purePositionMap.clear();
    _artistGlobalInfoToBuildingMap.clear();
    _genreToPositionGenre.clear();
    var newSet = HashSet<Pixel>();
    newSet.add(_origin);
    _adjacentEmpties.clear();
    _adjacentEmpties[0] = newSet;
  }

  GenreGroupedPositionState._internal() {
    var newSet = HashSet<Pixel>();
    newSet.add(_origin);
    _adjacentEmpties[0] = newSet;
    _xPureBuildingMin = _origin.x;
    _xMax = _origin.x;
    _yMin = _origin.y;
    _yMax = _origin.y;
  }

  @override
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, double height) {
    if (!_artistGlobalInfoToBuildingMap.containsKey(artistGlobalInfo)) {
      throw Exception("Artist info not in position state");
    }
    Building building = _artistGlobalInfoToBuildingMap[artistGlobalInfo]!;
    if (height < building.height) {
      throw Exception("New height of building smaller than old height");
    }
    _artistGlobalInfoToBuildingMap[artistGlobalInfo]!.setHeight(height);
  }



  @override
  Set<PositionedBuildingInfo> getPositionsAndHeightsOfBuildings() {
    HashSet<PositionedBuildingInfo> output = HashSet();
    for (MapEntry<Pixel, Building> mapEntry in _obstacleAdjustedBuildingMap.entries) {
      output.add(PositionedBuildingInfo.fromBuilding(mapEntry.value, mapEntry.key.toList()));

    }
    return output;
  }

  @override
  Map<List<int>, GridItem> getPositionsOfItems() {
    HashMap<List<int>, GridItem> output = HashMap();
    for (MapEntry<Pixel, GridItem> mapEntry in _obstacleAdjustedPositionMap.entries) {
      output[mapEntry.key.toList()] = mapEntry.value;
    }
    return output;
  }


  //place roads
  @override
  void setupBuildingsAndObstacles({bool roads = false, bool border = false }) {
    if (_purePositionMap.isEmpty) {return;}
    for (MapEntry<Pixel, Building> mapEntry in _purePositionMap.entries) {
      _obstacleAdjustedBuildingMap[mapEntry.key] = mapEntry.value;
      _obstacleAdjustedPositionMap[mapEntry.key] = GridItem.building;
    }
    if (roads) {_addRoads();}
    _cutObstacleSquaresToWithinBorder();
    if (border) {_addBoundaries();}


  }

  @override
  void placeBuildings(Map<ArtistGlobalInfo, double> buildings) {
    HashMap<Genre, HashMap<ArtistGlobalInfo, double>> districtBuildings = HashMap();
    for (MapEntry<ArtistGlobalInfo, double> mapEntry in buildings.entries) {
      var artistGlobalInfo = mapEntry.key;
      var primaryGenre = artistGlobalInfo.primaryGenre;
      if (!districtBuildings.containsKey(artistGlobalInfo.primaryGenre)) {
        districtBuildings[primaryGenre] = HashMap();
      }
      districtBuildings[primaryGenre]![artistGlobalInfo] = mapEntry.value;
    }
    for (MapEntry<Genre, HashMap<ArtistGlobalInfo, double>> mapEntry in districtBuildings.entries) {

      for (MapEntry<ArtistGlobalInfo, double> artistMapEntry in mapEntry.value.entries) {
        placeNewBuilding(artistMapEntry.key, artistMapEntry.value);
      }
    }

    HashMap<PositionGenre, HashSet<Building>> genreToBuildings = HashMap();
    for (MapEntry<ArtistGlobalInfo, Building> mapEntry in _artistGlobalInfoToBuildingMap.entries) {
      var positionGenre = _genreToPositionGenre[mapEntry.key.primaryGenre]!;
      if (!genreToBuildings.containsKey(positionGenre)) {
        genreToBuildings[positionGenre] = HashSet();
      }
      genreToBuildings[positionGenre]!.add(mapEntry.value);
    }
    var genreList = genreToBuildings.entries.toList();
    genreList.sort((a,b) => (-a.value.length.compareTo(b.value.length)));

    for (MapEntry<PositionGenre, HashSet<Building>> mapEntry in genreList) {
      mapEntry.key.organiseByHeight(mapEntry.value);
    }
  }

  @override
  void placeNewBuilding(ArtistGlobalInfo artistGlobalInfo, double height) {
    if (_artistGlobalInfoToBuildingMap.containsKey(artistGlobalInfo)) {
      throw Exception("Artist already in position state");
    }
    Building buildingToPlace = Building(artistGlobalInfo, height, _getPositionGenre(artistGlobalInfo.primaryGenre));
    _artistGlobalInfoToBuildingMap[artistGlobalInfo] = buildingToPlace;
    _findSpotAndPlaceBuilding(buildingToPlace, HashSet());
  }

  PositionGenre _getPositionGenre(Genre genre) {
    if (_genreToPositionGenre.containsKey(genre)) {return _genreToPositionGenre[genre]!;}
    var positionGenre = PositionGenre(_generateDistrictOrigins());
    _genreToPositionGenre[genre] = positionGenre;
    return positionGenre;
  }

  void _findSpotAndPlaceBuilding(Building building, HashSet<PositionGenre> previousGenres) {
    previousGenres.add(building.positionGenre);
    bool squareOccupied = false;
    Pixel position = building.positionGenre.findPosition(previousGenres);

    //placeholder variable: should never run with oldBuilding set to building
    Building oldBuilding = building;
    if (_purePositionMap.containsKey(position)) {
      squareOccupied = true;
      oldBuilding = _purePositionMap[position]!;

    }
    _placeBuildingInNewSquare(building, position);
    if (squareOccupied) {
      _findSpotAndPlaceBuilding(oldBuilding, previousGenres);
      oldBuilding.positionGenre.dealWithOwnBuildingRemovedFromSpace(position);
    }
  }

  void _placeBuildingInNewSquare(Building building, Pixel pixel) {
    building.setPosition(pixel);
    _updateExtremes(pixel);
    _removeFromAdjacentEmpties(pixel);
    _purePositionMap[pixel] = building;
    building.positionGenre.addOwnBuildingToSquare(building);
    for (Pixel adjacentPixel in pixel.getAdjacents()) {
      _adjustAdjacents(pixel, adjacentPixel);
    }

  }

  void _updateExtremes(Pixel pixel) {
    _xPureBuildingMin = min(_xPureBuildingMin, pixel.x);
    _xMax = max(_xMax, pixel.x);
    _yMin = min(_yMin, pixel.y);
    _yMax = max(_yMax, pixel.y);
  }

  void _adjustAdjacents(Pixel newBuildingPosition, Pixel adjacentSquare) {
    PositionGenre newPositionGenre = _purePositionMap[newBuildingPosition]!.positionGenre;
    if (_purePositionMap.containsKey(adjacentSquare)) {
      PositionGenre adjacentPositionGenre = _purePositionMap[adjacentSquare]!.positionGenre;
      adjacentPositionGenre.handleAdjacentSquareGettingOccupied(newBuildingPosition, newPositionGenre);
      newPositionGenre.handleAdjacentSquareGettingOccupied(adjacentSquare, adjacentPositionGenre);
    }
    else {
      newPositionGenre.addToAdjacentEmpties(adjacentSquare);
      _addToAdjacentEmpties(adjacentSquare);
    }
  }

  int _getDistanceSquare(Pixel pixel) {
    return (pow(pixel.x-_origin.x, 2) + pow(pixel.y-_origin.y, 2)) as int;
  }


  void _addToAdjacentEmpties(Pixel pixel) {
    var distance = _getDistanceSquare(pixel);
    if (!_adjacentEmpties.containsKey(distance)) {
      Set<Pixel> pixelSet = HashSet();
      _adjacentEmpties[distance] = pixelSet;
    }
    _adjacentEmpties[distance]!.add(pixel);
  }

  void _removeFromAdjacentEmpties(Pixel pixel) {
    var distance = _getDistanceSquare(pixel);
    if (_adjacentEmpties.containsKey(distance)) {
      _adjacentEmpties[distance]!.remove(pixel);
    }
  }

  Pixel _generateDistrictOrigins() {
    for (Set<Pixel> pixelSet in _adjacentEmpties.values) {
      for (Pixel p in pixelSet) {
        return p;
      }
    }
    throw Exception("No squares in adjacentEmpties");
  }
  /*
  pseudocode:
  get dict from xPositionToVerticalObstacles and yPositionToHorizontalObstacles
  for each building:
    shift vertically according to verticalObstacles in its column
    shift horizontally according to horizontalObstacles in its new y position:
        calculate offset, but if you land on a
   */


  void _addBoundaries() {
    for (Pixel pixel in _obstacleAdjustedBuildingMap.keys) {
      for (int x = pixel.x-_borderSize; x <= pixel.x+_borderSize; x ++) {
        for (int y = pixel.y - _borderSize; y <= pixel.y + _borderSize; y ++) {
          var newPosition = Pixel(x,y);
          if (!_obstacleAdjustedPositionMap.containsKey(newPosition)) {
            _obstacleAdjustedPositionMap[newPosition] = GridItem.boundary;
          }
        }
      }
    }
  }


  //returns [[xminBuildingPosition, xMaxBuildingPosition], [yminBuildingPosition, yMaxBuildingPosition]]
  void _addRoads() {
    List<Set<Pixel>> roadSquares = _generateRoadSquares();
    _adjustPositionsForObstacles(roadSquares[0], roadSquares[1]);
    for (Set<Pixel> pixelSet in roadSquares) {
      for (Pixel pixel in pixelSet) {
        _obstacleAdjustedPositionMap[pixel] = GridItem.road;
      }
    }
  }

  List<List<int>> _getExtremes(Iterable<Pixel> positions) {
    if (positions.isEmpty) {
      return [[0,0], [0,0]];
    }
    List<Pixel> positionList = positions.toList();
    int xMin = positionList[0].x;
    int xMax = positionList[0].x;
    int yMin = positionList[0].y;
    int yMax = positionList[0].y;

    for (Pixel pixel in positionList) {
      xMin = min(xMin, pixel.x);
      xMax = max(xMax, pixel.x);
      yMin = min(yMin, pixel.y);
      yMax = max(yMax, pixel.y);
    }
    return [[xMin, xMax], [yMin, yMax]];
  }

  //generates 1d coords for locations of road
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

  List<Set<Pixel>> _generateRoadSquares() {
    HashSet<Pixel> verticalRoadSquares = HashSet();
    List<List<int>> currentLimits = _getExtremes(_obstacleAdjustedBuildingMap.keys);
    int xMinWithObstacles = currentLimits[0][0];
    int xMaxWithObstacles = currentLimits[0][1];
    int yMinWithObstacles = currentLimits[1][0];
    int yMaxWithObstacles = currentLimits[1][1];
    List<int> verticalRoadPositions = _generate1DRoadPositions(xMinWithObstacles, xMaxWithObstacles);
    List<int> horizontalRoadPositions = _generate1DRoadPositions(yMinWithObstacles, yMaxWithObstacles);
    //Map<int, List<int>> rowToHorizontalLimits = _generate2DLimitsFrom1D(1, horizontalRoadPositions);
    //Map<int, List<int>> columnToVerticalLimits = _generate2DLimitsFrom1D(0, verticalRoadPositions);
    for (int x in verticalRoadPositions) {
      for (int y = yMinWithObstacles-_borderSize; y <= yMaxWithObstacles + horizontalRoadPositions.length + _borderSize; y ++) {
        verticalRoadSquares.add(Pixel(x,y));
      }
    }
    HashSet<Pixel> horizontalRoadSquares = HashSet();
    for (int y in horizontalRoadPositions) {
      for (int x = xMinWithObstacles-_borderSize; x <= xMaxWithObstacles + verticalRoadPositions.length + _borderSize; x ++) {
        horizontalRoadSquares.add(Pixel(x,y));
      }
    }
    verticalRoadSquares.toSet().union(horizontalRoadSquares.toSet());
    return [horizontalRoadSquares, verticalRoadSquares];
  }

  HashMap<int, List<int>> _generate2DLimitsForEachLine(int rowOrColumn) {
    if (rowOrColumn != 0 && rowOrColumn != 1) {throw Error();}
    HashMap<int, List<int>> output = HashMap();
    var otherIndex = (rowOrColumn+1)%2;
    HashMap<int, List<int>> buildingLineToPosition = HashMap();
    //generate line to position of building positions

    List<int> minLimits = [0,0];
    List<int> maxLimits = [0,0];
    var currentLimits = _getExtremes(_obstacleAdjustedPositionMap.keys);
    minLimits = [currentLimits[0][0], currentLimits[1][0]];
    maxLimits = [currentLimits[0][1], currentLimits[1][1]];
    // print('buildings');
    // for (Pixel position in _obstacleAdjustedBuildingMap.keys) {
    //
    // }

    for (Pixel position in _obstacleAdjustedPositionMap.keys) {
      if (_obstacleAdjustedPositionMap[position] == GridItem.building) {

      }
    }
    //empty rows/columns should still have a key that points to empty list, rather than no key
    for (Pixel position in _obstacleAdjustedBuildingMap.keys) {

      if (!buildingLineToPosition.containsKey(position.toList()[rowOrColumn])){
        buildingLineToPosition[position.toList()[rowOrColumn]] = [];
      }
      buildingLineToPosition[position.toList()[rowOrColumn]]!.add(position.toList()[otherIndex]);
    }


    for (int line = minLimits[rowOrColumn]-1; line <= maxLimits[rowOrColumn] +1; line ++) {
      if (!buildingLineToPosition.containsKey(line)) {
        output[line] = [10,-10];
      }
      else {
        List<int> buildingPositions = buildingLineToPosition[line]!;
        var minBuildingPosition = buildingPositions.reduce(min);
        var maxBuildingPosition = buildingPositions.reduce(max);
        output[line] = [minBuildingPosition, maxBuildingPosition];
      }
    }
    
    return output;
  }

  void _cutObstacleSquaresToWithinBorder() {

    Map<int, List<int>> xToColumnPositions = _generate2DLimitsForEachLine(0);
    Map<int,List<int>> yToRowPositions = _generate2DLimitsForEachLine(1);
    HashSet<Pixel> toRemove = HashSet();
    for (MapEntry<Pixel, GridItem> position in _obstacleAdjustedPositionMap.entries) {
      if (position.value != GridItem.building) {
        int x = position.key.x;
        int y = position.key.y;

        var leftYLimits = xToColumnPositions[x - 1]!;
        var rightYLimits = xToColumnPositions[x + 1]!;
        var bottomXLimits = yToRowPositions[y - 1]!;
        var topXLimits = yToRowPositions[y + 1]!;

        bool positionInLimit(int number, List<int> limits) {
          return ((number >= limits[0] - _borderSize) && (number <= limits[1] + _borderSize));
        }

        var xInXLimits = positionInLimit(x, bottomXLimits) || positionInLimit(x, topXLimits);
        var yInYLimits = positionInLimit(y, leftYLimits) || positionInLimit(y, rightYLimits);
        if (!(xInXLimits || yInYLimits)) {
          toRemove.add(position.key);

        }
      }
    }
    for (Pixel p in toRemove) {_obstacleAdjustedPositionMap.remove(p);}

  }


  //horizontal obstacles actually must be the union of vertical obstacles and horizontal obstacles since we shift vertically first
  //and want to avoid shifting buildings horizontally into vertical obstacles.
  void _adjustPositionsForObstacles(Set<Pixel> verticalObstacles, Set<Pixel> horizontalObstacles) {
    var verticallyAdjustedPositions = _adjustPositionsForVerticalObstacles(verticalObstacles);
    Map<Pixel, Pixel> oldPositionsToNewPositions = _adjustPositionsForHorizontalObstacles(verticallyAdjustedPositions, horizontalObstacles, verticalObstacles);
    HashMap<Pixel, Building> newObstacleAdjustedBuildingMap = HashMap();
    for (MapEntry<Pixel, Building> mapEntry in _obstacleAdjustedBuildingMap.entries) {
      Pixel newPosition = oldPositionsToNewPositions[mapEntry.key]!;
      newObstacleAdjustedBuildingMap[newPosition] = mapEntry.value;
    }
    _obstacleAdjustedBuildingMap = newObstacleAdjustedBuildingMap;

    HashMap<Pixel, GridItem> newObstacleAdjustedPositionMap = HashMap();

    for(MapEntry<Pixel, GridItem> mapEntry in _obstacleAdjustedPositionMap.entries) {
      var newPosition = oldPositionsToNewPositions[mapEntry.key]!;
      newObstacleAdjustedPositionMap[newPosition] = mapEntry.value;

  }
    _obstacleAdjustedPositionMap = newObstacleAdjustedPositionMap;

  }

  Map<Pixel, Pixel> _adjustPositionsForVerticalObstacles(Set<Pixel> verticalObstacles) {
    HashMap<int, HashSet<int>> xPositionToVerticalObstacles = _generatePositionToSetPositions(verticalObstacles, 0);
    Map<Pixel, Pixel> output = HashMap();
    for (Pixel currentPosition in _obstacleAdjustedPositionMap.keys) {

      int yPosition = currentPosition.y;
      if (xPositionToVerticalObstacles.containsKey(currentPosition.x)) {
        yPosition = _calculateNewBuildingPositionFromObstacles(
            currentPosition.y,
            xPositionToVerticalObstacles[currentPosition.x]!);
      }
      var newPosition = Pixel(currentPosition.x, yPosition);
      output[currentPosition] = newPosition;
    }
    return output;
  }

  Map<Pixel, Pixel> _adjustPositionsForHorizontalObstacles(Map<Pixel, Pixel> adjustedPositions, Set<Pixel> horizontalObstacles, Set<Pixel> verticalObstacles) {
    HashMap<int, HashSet<int>> yPositionToHorizontalObstacles = _generatePositionToSetPositions(horizontalObstacles, 1);
    HashMap<Pixel, Pixel> output = HashMap();
    for (MapEntry<Pixel, Pixel> mapEntry in adjustedPositions.entries) {
      var halfAdjustedPosition = mapEntry.value;
      int xPosition = halfAdjustedPosition.x;
      if (yPositionToHorizontalObstacles.containsKey(halfAdjustedPosition.y)) {
        xPosition = _calculateNewBuildingPositionFromObstacles(
            halfAdjustedPosition.x,
            yPositionToHorizontalObstacles[halfAdjustedPosition.y]!);
      }
      var newPosition = Pixel(xPosition, halfAdjustedPosition.y);
      output[mapEntry.key] = newPosition;
    }
    return output;
  }


  //outputKey should be 0 for x to yPositions and 1 for y to xPositions
  HashMap<int, HashSet<int>> _generatePositionToSetPositions(Set<Pixel> obstacles, int outputKey) {
    HashMap<int, HashSet<int>> positionToObstacles = HashMap();

    for (Pixel obstacle in obstacles) {
      int outputLetter;
      int otherLetter;
      if (outputKey == 0) {outputLetter = obstacle.x; otherLetter = obstacle.y;}
      else {outputLetter = obstacle.y; otherLetter = obstacle.x;}
      if (!positionToObstacles.containsKey(outputLetter)) {
        positionToObstacles[outputLetter] = HashSet();
      }
      positionToObstacles[outputLetter]!.add(otherLetter);

    }
    return positionToObstacles;
  }
  //shift horizontally based on horizontal obstacles
  //if we would shift horizontally, must increase offset based on vertical obstacles in same row

  /*
  pseudocode:
  each time we come across an obstacle, increment new position, until we find a primary obstacle that we are behind.
  if position less than all primary obstacles:
      return
  otherwise, go through totalObstacles, incrementing newPosition until we get to item we are less than.
   */
  int _calculateNewBuildingPositionFromObstacles(int buildingPosition, Set<int> obstaclePositions, [Set<int>? secondaryObstaclePositions]) {
    if (obstaclePositions.isEmpty || buildingPosition < obstaclePositions.reduce(min)) {return buildingPosition;}
    Set<int> totalObstacles = obstaclePositions;
    if (secondaryObstaclePositions != null) {
      totalObstacles = obstaclePositions.union(secondaryObstaclePositions);
    }
    var sortedObstaclePositions = totalObstacles.toList();
    sortedObstaclePositions.sort();
    var newPosition = buildingPosition;
    for (int obstaclePosition in sortedObstaclePositions) {
      if (newPosition < obstaclePosition ) {
        return newPosition;
      }
      newPosition ++;
    }
    return newPosition;
  }



  @override
  int get xMax => _xMax;
  @override
  int get xMin => _xPureBuildingMin;

  @override
  int get yMin => _yMin;

  @override
  int get yMax => _yMax;

}








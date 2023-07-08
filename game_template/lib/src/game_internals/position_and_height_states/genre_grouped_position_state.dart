import 'dart:collection';
import 'dart:math';

import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/genre.dart';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'package:game_template/src/game_internals/position_and_height_states/position_state_interface.dart';
import 'building.dart';
import 'position_genre.dart';


class GenreGroupedPositionState implements PositionStateInterface {
  //singleton pattern constructors
  static final GenreGroupedPositionState _instance = GenreGroupedPositionState._internal();

  factory GenreGroupedPositionState() {return _instance;}

  //map of location to building
  final Map<Pixel, Building> _positionMap = HashMap();
  //map of artist to corresponding building
  final HashMap<ArtistGlobalInfo, Building> _artistGlobalInfoToBuildingMap = HashMap();

  final HashMap<Genre, PositionGenre> _genreToPositionGenre = HashMap();
  //Set of empty adjacent squares
  final SplayTreeMap<int, Set<Pixel>> _adjacentEmpties = SplayTreeMap();
  //Central square
  final Pixel _origin = Pixel(0,0);

  late int _xMin;
  late int _xMax;
  late int _yMin;
  late int _yMax;



  @override
  void clear() {
    _positionMap.clear();
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
    _xMin = _origin.x;
    _xMax = _origin.x;
    _yMin = _origin.y;
    _yMax = _origin.y;
  }

  @override
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height) {
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
  //returns map from ArtistGlobalInfo to [x,y,height]
  Map<ArtistGlobalInfo, List<int>> getPositionsAndHeights([Iterable<List<int>>? verticalObstacles, Iterable<List<int>>? horizontalObstacles ]) {
    Set<List<int>> verticals;
    Set<List<int>> horizontals;
    if (verticalObstacles == null) {verticals = HashSet();}
    else {verticals = verticalObstacles.toSet();}
    if (horizontalObstacles == null) {horizontals = HashSet();}
    else {horizontals = horizontalObstacles.toSet();}
    Map<Building, Pixel> buildingToAdjustedPixel = _adjustPositionsForObstacles(verticals, horizontals);
    HashMap<ArtistGlobalInfo, List<int>> output = HashMap();
    for (MapEntry<Building, Pixel> mapEntry in buildingToAdjustedPixel.entries) {
      output[mapEntry.key.artistGlobalInfo] = [mapEntry.value.x,mapEntry.value.y, mapEntry.key.height];
    }

    return output;
  }

  @override
  void placeBuildings(Map<ArtistGlobalInfo, int> buildings) {
    HashMap<Genre, HashMap<ArtistGlobalInfo, int>> districtBuildings = HashMap();
    for (MapEntry<ArtistGlobalInfo, int> mapEntry in buildings.entries) {
      var artistGlobalInfo = mapEntry.key;
      var primaryGenre = artistGlobalInfo.primaryGenre;
      if (!districtBuildings.containsKey(artistGlobalInfo.primaryGenre)) {
        districtBuildings[primaryGenre] = HashMap();
      }
      districtBuildings[primaryGenre]![artistGlobalInfo] = mapEntry.value;
    }
    for (MapEntry<Genre, HashMap<ArtistGlobalInfo, int>> mapEntry in districtBuildings.entries) {

      for (MapEntry<ArtistGlobalInfo, int> artistMapEntry in mapEntry.value.entries) {
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
    for (MapEntry<PositionGenre, HashSet<Building>> mapEntry in genreToBuildings.entries) {
      mapEntry.key.organiseByHeight(mapEntry.value);
    }
  }

  @override
  void placeNewBuilding(ArtistGlobalInfo artistGlobalInfo, int height) {
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
    if (_positionMap.containsKey(position)) {
      squareOccupied = true;
      oldBuilding = _positionMap[position]!;

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
    _positionMap[pixel] = building;
    building.positionGenre.addOwnBuildingToSquare(building);
    for (Pixel adjacentPixel in pixel.getAdjacents()) {
      _adjustAdjacents(pixel, adjacentPixel);
    }

  }

  void _updateExtremes(Pixel pixel) {
    _xMin = min(_xMin, pixel.x);
    _xMax = max(_xMax, pixel.x);
    _yMin = min(_yMin, pixel.y);
    _yMax = max(_yMax, pixel.y);
  }

  void _adjustAdjacents(Pixel newBuildingPosition, Pixel adjacentSquare) {
    PositionGenre newPositionGenre = _positionMap[newBuildingPosition]!.positionGenre;
    if (_positionMap.containsKey(adjacentSquare)) {
      PositionGenre adjacentPositionGenre = _positionMap[adjacentSquare]!.positionGenre;
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

  //horizontal obstacles actually must be the union of vertical obstacles and horizontal obstacles since we shift vertically first
  //and want to avoid shifting buildings horizontally into vertical obstacles.
  Map<Building, Pixel> _adjustPositionsForObstacles(Set<List<int>> verticalObstacles, Set<List<int>> horizontalObstacles) {
    var verticallyAdjustedPositions = _adjustPositionsForVerticalObstacles(verticalObstacles);
    return _adjustPositionsForHorizontalObstacles(verticallyAdjustedPositions, horizontalObstacles, verticalObstacles);

  }
  Map<Building, Pixel> _adjustPositionsForVerticalObstacles(Set<List<int>> verticalObstacles) {
    HashMap<int, HashSet<int>> xPositionToVerticalObstacles = _generatePositionToSetPositions(verticalObstacles, 0);
    Map<Building, Pixel> output = HashMap();
    for (Building building in _positionMap.values) {
      var currentPosition = building.position;
      int yPosition = currentPosition.y;
      if (xPositionToVerticalObstacles.containsKey(currentPosition.x)) {
        yPosition = _calculateNewBuildingPositionFromObstacles(
            currentPosition.y,
            xPositionToVerticalObstacles[currentPosition.x]!);
      }
      var newPosition = Pixel(currentPosition.x, yPosition);
      output[building] = newPosition;
    }
    return output;
  }

  //outputKey should be 0 for x to yPositions and 1 for y to xPositions
  HashMap<int, HashSet<int>> _generatePositionToSetPositions(Set<List<int>> obstacles, int outputKey) {
    HashMap<int, HashSet<int>> positionToObstacles = HashMap();
    for (List<int> obstacle in obstacles) {
      if (obstacle.length != 2) {
        throw Exception("Obstacles should be lists of length 2");
      }

      if (!positionToObstacles.containsKey(obstacle[outputKey])) {
        positionToObstacles[obstacle[outputKey]] = HashSet();
      }
      positionToObstacles[obstacle[outputKey]]!.add(obstacle[(outputKey+1)%2]);

    }
    return positionToObstacles;
  }
  //shift horizontally based on horizontal obstacles
  //if we would shift horizontally, must increase offset based on vertical obstacles in same row
  Map<Building, Pixel> _adjustPositionsForHorizontalObstacles(Map<Building, Pixel> adjustedPositions, Set<List<int>> horizontalObstacles, Set<List<int>> verticalObstacles) {
    HashMap<int, HashSet<int>> yPositionToHorizontalObstacles = _generatePositionToSetPositions(horizontalObstacles, 1);
    HashMap<int, HashSet<int>> yPositionToVerticalObstacles = _generatePositionToSetPositions(verticalObstacles, 1);
    Map<Building, Pixel> output = HashMap();
    for (MapEntry<Building, Pixel> mapEntry in adjustedPositions.entries) {
      var currentPosition = mapEntry.value;
      int xPosition = currentPosition.x;
      if (yPositionToHorizontalObstacles.containsKey(currentPosition.y)) {
        xPosition = _calculateNewBuildingPositionFromObstacles(
            currentPosition.x,
            yPositionToHorizontalObstacles[currentPosition.y]!);
      }
      var newPosition = Pixel(xPosition, currentPosition.y);
      output[mapEntry.key] = newPosition;
    }
    return output;
  }

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
  int get xMin => _xMin;

  @override
  int get yMin => _yMin;

  @override
  int get yMax => _yMax;
}








import 'dart:collection';
import 'dart:math';

import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/genre.dart';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'package:game_template/src/game_internals/position_and_height_states/position_state_interface.dart';
import 'building.dart';
import 'grid_item.dart';
import 'position_genre.dart';


class GenreGroupedPositionState implements PositionStateInterface {
  //singleton pattern constructors
  static final GenreGroupedPositionState _instance = GenreGroupedPositionState._internal();

  factory GenreGroupedPositionState() {return _instance;}

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

  late int _xMin;
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
  Map<ArtistGlobalInfo, List<int>> getPositionsAndHeightsOfBuildings() {
    Map<ArtistGlobalInfo, List<int>> output = HashMap();
    for (MapEntry<Pixel, Building> mapEntry in _obstacleAdjustedBuildingMap.entries) {
      var mapValue = [mapEntry.key.x, mapEntry.key.y, mapEntry.value.height];
      output[mapEntry.value.artistGlobalInfo] = mapValue;
    }
    return output;
  }

  @override
  Map<List<int>, GridItem> getPositionsOfItems() {
    // TODO: implement getPositionsOfItems
    throw UnimplementedError();
  }

  @override
  void setupBuildingsAndObstacles([bool roads = false]) {
    for (MapEntry<Pixel, Building> mapEntry in _purePositionMap.entries) {
      _obstacleAdjustedBuildingMap[mapEntry.key] = mapEntry.value;
      _obstacleAdjustedPositionMap[mapEntry.key] = GridItem.building;
    }

  }

  // //returns map from ArtistGlobalInfo to [x,y,height]
  // Map<ArtistGlobalInfo, List<int>> getPositionsAndHeights([Iterable<List<int>>? verticalObstacles, Iterable<List<int>>? horizontalObstacles ]) {
  //   Set<List<int>> verticals;
  //   Set<List<int>> horizontals;
  //   if (verticalObstacles == null) {verticals = HashSet();}
  //   else {verticals = verticalObstacles.toSet();}
  //   if (horizontalObstacles == null) {horizontals = HashSet();}
  //   else {horizontals = horizontalObstacles.toSet();}
  //   Map<Building, Pixel> buildingToAdjustedPixel = _adjustPositionsForObstacles(verticals, horizontals);
  //   HashMap<ArtistGlobalInfo, List<int>> output = HashMap();
  //   for (MapEntry<Building, Pixel> mapEntry in buildingToAdjustedPixel.entries) {
  //     output[mapEntry.key.artistGlobalInfo] = [mapEntry.value.x,mapEntry.value.y, mapEntry.key.height];
  //   }
  //
  //   return output;
  // }

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
    var genreList = genreToBuildings.entries.toList();
    genreList.sort((a,b) => (b.value.length.compareTo(a.value.length)));

    for (MapEntry<PositionGenre, HashSet<Building>> mapEntry in genreList) {
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
    _xMin = min(_xMin, pixel.x);
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
  int get xMin => _xMin;

  @override
  int get yMin => _yMin;

  @override
  int get yMax => _yMax;

}








import 'dart:collection';
import 'dart:math';
import 'package:game_template/src/game_internals/artist_global_info.dart';
import 'package:game_template/src/game_internals/genre.dart';
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
  }

  @override
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height) {
    if (!_artistGlobalInfoToBuildingMap.containsKey(artistGlobalInfo)) {
      throw Exception("Artist info not in position state");
    }
    Building building = _artistGlobalInfoToBuildingMap[artistGlobalInfo]!;
    if (height < building.getHeight()) {
      throw Exception("New height of building smaller than old height");
    }
    _artistGlobalInfoToBuildingMap[artistGlobalInfo]!.setHeight(height);
  }

  @override
  //returns map from ArtistGlobalInfo to [x,y,height]
  Map<ArtistGlobalInfo, List<int>> getPositionsAndHeights() {
    HashMap<ArtistGlobalInfo, List<int>> output = HashMap();
    for (MapEntry<ArtistGlobalInfo, Building> mapEntry in _artistGlobalInfoToBuildingMap.entries) {
      var building = mapEntry.value;
      var position = building.position;
      output[mapEntry.key] = [position.x, position.y, building.getHeight()];
    }
    return output;
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
    _removeFromAdjacentEmpties(pixel);
    _positionMap[pixel] = building;
    building.positionGenre.addOwnBuildingToSquare(building);
    for (Pixel adjacentPixel in pixel.getAdjacents()) {
      _adjustAdjacents(pixel, adjacentPixel);
    }

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


}








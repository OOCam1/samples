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
  final SplayTreeMap<double, Set<Pixel>> _adjacentEmpties = SplayTreeMap();
  //Central square
  final Pixel _origin = Pixel(0,0);



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
  Map<ArtistGlobalInfo, List<int>> getPositions() {
    HashMap<ArtistGlobalInfo, List<int>> output = HashMap();
    for (MapEntry<ArtistGlobalInfo, Building> mapEntry in _artistGlobalInfoToBuildingMap.entries) {
      var building = mapEntry.value;
      var position = building.position;
      output[mapEntry.key] = [position.x, position.y, building.getHeight()];
    }
    return output;
  }

  @override
  void moveBuilding(ArtistGlobalInfo artistGlobalInfo,  int x, int y) {
    // TODO: implement moveBuilding
    throw UnimplementedError();
  }

  @override
  void placeNewBuilding(ArtistGlobalInfo artistGlobalInfo, int height) {
    if (_artistGlobalInfoToBuildingMap.containsKey(artistGlobalInfo)) {
      throw Exception("Artist already in position state");
    }
    Building buildingToPlace = Building(artistGlobalInfo, height, _getPositionGenre(artistGlobalInfo.primaryGenre));
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
    if (squareOccupied) {_findSpotAndPlaceBuilding(oldBuilding, previousGenres);}
  }

  void _placeBuildingInNewSquare(Building building, Pixel pixel) {
    building.setPosition(pixel);
    _removeFromAdjacentEmpties(pixel);
    _positionMap[pixel] = building;
    building.positionGenre.addOwnBuildingToSquare(building);
    for (int xDiff = -1; xDiff <=1; xDiff +=2) {
      for (int yDiff = -1; yDiff <=1; yDiff += 2) {
        _adjustAdjacents(pixel, Pixel(pixel.x+xDiff, pixel.y + yDiff));
      }
    }
  }

  void _adjustAdjacents(Pixel newBuildingPosition, Pixel adjacentSquare) {
    PositionGenre newPositionGenre = _positionMap[newBuildingPosition]!.positionGenre;
    if (_positionMap.containsKey(adjacentSquare)) {
      PositionGenre adjacentPositionGenre = _positionMap[adjacentSquare]!.positionGenre;
      adjacentPositionGenre.occupyAdjacentSquare(newBuildingPosition, newPositionGenre);
      newPositionGenre.occupyAdjacentSquare(adjacentSquare, adjacentPositionGenre);
    }
    else {
      newPositionGenre.addToAdjacentEmpties(adjacentSquare);
      _addToAdjacentEmpties(adjacentSquare);
    }
  }

  double _getDistanceSquare(Pixel pixel) {
    return (pow(pixel.x-_origin.x, 2) + pow(pixel.y-_origin.y, 2)) as double;
  }


  void _addToAdjacentEmpties(Pixel pixel) {
    double distance = _getDistanceSquare(pixel);
    if (!_adjacentEmpties.containsKey(distance)) {
      Set<Pixel> pixelSet = HashSet();
      _adjacentEmpties[distance] = pixelSet;
    }
    _adjacentEmpties[distance]!.add(pixel);
  }

  void _removeFromAdjacentEmpties(Pixel pixel) {
    double distance = _getDistanceSquare(pixel);
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








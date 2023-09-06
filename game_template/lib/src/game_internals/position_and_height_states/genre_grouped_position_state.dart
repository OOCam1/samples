import 'dart:collection';
import 'dart:math';

import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/genre.dart';
import 'package:game_template/src/game_internals/position_and_height_states/obstacle_adder.dart';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'package:game_template/src/game_internals/position_and_height_states/position_state.dart';

import '../models/positioned_building_info.dart';
import '../models/unpositioned_building_info.dart';
import 'building.dart';
import 'grid_item.dart';
import 'position_genre.dart';

///adding stuff
///flag them each as new, place them on pure position map
///get obstacle positions
///extend rivers/roads
///adjust new buildings for new and old obstacles
///cut down obstacles to grid size

//first make obstacles push right/left and up/down
class GenreGroupedPositionState implements PositionState {




  static Future<GenreGroupedPositionState> create(Set<PositionedBuildingInfo> oldBuildings) async {
    var obstacleAdder = await ObstacleAdder.create(_origin);
    return GenreGroupedPositionState._internal(obstacleAdder, oldBuildings);
  }

  //map of location to building
  final Map<Pixel, Building> _purePositionMap = HashMap();
  //map of artist to corresponding building
  final HashMap<ArtistGlobalInfo, Building> _artistGlobalInfoToBuildingMap =
      HashMap();

  late final ObstacleAdder _obstacleAdder;

  final HashMap<Genre, PositionGenre> _genreToPositionGenre = HashMap();

  //Set of empty adjacent squares
  final SplayTreeMap<int, Set<Pixel>> _adjacentEmpties = SplayTreeMap();
  //Central square
  static final Pixel _origin = Pixel(0, 0);


  late int _xPureBuildingMin;
  late int _xMax;
  late int _yMin;
  late int _yMax;

  @override
  void clear() {
    _purePositionMap.clear();
    _obstacleAdder.clear();
    _artistGlobalInfoToBuildingMap.clear();
    _genreToPositionGenre.clear();
    var newSet = HashSet<Pixel>();
    newSet.add(_origin);
    _adjacentEmpties.clear();
    _adjacentEmpties[0] = newSet;
  }

  GenreGroupedPositionState._internal(this._obstacleAdder, Set<PositionedBuildingInfo> buildingInfos) {
    var newSet = HashSet<Pixel>()..add(_origin);

    _adjacentEmpties[0] = newSet;
    _xPureBuildingMin = _origin.x;
    _xMax = _origin.x;
    _yMin = _origin.y;
    _yMax = _origin.y;
    _initialiseOldBuildings(buildingInfos);
  }
  //
  // @override
  // void changeHeight(ArtistGlobalInfo artistGlobalInfo, double score) {
  //   if (!_artistGlobalInfoToBuildingMap.containsKey(artistGlobalInfo)) {
  //     throw Exception("Artist info not in position state");
  //   }
  //   Building building = _artistGlobalInfoToBuildingMap[artistGlobalInfo]!;
  //   if (score < building.score) {
  //     throw Exception("New height of building smaller than old height");
  //   }
  //   _artistGlobalInfoToBuildingMap[artistGlobalInfo]!.buildingInfo.score =
  //       score;
  // }

  @override
  Set<PositionedBuildingInfo> getPositionsAndHeightsOfBuildings() {
    HashSet<PositionedBuildingInfo> output = HashSet();
    _obstacleAdder.setup(_purePositionMap);
    var obstacleAdjustedBuildingMap =
        _obstacleAdder.getObstacleAdjustedBuildingPositions();
    for (MapEntry<Pixel, Building> mapEntry
        in obstacleAdjustedBuildingMap.entries) {
      output.add(mapEntry.value
          .toPositionedBuildingInfo(mapEntry.key.x, mapEntry.key.y));
    }
    return output;
  }

  @override
  Map<List<int>, GridItem> getPositionsOfItems() {
    HashMap<List<int>, GridItem> output = HashMap();
    Map<Pixel, GridItem> obstacleAdjustedPositionMap =
        _obstacleAdder.getObstacleAdjustedGridItemPositions();
    for (MapEntry<Pixel, GridItem> mapEntry
        in obstacleAdjustedPositionMap.entries) {
      output[mapEntry.key.toList()] = mapEntry.value;
    }
    return output;
  }

  @override
  void placeBuildings(Set<BuildingInfo> buildings) {
    buildings.removeWhere((element) =>
    _artistGlobalInfoToBuildingMap.containsKey(element.artistGlobalInfo));
    HashMap<Genre, Set<BuildingInfo>> districtBuildings = HashMap();
    for (BuildingInfo buildingInfo in buildings) {
      var artistGlobalInfo = buildingInfo.artistGlobalInfo;
      var primaryGenre = artistGlobalInfo.primaryGenre;
      if (!districtBuildings.containsKey(artistGlobalInfo.primaryGenre)) {
        districtBuildings[primaryGenre] = HashSet();
      }
      districtBuildings[primaryGenre]!.add(buildingInfo);
    }
    var districtBuildingEntryList = districtBuildings.entries.toList();
    districtBuildingEntryList
        .sort((a, b) => -a.value.length.compareTo(b.value.length));
    for (MapEntry<Genre, Set<BuildingInfo>> mapEntry
        in districtBuildingEntryList) {
      for (BuildingInfo buildingInfo in mapEntry.value) {
        _placeNewBuilding(buildingInfo);
      }
    }

    // HashMap<PositionGenre, HashSet<Building>> genreToBuildings = HashMap();
    // for (MapEntry<ArtistGlobalInfo, Building> mapEntry
    //     in _artistGlobalInfoToBuildingMap.entries) {
    //   var positionGenre = _genreToPositionGenre[mapEntry.key.primaryGenre]!;
    //   if (!genreToBuildings.containsKey(positionGenre)) {
    //     genreToBuildings[positionGenre] = HashSet();
    //   }
    //   genreToBuildings[positionGenre]!.add(mapEntry.value);
    // }

    // for (MapEntry<PositionGenre, HashSet<Building>> mapEntry
    //     in genreToBuildings.entries) {
    //   mapEntry.key.organiseByHeight(mapEntry.value);
    // }
    // HashMap<Pixel, Building> newPositionMap = HashMap();
    // for (Building building in _purePositionMap.values) {
    //   newPositionMap[building.position] = building;
    // }
    // _purePositionMap.clear();
    // _purePositionMap.addAll(newPositionMap);
  }

  @override
  Set<PositionedBuildingInfo> getPreObstaclePositions() {
    HashSet<PositionedBuildingInfo> output = HashSet();
    for (MapEntry<Pixel, Building> entry in _purePositionMap.entries) {
      output.add(PositionedBuildingInfo(entry.value.buildingInfo, entry.key.x, entry.key.y));
    }
    return output;
  }
  void _initialiseOldBuildings(Set<PositionedBuildingInfo> oldBuildings) {
    for (PositionedBuildingInfo buildingInfo in oldBuildings) {
      PositionGenre positionGenre = _getPositionGenre(buildingInfo.artistGlobalInfo.primaryGenre);
      var building = Building(buildingInfo, positionGenre);
      _artistGlobalInfoToBuildingMap[buildingInfo.artistGlobalInfo] = building;
      _placeBuildingInNewSquare(building, Pixel(buildingInfo.x, buildingInfo.y));
    }
  }

  void _placeNewBuilding(BuildingInfo buildingInfo) {
    if (_artistGlobalInfoToBuildingMap
        .containsKey(buildingInfo.artistGlobalInfo)) {
      throw Exception("Artist already in position state");
    }
    Building buildingToPlace = Building(buildingInfo,
        _getPositionGenre(buildingInfo.artistGlobalInfo.primaryGenre));
    _artistGlobalInfoToBuildingMap[buildingInfo.artistGlobalInfo] =
        buildingToPlace;
    _findSpotAndPlaceBuilding(buildingToPlace, HashSet());
  }

  PositionGenre _getPositionGenre(Genre genre) {
    if (_genreToPositionGenre.containsKey(genre)) {
      return _genreToPositionGenre[genre]!;
    }
    var positionGenre = PositionGenre(_generateDistrictOrigins());
    _genreToPositionGenre[genre] = positionGenre;
    return positionGenre;
  }

  void _findSpotAndPlaceBuilding(
      Building building, HashSet<PositionGenre> previousGenres) {
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
    PositionGenre newPositionGenre =
        _purePositionMap[newBuildingPosition]!.positionGenre;
    if (_purePositionMap.containsKey(adjacentSquare)) {
      PositionGenre adjacentPositionGenre =
          _purePositionMap[adjacentSquare]!.positionGenre;
      adjacentPositionGenre.handleAdjacentSquareGettingOccupied(
          newBuildingPosition, newPositionGenre);
      newPositionGenre.handleAdjacentSquareGettingOccupied(
          adjacentSquare, adjacentPositionGenre);
    } else {
      newPositionGenre.addToAdjacentEmpties(adjacentSquare);
      _addToAdjacentEmpties(adjacentSquare);
    }
  }

  int _getDistanceSquare(Pixel pixel) {
    return (pow(pixel.x - _origin.x, 2) + pow(pixel.y - _origin.y, 2)) as int;
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

  @override
  int get xMax => _xMax;
  @override
  int get xMin => _xPureBuildingMin;

  @override
  int get yMin => _yMin;

  @override
  int get yMax => _yMax;
}



import 'dart:collection';
import 'dart:math';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'building.dart';
class PositionGenre {

  final HashSet<Pixel> _occupied = HashSet();
  final SplayTreeMap<int, Set<Pixel>> _adjacentEmpties = SplayTreeMap();
  final SplayTreeMap<int, Map<Pixel, PositionGenre>> _adjacentOccupied = SplayTreeMap();
  late Pixel _origin;
  late int xMin;
  late int yMin;
  late int xMax;
  late int yMax;
  //this origin may change as the district may be pushed away from original position
  PositionGenre(Pixel origin) {_origin = origin; addToAdjacentEmpties(origin);}


  Pixel get origin => _origin;

  Pixel findPosition(HashSet<PositionGenre> previousGenres) {
    for (Set<Pixel> pixelSet in _adjacentEmpties.values) {
      for (Pixel pixel in pixelSet) {
        return pixel;
      }
    }
    for (Map<Pixel, PositionGenre> pixelMap in _adjacentOccupied.values) {
      for (MapEntry<Pixel, PositionGenre> pixelMapEntry in pixelMap.entries) {
        if (!previousGenres.contains(pixelMapEntry.value)) {
          return pixelMapEntry.key;
        }
      }
    }
    throw Exception("Adjacent location not found");
  }


  int _getDistanceSquare(Pixel p) {
    return (pow(p.x-_origin.x, 2) + pow(p.y-_origin.y, 2)) as int;
  }

  void handleAdjacentSquareGettingOccupied(Pixel p, PositionGenre pg) {
    if (pg != this) {
      int squareDistance = _getDistanceSquare(p);
      if (!_adjacentOccupied.containsKey(squareDistance)) {
        HashMap<Pixel, PositionGenre> newMap = HashMap();
        _adjacentOccupied[squareDistance] = newMap;
      }
      _adjacentOccupied[squareDistance]![p] = pg;

    }
    _removeAdjacentEmpties(p);
  }

  void dealWithOwnBuildingRemovedFromSpace(Pixel pixel) {
    _occupied.remove(pixel);
    for (Pixel adjacentPixel in pixel.getAdjacents()) {
      if (!_doesSquareHaveAdjacentOwnedBuilding(adjacentPixel)) {
        _removeFromAdjacentOccupied(adjacentPixel);
        _removeAdjacentEmpties(adjacentPixel);
      }
    }
  }

  void addOwnBuildingToSquare(Building building) {
    Pixel pixel = building.position;
    _removeAdjacentEmpties(pixel);
    _removeFromAdjacentOccupied(pixel);
    _occupied.add(pixel);
  }


  void addToAdjacentEmpties(Pixel p) {
    var distanceSquare = _getDistanceSquare(p);
    if (!_adjacentEmpties.containsKey(distanceSquare)) {
      _adjacentEmpties[distanceSquare] = <Pixel>{};
    }
    _adjacentEmpties[distanceSquare]!.add(p);
  }

  bool _doesSquareHaveAdjacentOwnedBuilding(Pixel pixel) {
    for (Pixel adjacentPixel in pixel.getAdjacents())  {
      if (_occupied.contains(adjacentPixel)) {
        return true;
      }
    }
    return false;
  }

  void _removeFromAdjacentOccupied(Pixel p) {
    var distanceSquare = _getDistanceSquare(p);
    if (_adjacentOccupied.containsKey(distanceSquare)) {
      _adjacentOccupied[distanceSquare]!.remove(p);
    }
  }

  void _removeAdjacentEmpties(Pixel p) {
    var distanceSquare = _getDistanceSquare(p);
    if (_adjacentEmpties.containsKey(distanceSquare)) {
      _adjacentEmpties[distanceSquare]!.remove(p);
    }
  }
}
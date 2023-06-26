

import 'dart:collection';
import 'dart:math';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'building.dart';
class PositionGenre {
  final SplayTreeMap<double, Set<Pixel>> _adjacentEmpties = SplayTreeMap();
  final SplayTreeMap<double, Map<Pixel, PositionGenre>> _adjacentOccupied = SplayTreeMap();
  late final Pixel _origin;


  PositionGenre(this._origin);


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


  double _getDistanceSquare(Pixel p) {
    return (pow(p.x-_origin.x, 2) + pow(p.y-_origin.y, 2)) as double;
  }

  void occupyAdjacentSquare(Pixel p, PositionGenre pg) {
    if (pg != this) {
      double squareDistance = _getDistanceSquare(p);
      if (!_adjacentOccupied.containsKey(squareDistance)) {
        HashMap<Pixel, PositionGenre> newMap = HashMap();
        _adjacentOccupied[squareDistance] = newMap;
      }
      _adjacentOccupied[squareDistance]![p] = pg;

    }
    _removeAdjacentEmpties(p);
  }

  void addOwnBuildingToSquare(Building building) {
    Pixel pixel = building.position;
    _removeAdjacentEmpties(pixel);
    _removeFromAdjacentOccupied(pixel);
  }

  void _removeFromAdjacentOccupied(Pixel p) {
    double distanceSquare = _getDistanceSquare(p);
    if (_adjacentOccupied.containsKey(distanceSquare)) {
      _adjacentOccupied[distanceSquare]!.remove(p);
    }
  }

  void addToAdjacentEmpties(Pixel p) {
    double distanceSquare = _getDistanceSquare(p);
    if (!_adjacentEmpties.containsKey(distanceSquare)) {
      _adjacentEmpties[distanceSquare] = Set<Pixel>();
    }
    _adjacentEmpties[distanceSquare]!.add(p);
  }

  void _removeAdjacentEmpties(Pixel p) {
    double distanceSquare = _getDistanceSquare(p);
    if (_adjacentEmpties.containsKey(distanceSquare)) {
      _adjacentEmpties[distanceSquare]!.remove(p);
    }
  }
}
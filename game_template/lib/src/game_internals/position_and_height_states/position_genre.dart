

import 'dart:collection';
import 'dart:math';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'building.dart';
class PositionGenre {

  final HashSet<Pixel> _occupied = HashSet();
  final HashSet<Pixel> _adjacentEmpties = HashSet();
  final HashMap<Pixel, PositionGenre> _adjacentOccupied = HashMap();
  late Pixel _origin;
  late int _xMin;
  late int _yMin;
  late int _xMax;
  late int _yMax;
  //this origin may change as the district may be pushed away from original position
  PositionGenre(Pixel origin) {
    _origin = origin;
    addToAdjacentEmpties(origin);
    _xMin = origin.x;
    _xMax = origin.x;
    _yMin = origin.y;
    _yMax = origin.y;
  }



  Pixel findPosition(HashSet<PositionGenre> previousGenres) {
    int minDistance = -1;
    late Pixel selected;
    bool found = false;
    for (Pixel pixel in _adjacentEmpties) {
      var squareDistance = _getDistanceSquare(pixel);
      if (minDistance == -1 || squareDistance <minDistance )  {
        selected = pixel;
        minDistance = _getDistanceSquare(pixel);
        found = true;
      }
    }
    if (found) {return selected;}

    for (MapEntry<Pixel, PositionGenre> pixelMapEntry in _adjacentOccupied.entries) {
      var squareDistance = _getDistanceSquare(pixelMapEntry.key);
      if (!previousGenres.contains(pixelMapEntry.value) && (minDistance == -1 || squareDistance <minDistance )) {
        minDistance = squareDistance;
        selected = pixelMapEntry.key;
        found = true;
      }

    }
    if (found) {return selected;}
    throw Exception("Adjacent location not found");
  }

  void _setOrigin() {
    int xLocation = (_xMax + _xMin)~/2;
    int yLocation = (_yMax + _yMin)~/2;
    _origin = Pixel(xLocation, yLocation);
  }


  int _getDistanceSquare(Pixel p) {
    return (pow(p.x-_origin.x, 2) + pow(p.y-_origin.y, 2)) as int;
  }

  void handleAdjacentSquareGettingOccupied(Pixel p, PositionGenre pg) {
    if (pg != this) {
      _adjacentOccupied[p] = pg;

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

    //update extreme pixels
    if (_xMax == pixel.x || _xMin == pixel.x || _yMax == pixel.y || _yMin == pixel.y) {
      HashSet<int> xLocations = HashSet();
      HashSet<int> yLocations = HashSet();
      for (Pixel p in _occupied) {
        xLocations.add(p.x);
        yLocations.add(p.y);
      }
      _xMax = xLocations.reduce(max);
      _xMin = xLocations.reduce(min);
      _yMax = yLocations.reduce(max);
      _yMin = yLocations.reduce(min);
    }
    _setOrigin();
  }

  void addOwnBuildingToSquare(Building building) {
    Pixel pixel = building.position;
    _removeAdjacentEmpties(pixel);
    _removeFromAdjacentOccupied(pixel);
    _occupied.add(pixel);

    //update extreme pixels
    _xMax = max(pixel.x, _xMax);
    _xMin = min(pixel.x, _xMin);
    _yMax = max(pixel.y, _yMax);
    _yMin = min(pixel.y, _yMin);
    _setOrigin();
  }

  void organiseByHeight(Set<Building> buildings) {
    var buildingList = buildings.toList();
    buildingList.sort((a,b) => -a.height.compareTo(b.height));
    HashMap<int, Set<Pixel>> availablePositions = HashMap();
    for (Pixel pixel in _occupied) {
      var distanceSquare = _getDistanceSquare(pixel);
      if (!availablePositions.containsKey(distanceSquare)) {
        availablePositions[distanceSquare] = HashSet();
      }
      availablePositions[distanceSquare]!.add(pixel);
    }
    for (Building building in buildingList) {
      for (Set<Pixel> pixelSet in availablePositions.values ) {
        if (pixelSet.isNotEmpty) {
          var newPosition = pixelSet.toList()[0];
          pixelSet.remove(newPosition);
          building.setPosition(newPosition);
          break;
        }
      }
    }
  }


  void addToAdjacentEmpties(Pixel p) {

    _adjacentEmpties.add(p);
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
    if (_adjacentOccupied.containsKey(p)) {
      _adjacentOccupied.remove(p);
    }
  }

  void _removeAdjacentEmpties(Pixel p) {
    if (_adjacentEmpties.contains(p)) {
      _adjacentEmpties.remove(p);
    }
  }
}
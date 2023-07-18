import 'dart:collection';
import 'dart:math';

import '../models/artist_global_info.dart';
import 'building.dart';
import 'grid_item.dart';
import 'pixel.dart';

///purpose of this class is to take in a pure position map of pixel to building,
///and then return an obstacle adjusted map from pixel to building and a map from pixel to griditem

///the position of all obstacles and buildings should remain constant no matter how many obstacles are added after

class ObstacleAdder {
  static const int _minDistanceBetweenRoads = 3;
  static const int _maxDistanceBetweenRoads = 5;
  static const int _borderSize = 1;
  static const _roadsEnabled = true;
  static const _boundariesEnabled = true;
  bool setupDone = false;

  final Map<Pixel, GridItem> _obstacleAdjustedPositionMap = HashMap();
  final Map<Pixel, Building> _obstacleAdjustedBuildingMap = HashMap();
  final HashSet<int> _leftPushingRoadXPositions = HashSet();
  final HashSet<int> _rightPushingRoadXPositions = HashSet();
  final HashSet<int> _upPushingRoadYPositions = HashSet();
  final HashSet<int> _downPushingRoadYPositions = HashSet();

  final HashSet<Pixel> _leftPushingObstaclePositions = HashSet();
  final HashSet<Pixel> _rightPushingObstaclePositions = HashSet();
  final HashSet<Pixel> _downPushingObstaclePositions = HashSet();
  final HashSet<Pixel> _upPushingObstaclePositions = HashSet();

  final Pixel _origin;

  ObstacleAdder(this._origin);

  void clear() {
    _obstacleAdjustedBuildingMap.clear();
    _obstacleAdjustedPositionMap.clear();
  }

  Map<Pixel, Building> getObstacleAdjustedBuildingPositions() {
    return _obstacleAdjustedBuildingMap;
  }

  Map<Pixel, GridItem> getObstacleAdjustedGridItemPositions() {
    return _obstacleAdjustedPositionMap;
  }

  void setup(Map<Pixel, Building> purePositionMap) {
    _obstacleAdjustedBuildingMap.addAll(purePositionMap);
    for (var mapEntry in purePositionMap.entries) {
      _obstacleAdjustedPositionMap[mapEntry.key] = mapEntry.value.toGridItem();
    }
    if (_roadsEnabled) {
      _addRoads();
    }
    // _cutObstacleSquaresToWithinBorder();
    // if (_boundariesEnabled) {
    //   _addBoundaries();
    // }

    assert(purePositionMap.length == _obstacleAdjustedBuildingMap.length);
    for (Pixel p in _obstacleAdjustedBuildingMap.keys) {
      assert(_obstacleAdjustedPositionMap[p]!.isBuilding());
    }
    for (var mapEntry in _obstacleAdjustedPositionMap.entries) {
      if (mapEntry.value.isBuilding()) {
        assert(_obstacleAdjustedBuildingMap.containsKey(mapEntry.key));
      }
    }
  }

  void _addBoundaries() {
    for (Pixel pixel in _obstacleAdjustedBuildingMap.keys) {
      for (int x = pixel.x - _borderSize; x <= pixel.x + _borderSize; x++) {
        for (int y = pixel.y - _borderSize; y <= pixel.y + _borderSize; y++) {
          var newPosition = Pixel(x, y);
          if (!_obstacleAdjustedPositionMap.containsKey(newPosition)) {
            _obstacleAdjustedPositionMap[newPosition] = GridItem.boundary;
          }
        }
      }
    }
  }

  void _addRoads() {
    List<List<Set<Pixel>>> roadSquares = _generateRoadSquares();
    _addObstaclesToSystem(roadSquares[0][0], roadSquares[0][1],
        roadSquares[1][0], roadSquares[1][1]);
    for (var setList in roadSquares) {
      for (Set<Pixel> pixelSet in setList) {
        for (Pixel pixel in pixelSet) {
          _obstacleAdjustedPositionMap[pixel] = GridItem.road;
        }
      }
    }
  }

  void _addObstaclesToSystem(
      Iterable<Pixel> downPushingObstaclePositionsToAdd,
      Iterable<Pixel> upPushingObstaclePositionsToAdd,
      Iterable<Pixel> leftPushingObstaclePositionsToAdd,
      Iterable<Pixel> rightPushingObstaclePositionsToAdd) {
    var existingSets = [
      _downPushingObstaclePositions,
      _upPushingObstaclePositions,
      _leftPushingObstaclePositions,
      _rightPushingObstaclePositions
    ];
    List<Set<Pixel>> newSets = [
      downPushingObstaclePositionsToAdd.toSet(),
      upPushingObstaclePositionsToAdd.toSet(),
      leftPushingObstaclePositionsToAdd.toSet(),
      rightPushingObstaclePositionsToAdd.toSet()
    ];
    for (int i = 0; i < 4; i++) {
      newSets[i] = newSets[i].difference(existingSets[i]);
      existingSets[i].addAll(newSets[i]);
    }
    _adjustPositionsFromObstacles(
        newSets[0], newSets[1], newSets[2], newSets[3]);
  }

  List<List<int>> _getExtremes(Iterable<Pixel> positions) {
    if (positions.isEmpty) {
      return [
        [0, 0],
        [0, 0]
      ];
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
    return [
      [xMin, xMax],
      [yMin, yMax]
    ];
  }

  //generates 1d coords for locations of road based on current road positions
  //axis = 0 for x coords of roads, axis = 1 for y coords of roads
  List<Iterable<int>> _generate1DRoadPositions(
      int minPosition, int maxPosition, int axis) {
    Set<int> increasePushingPositions;
    Set<int> decreasePushingPositions;
    if (axis == 0) {
      increasePushingPositions = _rightPushingRoadXPositions;
      decreasePushingPositions = _leftPushingRoadXPositions;
    } else {
      increasePushingPositions = _upPushingRoadYPositions;
      decreasePushingPositions = _downPushingRoadYPositions;
    }
    int decreaseUpperLimit = (decreasePushingPositions.isNotEmpty)
        ? decreasePushingPositions.reduce(max)
        : _origin.toList()[axis];
    int increaseLowerLimit = (increasePushingPositions.isNotEmpty)
        ? increasePushingPositions.reduce(min)
        : _origin.toList()[axis];
    var random = Random();
    var lastPosition = minPosition;
    var maxPositionOfRoad = maxPosition;

    var interval =
        random.nextInt(_maxDistanceBetweenRoads - _minDistanceBetweenRoads) +
            _minDistanceBetweenRoads;
    lastPosition += interval;
    //lmao get fucked
    while (lastPosition < decreaseUpperLimit) {
      decreasePushingPositions.add(lastPosition);
      interval =
          random.nextInt(_maxDistanceBetweenRoads - _minDistanceBetweenRoads) +
              _minDistanceBetweenRoads;
      lastPosition += interval;
    }

    if (increasePushingPositions.isNotEmpty) {
      interval =
          random.nextInt(_maxDistanceBetweenRoads - _minDistanceBetweenRoads) +
              _minDistanceBetweenRoads;
      lastPosition = increaseLowerLimit + interval;
    }

    while (lastPosition < maxPositionOfRoad) {
      increasePushingPositions.add(lastPosition);
      interval =
          random.nextInt(_maxDistanceBetweenRoads - _minDistanceBetweenRoads) +
              _minDistanceBetweenRoads;
      lastPosition += interval;
    }
    return [decreasePushingPositions, increasePushingPositions];
  }

  ///returns in order
  ///[[downpushing roads, uppushing roads], [leftpushing roads, rightpushing roads]]
  List<List<Set<Pixel>>> _generateRoadSquares() {
    List<HashSet<Pixel>> upAndDownPushingRoadSquares = [HashSet(), HashSet()];
    List<HashSet<Pixel>> leftAndRightPushingRoadSquares = [
      HashSet(),
      HashSet()
    ];
    List<List<int>> currentLimits =
        _getExtremes(_obstacleAdjustedBuildingMap.keys);
    int xMinWithObstacles = currentLimits[0][0];
    int xMaxWithObstacles = currentLimits[0][1];
    int yMinWithObstacles = currentLimits[1][0];
    int yMaxWithObstacles = currentLimits[1][1];
    List<Iterable<int>> verticalRoadPositions =
        _generate1DRoadPositions(xMinWithObstacles, xMaxWithObstacles, 0);
    List<Iterable<int>> horizontalRoadPositions =
        _generate1DRoadPositions(yMinWithObstacles, yMaxWithObstacles, 1);

    for (int index = 0; index < 2; index++) {
      for (int x in verticalRoadPositions[index]) {
        for (int y = yMinWithObstacles - _borderSize;
            y <=
                yMaxWithObstacles +
                    horizontalRoadPositions.length +
                    _borderSize;
            y++) {
          leftAndRightPushingRoadSquares[index].add(Pixel(x, y));
        }
      }
    }
    for (int index = 0; index < 2; index++) {
      for (int y in horizontalRoadPositions[index]) {
        for (int x = xMinWithObstacles - _borderSize;
            x <= xMaxWithObstacles + verticalRoadPositions.length + _borderSize;
            x++) {
          upAndDownPushingRoadSquares[index].add(Pixel(x, y));
        }
      }
    }
    //verticalRoadSquares.toSet().union(horizontalRoadSquares.toSet());
    return [upAndDownPushingRoadSquares, leftAndRightPushingRoadSquares];
  }

  HashMap<int, List<int>> _generate2DLimitsForEachLine(int rowOrColumn) {
    if (rowOrColumn != 0 && rowOrColumn != 1) {
      throw Error();
    }
    HashMap<int, List<int>> output = HashMap();
    var otherIndex = (rowOrColumn + 1) % 2;
    HashMap<int, List<int>> buildingLineToPosition = HashMap();
    //generate line to position of building positions

    List<int> minLimits = [0, 0];
    List<int> maxLimits = [0, 0];
    var currentLimits = _getExtremes(_obstacleAdjustedPositionMap.keys);
    minLimits = [currentLimits[0][0], currentLimits[1][0]];
    maxLimits = [currentLimits[0][1], currentLimits[1][1]];
    // print('buildings');
    // for (Pixel position in _obstacleAdjustedBuildingMap.keys) {
    //
    // }

    for (Pixel position in _obstacleAdjustedPositionMap.keys) {
      if (_obstacleAdjustedPositionMap[position] == GridItem.building) {}
    }
    //empty rows/columns should still have a key that points to empty list, rather than no key
    for (Pixel position in _obstacleAdjustedBuildingMap.keys) {
      if (!buildingLineToPosition.containsKey(position.toList()[rowOrColumn])) {
        buildingLineToPosition[position.toList()[rowOrColumn]] = [];
      }
      buildingLineToPosition[position.toList()[rowOrColumn]]!
          .add(position.toList()[otherIndex]);
    }

    for (int line = minLimits[rowOrColumn] - 1;
        line <= maxLimits[rowOrColumn] + 1;
        line++) {
      if (!buildingLineToPosition.containsKey(line)) {
        output[line] = [10, -10];
      } else {
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
    Map<int, List<int>> yToRowPositions = _generate2DLimitsForEachLine(1);
    HashSet<Pixel> toRemove = HashSet();
    for (MapEntry<Pixel, GridItem> position
        in _obstacleAdjustedPositionMap.entries) {
      if (position.value != GridItem.building) {
        int x = position.key.x;
        int y = position.key.y;

        var leftYLimits = xToColumnPositions[x - 1]!;
        var rightYLimits = xToColumnPositions[x + 1]!;
        var bottomXLimits = yToRowPositions[y - 1]!;
        var topXLimits = yToRowPositions[y + 1]!;

        bool positionInLimit(int number, List<int> limits) {
          return ((number >= limits[0] - _borderSize) &&
              (number <= limits[1] + _borderSize));
        }

        var xInXLimits =
            positionInLimit(x, bottomXLimits) || positionInLimit(x, topXLimits);
        var yInYLimits =
            positionInLimit(y, leftYLimits) || positionInLimit(y, rightYLimits);
        if (!(xInXLimits || yInYLimits)) {
          toRemove.add(position.key);
        }
      }
    }
    for (Pixel p in toRemove) {
      _obstacleAdjustedPositionMap.remove(p);
    }
  }

  //horizontal obstacles actually must be the union of vertical obstacles and horizontal obstacles since we shift vertically first
  //and want to avoid shifting buildings horizontally into vertical obstacles.

  ///we want to just shift the positions of buildings
  ///this means in the following, whenever we say bshift by c, it means move increment the building c spaces
  ///NOT INCLUDING the spaces we encounter that have obstacles. i.e only squares with other buildings in.
  ///
  ///first shift the y of each building:
  ///
  ///calculate necessary y offset:
  ///calculate number of down obstacles in the x column with value >= y
  ///offset is -this
  ///if offset == 0:
  /// calculate number of up obstacles in the x column with value <= y
  /// offset = this
  ///
  /// then bshift each building's y by this amount
  ///
  /// do the same for each building's x, by considering its new row
  ///
  /// produce map from old pixel to new pixel, then adjust the buildings in positionMap and buildingMap

  void _adjustPositionsFromObstacles(
      Set<Pixel> newDownPushingObstacles,
      Set<Pixel> newUpPushingObstacles,
      Set<Pixel> newLeftPushingObstacles,
      Set<Pixel> newRightPushingObstacles) {
    Map<Pixel, Pixel> oldToNew = _getPurePixelToAdjustedPixel(
        newDownPushingObstacles,
        newUpPushingObstacles,
        newLeftPushingObstacles,
        newRightPushingObstacles);

    HashMap<Pixel, Building> newBuildingMap = HashMap();
    HashMap<Pixel, GridItem> newPositionMap = HashMap();
    for (var mapEntry in _obstacleAdjustedBuildingMap.entries) {
      newBuildingMap[oldToNew[mapEntry.key]!] = mapEntry.value;
    }
    for (var mapEntry in _obstacleAdjustedPositionMap.entries) {
      if (mapEntry.value.isBuilding()) {
        newPositionMap[oldToNew[mapEntry.key]!] = mapEntry.value;
      } else {
        newPositionMap[mapEntry.key] = mapEntry.value;
      }
    }

    _obstacleAdjustedBuildingMap.clear();
    _obstacleAdjustedPositionMap.clear();
    _obstacleAdjustedBuildingMap.addAll(newBuildingMap);
    _obstacleAdjustedPositionMap.addAll(newPositionMap);
  }

  HashMap<Pixel, Pixel> _getPurePixelToAdjustedPixel(
      Set<Pixel> newDownPushingObstacles,
      Set<Pixel> newUpPushingObstacles,
      Set<Pixel> newLeftPushingObstacles,
      Set<Pixel> newRightPushingObstacles) {
    Set<Pixel> totalObstaclePositions = _downPushingObstaclePositions
        .union(_upPushingObstaclePositions)
        .union(_leftPushingObstaclePositions)
        .union(_rightPushingObstaclePositions);

    HashMap<Pixel, Pixel> adjustPositionsAlongOneAxis(
        Set<Pixel> pixels,
        int axis,
        Set<Pixel> decreasePushObstacles,
        Set<Pixel> increasePushObstacles,
        Set<Pixel> totalObstaclesToAvoid) {
      var otherAxis = (axis + 1) % 2;
      HashMap<Pixel, Pixel> output = HashMap();
      HashMap<int, Set<int>> axisCoordToIncreasePositions =
          _generatePositionToSetPositions(increasePushObstacles, otherAxis);
      HashMap<int, Set<int>> axisCoordToDecreasePositions =
          _generatePositionToSetPositions(decreasePushObstacles, otherAxis);

      for (Pixel pixel in pixels) {
        int indexPosition = pixel.toList()[otherAxis];

        Set<int> decreasePositions =
            axisCoordToDecreasePositions[indexPosition] ?? HashSet();

        Set<int> increasePositions =
            axisCoordToIncreasePositions[indexPosition] ?? HashSet();

        int offset = _calculateBuildingPositionOffsetFromObstacles(
            pixel.toList()[axis], decreasePositions, increasePositions);

        Pixel newPixel = _shiftPixelOverBuildings(
            totalObstaclesToAvoid, pixel, offset, axis);
        output[pixel] = newPixel;
      }

      return output;
    }

    HashSet<Pixel> pixelsToChange = HashSet();
    for (var mapEntry in _obstacleAdjustedPositionMap.entries) {
      if (mapEntry.value.isBuilding()) {
        pixelsToChange.add(mapEntry.key);
      }
    }

    HashMap<Pixel, Pixel> currentToHorizontallyAdjusted =
        adjustPositionsAlongOneAxis(
            pixelsToChange,
            0,
            newLeftPushingObstacles,
            newRightPushingObstacles,
            _leftPushingObstaclePositions
                .union(_rightPushingObstaclePositions));

    print(currentToHorizontallyAdjusted);
    print('next');

    HashMap<Pixel, Pixel> horizontallyAdjustedToFullyAdjusted =
        adjustPositionsAlongOneAxis(
            currentToHorizontallyAdjusted.values.toSet(),
            1,
            newDownPushingObstacles,
            newUpPushingObstacles,
            totalObstaclePositions);
    print(horizontallyAdjustedToFullyAdjusted);
    HashMap<Pixel, Pixel> oldBuildingPixelToNew = HashMap();
    for (MapEntry<Pixel, Pixel> mapEntry
        in currentToHorizontallyAdjusted.entries) {
      oldBuildingPixelToNew[mapEntry.key] =
          horizontallyAdjustedToFullyAdjusted[mapEntry.value]!;
    }

    return oldBuildingPixelToNew;
  }

  int _calculateBuildingPositionOffsetFromObstacles(
      int positionToOffset,
      Iterable<int> decreasePushObstacles,
      Iterable<int> increasePushObstacles) {
    int offset = 0;
    for (int i in decreasePushObstacles) {
      offset -= (positionToOffset <= i) ? 1 : 0;
    }
    if (offset != 0) {
      return offset;
    }
    for (int i in increasePushObstacles) {
      offset += (positionToOffset >= i) ? 1 : 0;
    }
    return offset;
  }

  /// calculates the pixel a pixel position will be moved to if it needs to be moved by some offset of building squares
  /// so if a pixel needs to be moved by 2 upwards, and there are 3 obstacles directly above it, the pixel's y will be 5 more
  ///
  /// PARAMS:
  /// Set<Pixel> obstaclePositions - the positions of all obstacles on the map, old and new
  /// Pixel oldPixel - the pixel to be moved
  /// offset - amount to be moved by
  /// coords - 0 to move x, 1 to move y
  Pixel _shiftPixelOverBuildings(
      Set<Pixel> obstaclePositions, Pixel oldPixel, int offset, int coords) {
    var increment = (offset >= 0) ? 1 : -1;
    var currentPixel = oldPixel;
    var count = 0;
    while (count < offset.abs() || obstaclePositions.contains(currentPixel)) {
      var newPixelList = currentPixel.toList();
      newPixelList[coords] += increment;
      currentPixel = Pixel.fromList(newPixelList);
      if (!obstaclePositions.contains(currentPixel)) {
        count++;
      }
    }
    return currentPixel;
  }

  //outputKey should be 0 for x to yPositions and 1 for y to xPositions
  HashMap<int, HashSet<int>> _generatePositionToSetPositions(
      Set<Pixel> obstacles, int outputKey) {
    HashMap<int, HashSet<int>> positionToObstacles = HashMap();

    for (Pixel obstacle in obstacles) {
      int outputLetter;
      int otherLetter;
      if (outputKey == 0) {
        outputLetter = obstacle.x;
        otherLetter = obstacle.y;
      } else {
        outputLetter = obstacle.y;
        otherLetter = obstacle.x;
      }
      if (!positionToObstacles.containsKey(outputLetter)) {
        positionToObstacles[outputLetter] = HashSet();
      }
      positionToObstacles[outputLetter]!.add(otherLetter);
    }
    return positionToObstacles;
  }
}

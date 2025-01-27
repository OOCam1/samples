import 'package:game_template/src/game_internals/models/positioned_building_info.dart';
import 'package:game_template/src/game_internals/position_and_height_states/grid_item.dart';

import '../models/unpositioned_building_info.dart';

abstract class PositionState {
  void placeBuildings(Set<BuildingInfo> buildings);
  void updateScores(Set<BuildingInfo> buildings);
  void clear();


  Map<List<int>, GridItem> getPositionsOfItems();
  //List contains x, then y, then height
  Set<PositionedBuildingInfo> getPositionsAndHeightsOfBuildings();
  Set<PositionedBuildingInfo> getPreObstaclePositions();
  int get xMax;
  int get xMin;
  int get yMax;
  int get yMin;
}

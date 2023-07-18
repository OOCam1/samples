import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/positioned_building_info.dart';
import 'package:game_template/src/game_internals/position_and_height_states/grid_item.dart';

import '../models/unpositioned_building_info.dart';

abstract class PositionStateInterface {
  void placeNewBuilding(BuildingInfo buildingInfo);
  void placeBuildings(Set<BuildingInfo> buildings);
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, double height);
  void clear();
  Map<List<int>, GridItem> getPositionsOfItems();
  //List contains x, then y, then height
  Set<PositionedBuildingInfo> getPositionsAndHeightsOfBuildings();

  int get xMax;
  int get xMin;
  int get yMax;
  int get yMin;
}





import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/building_info.dart';
import 'package:game_template/src/game_internals/position_and_height_states/grid_item.dart';


abstract class PositionStateInterface {
  void placeNewBuilding(ArtistGlobalInfo artistGlobalInfo, double height);
  void placeBuildings(Map<ArtistGlobalInfo, double> buildings);
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, double height);
  void clear();
  Map<List<int>, GridItem> getPositionsOfItems();
  void setupBuildingsAndObstacles({bool roads = false, bool border = false});
  //List contains x, then y, then height
  Set<BuildingInfo> getPositionsAndHeightsOfBuildings();

  int get xMax;
  int get xMin;
  int get yMax;
  int get yMin;


}




import 'package:game_template/src/game_internals/models/artist_global_info.dart';


abstract class PositionStateInterface {
  void placeNewBuilding(ArtistGlobalInfo artistGlobalInfo, int height);
  void placeBuildings(Map<ArtistGlobalInfo, int> buildings);
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height);
  void clear();

  //List contains x, then y, then height
  Map<ArtistGlobalInfo, List<int>> getPositionsAndHeights([Iterable<List<int>> verticalObstacles, Iterable<List<int>> horizontalObstacles]);

  int get xMax;
  int get xMin;
  int get yMax;
  int get yMin;


}
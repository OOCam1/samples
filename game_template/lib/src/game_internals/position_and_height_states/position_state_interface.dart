


import 'package:game_template/src/game_internals/artist_global_info.dart';


abstract class PositionStateInterface {
  void placeNewBuilding(ArtistGlobalInfo artistGlobalInfo, int height);
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height);
  void clear();

  //List contains x, then y, then height
  Map<ArtistGlobalInfo, List<int>> getPositionsAndHeights();
}
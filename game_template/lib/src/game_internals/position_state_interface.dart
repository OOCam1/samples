

import 'dart:collection';

import 'package:game_template/src/game_internals/artist_global_info.dart';


abstract class PositionStateInterface {
  void placeNewBuilding(ArtistGlobalInfo artistGlobalInfo, int height);
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height);
  void moveBuilding(ArtistGlobalInfo artistGlobalInfo, int x, int y);

  //List contains x, then y, then height
  Map<ArtistGlobalInfo, List<int>> getPositions();
}
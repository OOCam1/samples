




import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/genre.dart';
import 'package:game_template/src/game_internals/models/unpositioned_building_info.dart';
import 'package:game_template/src/game_internals/storage.dart';


ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName, int id) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), id.toString(), id.toString(), [primaryGenre]);
}
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // var id = 0;
  // var storage = Storage();
  //
  // Set<BuildingInfo> buildingInfos = HashSet();
  // for (int i = 0; i <= 5; i ++) {
  //   buildingInfos.add(BuildingInfo(3, generateTestArtistGlobalInfo(4, i)));
  // }
  // storage.save(buildingInfos, HashSet());
  // var newBuildingInfos = await storage.getBuildingInfos();
  // for (BuildingInfo info in newBuildingInfos) {
  //   print(info.artistGlobalInfo.id);
  // }
}
import "dart:collection";


import "package:flame/game.dart";
import "package:flutter/cupertino.dart";
import "package:game_template/src/building_handler.dart";
import 'package:game_template/src/city_screen.dart';
import "package:game_template/src/game_internals/models/artist_global_info.dart";
import "package:game_template/src/game_internals/models/building_isar_record.dart";
import "package:game_template/src/game_internals/models/genre.dart";
import "package:game_template/src/game_internals/models/positioned_building_info.dart";
import "package:game_template/src/game_internals/models/positioned_building_record.dart";
import "package:game_template/src/game_internals/models/unpositioned_building_info.dart";
import "package:game_template/src/game_internals/storage.dart";
import "package:isar/isar.dart";
import "package:path_provider/path_provider.dart";

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName, int id) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse('asldfnakf '), id.toString(), id.toString(), [primaryGenre]);
}

void main() async {
  int artistCount = 20;
  int numArtists = 2;
  WidgetsFlutterBinding.ensureInitialized();
  var id = 0;
  // var storage = await Storage.create();
  // await storage.clear();
  // Set<BuildingInfo> buildingInfos = HashSet();
  // Set<PositionedBuildingInfo> posBuildingInfos = HashSet();
  // for (int i = 0; i <= 5; i ++) {
  //   var buildingInfo = BuildingInfo(3, generateTestArtistGlobalInfo(4, i));
  //   buildingInfos.add(buildingInfo);
  //   if (i %2 == 0) {
  //     posBuildingInfos.add(PositionedBuildingInfo(buildingInfo, 0, 0));
  //   }
  // }
  // storage.save(buildingInfos, posBuildingInfos);
  // var newBuildingInfos = await storage.getBuildingInfos();
  // print(newBuildingInfos.length);
  // for (BuildingInfo info in newBuildingInfos) {
  //   print(info.artistGlobalInfo.id);
  // }
  //
  // print("Pos");
  // var newPosInfos = await storage.getPositionedBuildingInfos();
  // for (PositionedBuildingInfo posInfo in newPosInfos) {
  //   print(posInfo.artistGlobalInfo.id);
  // }
  //
  var game = await BuildingHandler.create();
  var dir = await getApplicationDocumentsDirectory();
  var isar = await Isar.open([
    PositionedBuildingRecordSchema,
    BuildingIsarRecordSchema
  ], directory: dir.path,
  name : "stuff");
  double count = 1;
  for (int j = 0; j < 4; j++) {
    HashSet<BuildingInfo> buildingInfos = HashSet();
    HashMap<ArtistGlobalInfo, double> artists = HashMap();
    for (int i = 0; i < numArtists; i++) {
      artists[generateTestArtistGlobalInfo(i % 10, artistCount)] = 0;
      artistCount += 1;
    }

    for (ArtistGlobalInfo artistGlobalInfo in artists.keys) {
      artists[artistGlobalInfo] = count;
      count += 0.1;
    }
    // positionState.placeBuildings(artists);
    // var positions = positionState.getPositionsAndHeights();
    for (var element in artists.entries) {
      buildingInfos.add(BuildingInfo(element.value, element.key));
    }

    game.addBuildings(buildingInfos);
  }

 game.run();
}

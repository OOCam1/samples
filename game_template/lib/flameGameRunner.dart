import "dart:collection";

import "package:flame/game.dart";
import "package:flutter/cupertino.dart";
import "package:game_template/src/building_handler.dart";
import 'package:game_template/src/city_screen.dart';
import "package:game_template/src/game_internals/models/artist_global_info.dart";
import "package:game_template/src/game_internals/models/building_isar_record.dart";
import "package:game_template/src/game_internals/models/genre.dart";
import "package:game_template/src/game_internals/models/unpositioned_building_info.dart";
import "package:isar/isar.dart";
import "package:path_provider/path_provider.dart";

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName, int id) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), id.toString(), id.toString(), [primaryGenre]);
}

void main() async {
  int artistCount = 0;
  int numArtists = 20;
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([BuildingIsarRecordSchema],
      directory: dir.path);
  BuildingIsarRecord buildingIsarRecord = BuildingIsarRecord();
  buildingIsarRecord.artistName = "gay";
  final thing = isar.buildingIsarRecords;
  for (BuildingIsarRecord b in thing.where().findAllSync()) {
    assert(b.artistName == "gay");
  }
  var game = BuildingHandler();
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
    print(artists.length);
    game.addBuildings(buildingInfos);
  }

 game.run();
}

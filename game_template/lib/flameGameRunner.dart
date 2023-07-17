import "dart:collection";

import "package:flame/game.dart";
import "package:flutter/cupertino.dart";
import 'package:game_template/src/city_screen.dart';
import "package:game_template/src/game_internals/models/artist_global_info.dart";
import "package:game_template/src/game_internals/models/genre.dart";
import "package:game_template/src/game_internals/models/unpositioned_building_info.dart";

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), '', '', [primaryGenre]);
}

void main() {
  int numArtists = 75;
  HashMap<ArtistGlobalInfo, double> artists = HashMap();
  HashSet<BuildingInfo> buildingInfos = HashSet();
  for (int i = 0; i < numArtists; i += 1) {
    artists[generateTestArtistGlobalInfo(i % 10)] = 0;
  }
  print(artists.length);
  double count = 1;
  for (ArtistGlobalInfo artistGlobalInfo in artists.keys) {
    artists[artistGlobalInfo] = count;
    count += 0.1;
  }
  // positionState.placeBuildings(artists);
  // var positions = positionState.getPositionsAndHeights();
  for (var element in artists.entries) {
    buildingInfos.add(BuildingInfo(element.value, element.key));
  }
  var game = CityScreen(buildingInfos);

  runApp(GameWidget(game: game));
}

import "dart:collection";

import "package:flame/game.dart";
import "package:flutter/cupertino.dart";
import 'package:game_template/src/city_screen.dart';
import "package:game_template/src/game_internals/models/artist_global_info.dart";
import "package:game_template/src/game_internals/models/genre.dart";

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), '', '', [primaryGenre]);
}

void main() {
  int numArtists = 75;
  HashMap<ArtistGlobalInfo, int> artists = HashMap();
  for (int i = 0; i <numArtists; i += 1) {
    artists[generateTestArtistGlobalInfo(i%10)] = 0;
  }
  print(artists.length);
  double count = 5;
  for (ArtistGlobalInfo artistGlobalInfo in artists.keys) {
    artists[artistGlobalInfo] = count.toInt();
    count += 3;
  }
  // positionState.placeBuildings(artists);
  // var positions = positionState.getPositionsAndHeights();
  var game = CityScreen(artists);

  runApp(
      GameWidget(game: game)
  );
}
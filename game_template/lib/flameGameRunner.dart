import "dart:collection";

import "package:flame/game.dart";
import "package:flutter/cupertino.dart";
import "package:game_template/src/city_screen/city_screen.dart";
import "package:game_template/src/game_internals/models/artist_global_info.dart";
import "package:game_template/src/game_internals/models/genre.dart";
import "package:game_template/src/game_internals/position_and_height_states/genre_grouped_position_state.dart";
import "package:game_template/src/game_internals/position_and_height_states/position_state_interface.dart";

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), '', '', [primaryGenre]);
}

void main() {
  PositionStateInterface positionState = GenreGroupedPositionState();
  positionState.clear();
  int numArtists = 150;
  HashMap<ArtistGlobalInfo, int> artists = HashMap();
  for (int i = 0; i <numArtists; i += 1) {
    artists[generateTestArtistGlobalInfo(i%10)] = 0;
  }
  print(artists.length);
  double count = 5;
  for (ArtistGlobalInfo artistGlobalInfo in artists.keys) {
    artists[artistGlobalInfo] = count.toInt();
    count += 2;
  }
  positionState.placeBuildings(artists);
  var positions = positionState.getPositionsAndHeights();
  var game = CityScreen(positions);
  runApp(
      GameWidget(game: game)
  );
}
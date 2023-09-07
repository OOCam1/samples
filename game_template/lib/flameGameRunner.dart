

import "dart:collection";

import "package:flutter/cupertino.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:game_template/src/building_handler.dart";
import "package:game_template/src/game_internals/models/artist_global_info.dart";
import "package:game_template/src/game_internals/models/genre.dart";
import "package:game_template/src/game_internals/models/unpositioned_building_info.dart";
import "package:game_template/src/game_internals/spotify_api/spotify_api.dart";
import "package:game_template/src/game_internals/spotify_api/spotify_auth.dart";

ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName, int id) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse('asldfnakf '), id.toString(), id.toString(), [primaryGenre]);
}

void main() async {
  int artistCount = 0;
  int numArtists = 20;
  WidgetsFlutterBinding.ensureInitialized();
  var game = await BuildingHandler.create();
  // double count = 1;
  // for (int j = 0; j < 4; j++) {
  //   HashSet<BuildingInfo> buildingInfos = HashSet();
  //   HashMap<ArtistGlobalInfo, double> artists = HashMap();
  //   for (int i = 0; i < numArtists; i++) {
  //     artists[generateTestArtistGlobalInfo(i % 10, artistCount)] = 0;
  //     artistCount += 1;
  //   }
  //
  //   for (ArtistGlobalInfo artistGlobalInfo in artists.keys) {
  //     artists[artistGlobalInfo] = count;
  //     count += 0.1;
  //   }
  //
  //   for (var element in artists.entries) {
  //     buildingInfos.add(BuildingInfo(element.key));
  //   }
  //   game.addBuildings(buildingInfos);
  //
  // }

 await game.run();

  // await dotenv.load();
  // var auth = SpotifyAuth();
  //
  //
  // await auth.signOut();
  // await auth.authenticate();
  // var api = await SpotifyApi.getCurrentUser();
  // var topArtists = await SpotifyApi.getTop99Artists("long_term");
  // for (var item in topArtists) {
  //   print(item.name);
  // }
  // print(topArtists.length);
}

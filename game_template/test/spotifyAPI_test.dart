
import 'package:game_template/src/game_internals/artist_global_info.dart';
import 'package:game_template/src/game_internals/spotify_data_getter.dart';
import 'package:test/test.dart';

void main() {
  SpotifyDataGetter api = new SpotifyDataGetter();
  test('only one instance of api', () {
    var newApi = new SpotifyDataGetter();
    assert(api == newApi);
  });
  test('reich artist name retrieved', () {
    Uri url = Uri.parse('https://api.spotify.com/v1/artists/1aVONoJ0EM97BB26etc1vo?si=kS_K-5zmT5C_BR9KF-PETg');
    expect(api.getArtistInfo(url).then( (value) {
      expect(value.name, 'Steve Reich');
    }),
    completes);


  });



}
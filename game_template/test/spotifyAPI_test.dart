
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:game_template/src/game_internals/models/user.dart';
import 'package:game_template/src/game_internals/spotify_api/spotify_api.dart';
import 'package:game_template/src/game_internals/spotify_api/spotify_auth.dart';
import 'package:test/test.dart';
import 'package:flutter/services.dart' show MethodChannel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});
  });
  // SpotifyDataGetter api = new SpotifyDataGetter();
  // test('only one instance of api', () {
  //   var newApi = new SpotifyDataGetter();
  //   assert(api == newApi);
  // });
  // test('reich artist name retrieved', () {
  //   Uri url = Uri.parse(
  //       'https://api.spotify.com/v1/artists/1aVONoJ0EM97BB26etc1vo?si=kS_K-5zmT5C_BR9KF-PETg');
  //   expect(api.getArtistInfo(url).then((value) {
  //     expect(value.name, 'Steve Reich');
  //   }),
  //       completes);
  // });
  // test('complex authorisation', () async {
  //   var auth = SpotifyUserAuthorisation('0b4fbe18cf2640d79eb59254f36241aa', 'd861453d0fa04257959df16ca0e19fa7', 'http://localhost:3000');
  //   var token = await auth.getAdvancedAccessToken();
  //   print(token.body);
  // });
  var auth = SpotifyAuth();

  test ('API returns user info from id', () async {
    await dotenv.load(fileName: '.env');
    await auth.authenticate();
     //User user = await SpotifyApi.getUserById('2eevblar3anj0ujkn2wexfk7r?si=bc234d0348f84bc7');
     //print(user.name);
    // final auth = context.read<SpotifyAuth>();

  });
  test('flutter_web_auth authenticate', () async {
    await FlutterWebAuth.authenticate(url: 'http://localhost/3000', callbackUrlScheme: 'flutterdemo');
  });
}
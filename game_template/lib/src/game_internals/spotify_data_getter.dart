import 'dart:convert';
import 'package:game_template/src/game_internals/artist_global_info.dart';
import 'package:http/http.dart' as http;

class SpotifyDataGetter {

  static final SpotifyDataGetter _instance = SpotifyDataGetter._internal();
  String _access_token = '';
  final String _CLIENTID = '0b4fbe18cf2640d79eb59254f36241aa';
  final String _CLIENTSECRET = 'd861453d0fa04257959df16ca0e19fa7';

  factory SpotifyDataGetter() {
    return _instance;
  }

  SpotifyDataGetter._internal();

  Future<http.Response> _accessTokenApiRequest() async {

    var body = <String, String>{
      'grant_type': 'client_credentials',
      'client_id': _CLIENTID,
      'client_secret': _CLIENTSECRET
    };

    return await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body
    );
  }
  Future<String> _getAccessToken() async {
    if (_access_token != '') {
      return _access_token;
    }
    Uri url = Uri.parse('https://accounts.spotify.com/api/token');
    var headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',};
    var body = <String, String>{
      'grant_type': 'client_credentials',
      'client_id': _CLIENTID,
      'client_secret': _CLIENTSECRET
    };
    http.Response response = await http.post(url, headers:headers, body:body);
    var output = jsonDecode(response.body) as Map<String, dynamic>;

    if (output.containsKey('access_token')) {
      _access_token = output['access_token'] as String;
      return _access_token;
    }
    throw Exception("Access token API call failed");
  }


  Future<ArtistGlobalInfo> getArtistInfo(Uri url) async {
    var token = await _getAccessToken();
    print(token);
    var headers = <String, String> {
      'Authorization' : 'Bearer  $token',
    };
    print(headers);
    var response = await http.get(url, headers: headers);
    print(response.body);
    return ArtistGlobalInfo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }



}
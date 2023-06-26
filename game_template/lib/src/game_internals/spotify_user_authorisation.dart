import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyUserAuthorisation {
  late final String _CLIENTID;
  late final String _CLIENTSECRET;
  late final String _redirectUri;
  String _basicAccessToken = '';
  String _advancedAccessToken = '';

  SpotifyUserAuthorisation(this._CLIENTID, this._CLIENTSECRET, this._redirectUri);

  Future<String> getBasicAccessToken() async {

    if (_basicAccessToken != '') {
      return _basicAccessToken;
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
      _basicAccessToken = output['access_token'] as String;
      return _basicAccessToken;
    }
    throw Exception("Access token API call failed");
  }

  Future<http.Response>  getAdvancedAccessToken() async {
    // if (_advancedAccessToken != '') {
    //   return _advancedAccessToken;
    // }
    Uri url = Uri.parse('https://accounts.spotify.com/authorize?');
    var scope = 'playlist-read-private user-top-read user-read-recently-played';
    var headers = <String, String> {
      'client_id' : _CLIENTID,
      'response_type' : 'code',
      'redirect_uri' : _redirectUri,
      'scope' : scope,
    };
    return await http.get(url, headers: headers);



  }

}
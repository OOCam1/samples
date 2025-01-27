import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:game_template/src/game_internals/spotify_api/spotify_auth_api.dart';

import '../models/auth_tokens.dart';
import '../models/user.dart';
import 'api_path.dart';
import 'spotify_api.dart';

class SpotifyAuth extends ChangeNotifier {
  User? user;

  /// Authenticate user and and get token and user information
  ///
  /// Implemented using 'Authorization Code' flow from Spotify auth guide:
  /// https://developer.spotify.com/documentation/general/guides/authorization-guide/
  Future<void> authenticate() async {
    try {
      final clientId = dotenv.env['CLIENT_ID'];
      final redirectUri = dotenv.env['REDIRECT_URI'];
      final state = _getRandomString(6);

      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId, redirectUri, state),
        callbackUrlScheme: dotenv.env['CALLBACK_URL_SCHEME']!,
        preferEphemeral: true
      );

      // Validate state from response
      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      final code = Uri.parse(result).queryParameters['code'];
      final tokens = await SpotifyAuthApi.getAuthTokens(code, redirectUri);
      await tokens.saveToStorage();

      user = await SpotifyApi.getCurrentUser(); // Uses token in storage_handler.dart
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  /// If there is a saved token, update the token and sign in
  Future<void> signInFromSavedTokens() async {
    try {
      await AuthTokens.updateTokenToLatest();

      user = await SpotifyApi.getCurrentUser(); // Uses token in storage_handler.dart
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await AuthTokens.clearStorage();
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static String _getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}

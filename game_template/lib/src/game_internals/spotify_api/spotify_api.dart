import 'dart:convert';

import 'package:game_template/src/game_internals/spotify_api/spotify_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../models/user.dart';
import 'api_path.dart';

typedef NestedApiPathBuilder<T> = String Function(T listItem);

class PremiumRequiredException implements Exception {}

class NoActiveDeviceFoundException implements Exception {}

class SpotifyApi {
  static Client client = InterceptedClient.build(interceptors: [
    SpotifyInterceptor(),
  ], retryPolicy: ExpiredTokenRetryPolicy());

  static Future<User> getCurrentUser() async {
    final response = await client.get(Uri.parse(APIPath.getCurrentUser));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}');
    }
  }

  static Future<User> getUserById(String userId) async {
    final response = await client.get(Uri.parse(APIPath.getUserById(userId)));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception(
          'Failed to get user with status code ${response.statusCode}');
    }
  }



  // static Future<Playlist> getPlaylist(String? playlistId) async {
  //   final response =
  //       await client.get(Uri.parse(APIPath.getPlaylist(playlistId)));
  //
  //   if (response.statusCode == 200) {
  //     final responseBody = json.decode(response.body);
  //     final onwerResponse = await client
  //         .get(Uri.parse(APIPath.getUserById(responseBody['owner']['id'])));
  //     responseBody['owner'] = json.decode(onwerResponse.body);
  //     return Playlist.fromJson(responseBody);
  //   } else {
  //     throw Exception(
  //         'Failed to get a playlist with status code ${response.statusCode}');
  //   }
  // }


  static Map<String, String> artistUrlToImageUrlCache = {};
  //
  // static Future<String?> getArtistImageUrl(String href) async {
  //   // Check if the image url is already cached
  //   if (artistUrlToImageUrlCache[href] != null)
  //     return artistUrlToImageUrlCache[href];
  //
  //   final response = await client.get(Uri.parse(href));
  //   if (response.statusCode == 200) {
  //     final responseBody = json.decode(response.body);
  //     final images = responseBody['images'];
  //     if (images.length == 0) return null;
  //     for (final image in images) {
  //       final imageWidth = image['width'];
  //       final imageHeight = image['height'];
  //       if (imageWidth < Constants.artistImageMaxSize ||
  //           imageHeight < Constants.artistImageMaxSize) {
  //         artistUrlToImageUrlCache[href] = image['url'];
  //         return image['url'];
  //       }
  //     }
  //
  //     artistUrlToImageUrlCache[href] = images[0]['url'];
  //     return images[0]['url'];
  //   } else {
  //     throw Exception(
  //         'Failed to get artist image url with status code ${response.statusCode}');
  //   }
  // }
  //
  // static Future<void> play({
  //   required String? playlistId,
  //   required String? trackId,
  //   int? positionMs = 0,
  // }) async {
  //   final response = await client.put(Uri.parse(APIPath.play),
  //       body: json.encode({
  //         'context_uri': 'spotify:playlist:$playlistId',
  //         'offset': {'uri': 'spotify:track:$trackId'},
  //         'position_ms': positionMs,
  //       }));
  //
  //   if (response.statusCode == 204) return;
  //   if (response.statusCode == 403) {
  //     String? reason = json.decode(response.body)['error']['reason'];
  //     if (reason != null && reason.contains("PREMIUM_REQUIRED")) {
  //       throw PremiumRequiredException();
  //     }
  //   }
  //   if (response.statusCode == 404) throw NoActiveDeviceFoundException();
  // }





  static Future _expandNestedParam(
      {required List originalList,
      required NestedApiPathBuilder nestedApiPathBuilder,
      required String paramToExpand}) async {
    return Future.wait(originalList.map((item) =>
        client.get(Uri.parse(nestedApiPathBuilder(item))).then((response) {
          item[paramToExpand] = json.decode(response.body);
          return item;
        })));
  }
}

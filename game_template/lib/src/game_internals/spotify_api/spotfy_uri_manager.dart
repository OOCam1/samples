import 'package:game_template/src/game_internals/spotify_api/spotify_auth.dart';


class SpotifyUriManager {
  SpotifyUriManager(this.auth);
  final SpotifyAuth auth;

  // Future<void> handleLoadFromUri(Uri uri) async {
  //   final playlistId = uri.queryParameters['playlist_id'];
  //   if (auth.user == null) {
  //     await _authenticateUser();
  //   }
  //
  //   final playlist = await SpotifyApi.getPlaylist(playlistId);
  //   //Get.off(PlayerPage.create(playlist: playlist, isOpenedFromDeepLink: true));
  // }

  // void handleFail() {
  //   CustomToast.showTextToast(
  //       text: 'Failed to load playlist from Uri', toastType: ToastType.error);
  // }

  Future<void> _authenticateUser() async {
    await auth.signInFromSavedTokens();
  }
}

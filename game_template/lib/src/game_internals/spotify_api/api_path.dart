class APIPath {
  static final List<String> _scopes = [
    'user-read-private',
    'user-read-email',
    'user-top-read',
    'user-read-recently-played'
  ];

  static String requestAuthorization(
          String? clientId, String? redirectUri, String state) =>
      'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&state=$state&scope=${_scopes.join('%20')}';

  static String requestToken = 'https://accounts.spotify.com/api/token';
  static String getCurrentUser = 'https://api.spotify.com/v1/me';
  static String getUserById(String? userId) =>
      'https://api.spotify.com/v1/users/$userId';
  static String getListOfPlaylists(int offset, int limit) =>
      'https://api.spotify.com/v1/me/playlists?limit=$limit&offset=$offset';
  static String getPlaylist(String? playlistId) =>
      'https://api.spotify.com/v1/playlists/$playlistId';
  static String getTracks(String? playlistId) =>
      'https://api.spotify.com/v1/playlists/$playlistId/tracks?fields=items(track(id,name,artists,duration_ms,album(images)))';
  static String story(String? playlistId, String? trackId) =>
      'playlists/$playlistId/tracks/$trackId';
  static String playlists = 'playlists';
  static String playlist(String? playlistId) => 'playlists/$playlistId';
  static String savedPlaylist(
          {required String? userId, required String? playlistId}) =>
      'users/$userId/saved_playlists/$playlistId';
  static String savedPlaylists({required String? userId}) =>
      'users/$userId/saved_playlists';
  static String play = 'https://api.spotify.com/v1/me/player/play';
  static String pause = 'https://api.spotify.com/v1/me/player/pause';
  static String player = 'https://api.spotify.com/v1/me/player';
  static String getTopItems({required String? type,required String? time_range, required int offset}) =>
      'https://api.spotify.com/v1/me/top/$type?time_range=$time_range&offset=$offset&limit=50';
  static String getRecentlyPlayed({int after = 0}) =>
    'https://api.spotify.com/v1/me/player/recently-played?limit=50&after=$after';
}

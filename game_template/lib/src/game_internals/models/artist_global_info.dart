
import 'genre.dart';
class ArtistGlobalInfo {
  final List<Genre> genres;
  final String id;
  final String name;
  final Uri uri;
  late final Genre _primaryGenre;
  ArtistGlobalInfo(this.uri,this.name, this.id, this.genres) {
    _primaryGenre = genres[0];
  }

  factory ArtistGlobalInfo.fromJson(Map<String, dynamic> json) {
    List<Genre> genres = [];
    for (dynamic genreName in json['genres'] as Iterable) {
      genres.add(Genre(genreName as String));
    }
    return ArtistGlobalInfo(Uri.parse(json['uri'] as String), json['name'] as String, json['id'] as String,  genres);
  }

  Genre get primaryGenre => _primaryGenre;
}
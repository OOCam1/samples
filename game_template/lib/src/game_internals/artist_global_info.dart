import 'dart:collection';

import 'genre.dart';
class ArtistGlobalInfo {
  final Set<Genre> genres;
  final String id;
  final String name;
  final Uri uri;
  late final Genre _primaryGenre;
  ArtistGlobalInfo({required this.uri,required this.name, required this.id, required this.genres});

  factory ArtistGlobalInfo.fromJson(Map<String, dynamic> json) {
    HashSet<Genre> genres = HashSet<Genre>();
    for (dynamic genreName in json['genres'] as Iterable) {
      genres.add(Genre(genreName as String));
    }
    return ArtistGlobalInfo(
      uri: Uri.parse(json['uri'] as String),
      name : json['name'] as String,
      id : json['id'] as String,
      genres : genres
    );
  }

  Genre get primaryGenre => _primaryGenre;
}
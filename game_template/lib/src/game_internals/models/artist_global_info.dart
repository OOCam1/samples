
import 'dart:collection';

import 'package:isar/isar.dart';

import 'genre.dart';


class ArtistGlobalInfo {

  static final Map<String, ArtistGlobalInfo> idToArtist = HashMap();
  final List<Genre> genres;
  final String id;
  final String name;
  final Uri uri;

  factory ArtistGlobalInfo(Uri uri,String name, String id, List<Genre> genres) {
    if (idToArtist.containsKey(id)) {
      return idToArtist[id]!;
    }
    var newArtist = ArtistGlobalInfo._internal(uri, name, id, genres);
    idToArtist[id] = newArtist;
    return newArtist;
  }

  ArtistGlobalInfo._internal(this.uri, this.name, this.id, this.genres);

  factory ArtistGlobalInfo.fromJson(Map<String, dynamic> json) {
    List<Genre> genres = [];
    for (dynamic genreName in json['genres'] as Iterable) {
      genres.add(Genre(genreName as String));
    }
    return ArtistGlobalInfo(Uri.parse(json['uri'] as String), json['name'] as String, json['id'] as String,  genres);
  }

  Genre get primaryGenre => genres[0];
}
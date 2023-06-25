import 'dart:collection';

class Genre {
  static final HashMap globalGenreMap = HashMap<String, Genre>();
  late final String name;
  factory Genre(String name) {
    if (!globalGenreMap.containsKey(name)) {
      Genre newGenre = Genre._internal(name);
      globalGenreMap[name] = newGenre;
    }
    return globalGenreMap[name] as Genre;
  }
  Genre._internal(this.name);
}
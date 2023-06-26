

class MusicDataProcessor {

  static final MusicDataProcessor _instance = MusicDataProcessor._internal();

  MusicDataProcessor._internal();
  factory MusicDataProcessor() {return _instance;}
}
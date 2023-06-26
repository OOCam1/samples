import 'artist_global_info.dart';

class Building {
  late int _xPosition;
  late int _yPosition;
  late final ArtistGlobalInfo _artistGlobalInfo;
  late int _height;
  Building(this._xPosition, this._yPosition, this._artistGlobalInfo, this._height) {
    if (_height <= 0) {
      throw Exception("Height of building under 0");
    }
  }

  void setPosition(int x, int y) {
    _xPosition = x;
    _yPosition = y;
  }

  List<int> getPosition() {return [_xPosition, _yPosition];}

  void setHeight(int height) {
    _height = height;
  }
  int getHeight() {return _height;}

}
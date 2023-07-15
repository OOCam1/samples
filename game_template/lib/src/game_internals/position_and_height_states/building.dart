import 'package:game_template/src/game_internals/models/positioned_building_info.dart';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'package:game_template/src/game_internals/position_and_height_states/position_genre.dart';

import '../models/artist_global_info.dart';

class Building {
  late Pixel _position;
  late final ArtistGlobalInfo _artistGlobalInfo;
  late final PositionGenre _positionGenre;
  late double _height;
  Building(this._artistGlobalInfo, this._height, this._positionGenre) {
    if (_height <= 0) {
      throw Exception("Height of building under 0");
    }
  }

  void setPosition(Pixel position) {
    _position = position;
  }

  PositionedBuildingInfo toPositionedBuildingInfo() {

  }

  Pixel get position {return _position;}

  void setHeight(double height) {
    _height = height;
  }
  double get height => _height;
  ArtistGlobalInfo get artistGlobalInfo => _artistGlobalInfo;
  PositionGenre get positionGenre => _positionGenre;

}
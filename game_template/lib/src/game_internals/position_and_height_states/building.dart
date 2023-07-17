import 'package:game_template/src/game_internals/models/positioned_building_info.dart';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'package:game_template/src/game_internals/position_and_height_states/position_genre.dart';

import '../models/artist_global_info.dart';
import '../models/unpositioned_building_info.dart';
import 'grid_item.dart';

class Building {
  late Pixel _position;
  final BuildingInfo _buildingInfo;

  late final PositionGenre _positionGenre;

  Building(this._buildingInfo, this._positionGenre) {
    if (_buildingInfo.height <= 0) {
      throw Exception("Height of building under 0");
    }
  }

  void setPosition(Pixel position) {
    _position = position;
  }

  PositionedBuildingInfo toPositionedBuildingInfo(int x, int y) {
    return PositionedBuildingInfo(_buildingInfo, x, y);
  }

  GridItem toGridItem() => GridItem.building;

  Pixel get position {
    return _position;
  }

  BuildingInfo get buildingInfo => _buildingInfo;
  double get height => _buildingInfo.height;
  ArtistGlobalInfo get artistGlobalInfo => _buildingInfo.artistGlobalInfo;
  PositionGenre get positionGenre => _positionGenre;
}

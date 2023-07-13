

import 'package:flutter/cupertino.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';

import '../position_and_height_states/building.dart';

@immutable
class BuildingInfo {
  late final int x;
  late final int y;
  late final ArtistGlobalInfo artistGlobalInfo;
  late final double height;

  BuildingInfo(this.x, this.y, this.artistGlobalInfo, this.height);

  BuildingInfo.fromBuilding(Building building, List<int> obstacleAdjustedPosition) {
    x = obstacleAdjustedPosition[0];
    y = obstacleAdjustedPosition[1];
    height = building.height;
    artistGlobalInfo = building.artistGlobalInfo;
  }

}
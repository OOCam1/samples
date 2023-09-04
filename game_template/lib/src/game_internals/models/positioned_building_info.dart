

import 'package:flutter/cupertino.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:isar/isar.dart';

import '../position_and_height_states/building.dart';
import 'unpositioned_building_info.dart';


class PositionedBuildingInfo implements BuildingInfo{
  late int x;
  late  int y;
  late int preObstacleX;
  late int preObstacleY;
  late final BuildingInfo _buildingInfo;

  @override
  double get height => _buildingInfo.height;

  @override
  set score(double value) { _buildingInfo.score = value;}

  @override
  ArtistGlobalInfo get artistGlobalInfo => _buildingInfo.artistGlobalInfo;

  PositionedBuildingInfo(this._buildingInfo, this.x, this.y);


  @override
  double get score => _buildingInfo.score;

  BuildingInfo unpositionedBuildingInfo() {
    return BuildingInfo(score, artistGlobalInfo);
  }


}
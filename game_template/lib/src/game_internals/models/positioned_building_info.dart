

import 'package:flutter/cupertino.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';

import '../position_and_height_states/building.dart';
import 'unpositioned_building_info.dart';


class PositionedBuildingInfo implements BuildingInfo{
  late int x;
  late  int y;
  late final BuildingInfo _buildingInfo;

  @override
  double get height => _buildingInfo.height;

  @override
  set height(double value) { _buildingInfo.height = value;}

  @override
  ArtistGlobalInfo get artistGlobalInfo => _buildingInfo.artistGlobalInfo;

  PositionedBuildingInfo(this._buildingInfo, this.x, this.y);






}
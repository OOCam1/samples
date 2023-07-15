

import 'package:flutter/cupertino.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';

import '../position_and_height_states/building.dart';
import 'unpositioned_building_info.dart';


class PositionedBuildingInfo extends BuildingInfo{
  late final int x;
  late final int y;
  late BuildingInfo unpositionedBuildingInfo;

  PositionedBuildingInfo(super.height, super.artistGlobalInfo, this.x, this.y);



}
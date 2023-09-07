

import 'package:game_template/src/game_internals/models/artist_global_info.dart';

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

  @override
  void addScore(double timeRatio, int rank) {
    _buildingInfo.addScore(timeRatio, rank);
  }

  BuildingInfo unpositionedBuildingInfo() {
    return BuildingInfo(artistGlobalInfo);
  }



}
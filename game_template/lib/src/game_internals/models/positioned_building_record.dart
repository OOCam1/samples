

import 'package:game_template/src/game_internals/models/positioned_building_info.dart';
import 'package:isar/isar.dart';

import 'building_isar_record.dart';
part 'positioned_building_record.g.dart';
@collection
class PositionedBuildingRecord {
  Id id = Isar.autoIncrement;
  int? x;
  int? y;
  IsarLink<BuildingIsarRecord> buildingRecord = IsarLink();

  PositionedBuildingRecord();

  PositionedBuildingRecord.fromPositionedBuildingInfo (PositionedBuildingInfo buildingInfo){
    x = buildingInfo.x;
    y = buildingInfo.y;
    buildingRecord.value = BuildingIsarRecord.fromBuildingInfo(buildingInfo);
}
}
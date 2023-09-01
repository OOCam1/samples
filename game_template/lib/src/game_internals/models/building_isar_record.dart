

import 'dart:collection';
import 'dart:ffi';

import 'package:game_template/src/game_internals/models/unpositioned_building_info.dart';
import 'package:isar/isar.dart';

import 'genre.dart';

part 'building_isar_record.g.dart';

@collection
class BuildingIsarRecord {

  static Map<BuildingInfo, BuildingIsarRecord> infoToRecord = HashMap();
  Id id = Isar.autoIncrement;

  List<String>? genreNames;

  String? artistId;
  String? artistName;

  @ignore
  String? uri;
  double? score;

  BuildingIsarRecord();

  factory BuildingIsarRecord.fromBuildingInfo(BuildingInfo buildingInfo) {
    if (infoToRecord.containsKey(buildingInfo)) {
      return infoToRecord[buildingInfo]!;
    }
    Set<String> genreNames = HashSet();
    for (Genre g in buildingInfo.artistGlobalInfo.genres) {
      genreNames.add(g.name);
    }
    var newRecord = BuildingIsarRecord()
        ..artistId = buildingInfo.artistGlobalInfo.id
        ..artistName = buildingInfo.artistGlobalInfo.name
        ..uri = buildingInfo.artistGlobalInfo.uri.toString()
        ..score = buildingInfo.score
        ..genreNames = genreNames.toList();
    infoToRecord[buildingInfo] = newRecord;
    return newRecord;
  }
}



/*
save everything to database as isar records - each of the positioned building records will  point to
an unpositioned building record. So, converting building to record must point to the same object
Create converter function within buildingIsarRecord which has map from building to building record


load: create



 */
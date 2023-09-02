import 'dart:collection';

import 'package:game_template/src/game_internals/models/unpositioned_building_info.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/building_isar_record.dart';
import 'models/positioned_building_info.dart';
import 'models/positioned_building_record.dart';

class Storage {
  late Isar isar;
  bool initialised = false;



  void save(Set<BuildingInfo> buildings, Set<PositionedBuildingInfo> posBuildings) async{
    await _initialise();
    List<PositionedBuildingRecord> posRecords = [];
    List<BuildingIsarRecord> unPosRecords = [];
    final HashSet<String> artistIDs = HashSet();
    for (BuildingIsarRecord record in isar.buildingIsarRecords.where().findAllSync()) {
      if (record.artistId != null) {
        artistIDs.add(record.artistId!);
      }
    }
    buildings.removeWhere((element) => artistIDs.contains(element.artistGlobalInfo.id));
    posBuildings.removeWhere((element) => artistIDs.contains(element.artistGlobalInfo.id));
    for (BuildingInfo info in buildings) {
      unPosRecords.add(BuildingIsarRecord.fromBuildingInfo(info));
    }
    for (PositionedBuildingInfo info in posBuildings) {
      posRecords.add(PositionedBuildingRecord.fromPositionedBuildingInfo(info));
    }
    await isar.writeTxn(() async {
      await isar.buildingIsarRecords.putAll(unPosRecords.toList());
      await isar.positionedBuildingRecords.putAll(posRecords.toList());
    });
  }

  Future<Set<BuildingInfo>> getBuildingInfos() async {
    await _initialise();
    final table = isar.buildingIsarRecords;
    HashSet<BuildingInfo> output = HashSet();
    for (BuildingIsarRecord record in table.where().findAllSync()) {
      output.add(record.toBuildingInfo());
    }
    return output;
}

  Future<Set<PositionedBuildingInfo>> getPositionedBuildingInfos() async {
    await _initialise();
    final table = isar.positionedBuildingRecords;
    HashSet<PositionedBuildingInfo> output = HashSet();
    for (PositionedBuildingRecord record in table.where().findAllSync()) {
      output.add(record.toBuildingInfo());
    }
    return output;
  }

  Future _initialise() async {
    if (!initialised) {
      initialised = true;
      var dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open([PositionedBuildingRecordSchema, BuildingIsarRecordSchema],
          directory: dir.path,
          inspector: true);
    }
  }

}
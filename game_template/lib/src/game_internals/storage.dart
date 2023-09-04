import 'dart:collection';

import 'package:game_template/src/game_internals/models/unpositioned_building_info.dart';
import 'package:game_template/src/game_internals/position_and_height_states/obstacle_adder_record.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/building_isar_record.dart';
import 'models/positioned_building_info.dart';
import 'models/positioned_building_record.dart';

class Storage {
  late Isar isar;

  Storage._internal(this.isar);

  static Future<Storage> create() async {
    var dir = await getApplicationDocumentsDirectory();
    return Storage._internal(await Isar.open(
        [PositionedBuildingRecordSchema, BuildingIsarRecordSchema, ObstacleAdderRecordSchema],
        directory: dir.path,
        inspector: true));
  }


  void save(Set<BuildingInfo> buildings, Set<PositionedBuildingInfo> posBuildings) {
    List<PositionedBuildingRecord> posRecords = [];
    List<BuildingIsarRecord> unPosRecords = [];

    //Error checking
    final HashSet<String> unPosIDs = HashSet();
    for (BuildingInfo info in buildings) {
      unPosIDs.add(info.artistGlobalInfo.id);
    }
    for (PositionedBuildingInfo posInfo in posBuildings) {
      if (!unPosIDs.contains(posInfo.artistGlobalInfo.id)) {
        throw Exception("Positioned info contains reference to unpositioned info that is not being saved");
      }
    }

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
    isar.writeTxnSync(() {
      isar.buildingIsarRecords.putAllSync(unPosRecords.toList());
      isar.positionedBuildingRecords.putAllSync(posRecords.toList());
    });
  }

  Future<Set<BuildingInfo>> getBuildingInfos() async{
    final table = isar.buildingIsarRecords;
    HashSet<BuildingInfo> output = HashSet();
    var stuff = await table.where().findAll();
    for (BuildingIsarRecord record in stuff) {
      output.add(record.toBuildingInfo());
    }
    return output;
}

  Future<Set<PositionedBuildingInfo>> getPositionedBuildingInfos() async {
    final table = isar.positionedBuildingRecords;
    HashSet<PositionedBuildingInfo> output = HashSet();
    var stuff = await table.where().findAll();
    for (PositionedBuildingRecord record in stuff) {
      output.add(record.toBuildingInfo());
    }
    return output;

  }
  //
  // //returns down, up, left, right road 1d squares
  // Future<List<Iterable<int>>>? getObstacleAdderRecord() async {
  //   final table = isar.obstacleAdderRecords;
  //   var record = await table.where().findFirst();
  //   if (record == null) {
  //     return [[], [], [], []];
  //   }
  //   return [
  //     record.downYPositions ?? [],
  //     record.upYPositions ?? [],
  //     record.leftXPositions ?? [],
  //     record.rightXPositions ?? []
  //   ];
  // }
  Future<void> clear() async {
    final allRecords = isar.buildingIsarRecords
    .where()
    .idProperty()
    .findAllSync();

    final allPosRecords = isar.positionedBuildingRecords
    .where()
    .idProperty()
    .findAllSync();
    await isar.writeTxn(() async{
      await isar.positionedBuildingRecords.deleteAll(allPosRecords);
      await isar.buildingIsarRecords.deleteAll(allRecords);
    });


  }

}
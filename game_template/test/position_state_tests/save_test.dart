



import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_template/src/game_internals/models/building_isar_record.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';



  void main() {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
      test('saving record works', () async {
        final dir = await getApplicationDocumentsDirectory();
        final isar = await Isar.open([BuildingIsarRecordSchema],
            directory: dir.path);
        BuildingIsarRecord buildingIsarRecord = BuildingIsarRecord();
        buildingIsarRecord.artistName = "gay";
        final thing = isar.buildingIsarRecords;
        for (BuildingIsarRecord b in thing.where().findAllSync()) {
          expect(b.artistName, "gay");
        }

  });
  }

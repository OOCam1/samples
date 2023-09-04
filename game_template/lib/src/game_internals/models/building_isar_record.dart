

import 'dart:collection';
import 'dart:ffi';

import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/positioned_building_info.dart';
import 'package:game_template/src/game_internals/models/unpositioned_building_info.dart';
import 'package:isar/isar.dart';

import 'genre.dart';

part 'building_isar_record.g.dart';

@collection
class BuildingIsarRecord {

  static final Map<BuildingInfo, BuildingIsarRecord> _infoToRecord = HashMap();
  static final Map<BuildingIsarRecord, BuildingInfo> _recordToInfo = HashMap();

  Id id = Isar.autoIncrement;
  List<String>? genreNames;
  String? artistId;
  String? artistName;


  String? uri;
  double? score;

  BuildingIsarRecord();

  factory BuildingIsarRecord.fromBuildingInfo(BuildingInfo buildingInfo) {
    if (_infoToRecord.containsKey(buildingInfo)) {
      return _infoToRecord[buildingInfo]!;
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
    _infoToRecord[buildingInfo] = newRecord;
    _recordToInfo[newRecord] = buildingInfo;
    return newRecord;
  }

  BuildingInfo toBuildingInfo() {
    if (_recordToInfo.containsKey(this)) {
      return _recordToInfo[this]!;
    }
    List<Genre> newGenres = [];
    for (String genreName in genreNames!) {
      newGenres.add(Genre(genreName));
    }
    var newArtistInfo = ArtistGlobalInfo(Uri.parse(uri!), artistName!, artistId!, newGenres);
    var newInfo = BuildingInfo(score!, newArtistInfo);
    _recordToInfo[this] = newInfo;
    _infoToRecord[newInfo] = this;
    return newInfo;
}
}



/*
save everything to database as isar records - each of the positioned building records will  point to
an unpositioned building record. So, converting building to record must point to the same object
Create converter function within buildingIsarRecord which has map from building to building record


load: create



 */
import 'dart:collection';

import 'package:game_template/src/game_internals/models/artist_global_info.dart';


class BuildingInfo {

  static final HashMap<ArtistGlobalInfo, BuildingInfo> _instances = HashMap();

  double score;
  late final ArtistGlobalInfo _artistGlobalInfo;


  factory BuildingInfo(double score, ArtistGlobalInfo artistGlobalInfo) {
    if (_instances.containsKey(artistGlobalInfo)) {
      var instance = _instances[artistGlobalInfo]!;
      instance.score = score;
      return instance;
    }
    var newBuilding = BuildingInfo._internal(score, artistGlobalInfo);
    _instances[artistGlobalInfo] = newBuilding;
    return newBuilding;
  }

  ArtistGlobalInfo get artistGlobalInfo =>  _artistGlobalInfo;
  BuildingInfo._internal(this.score, this._artistGlobalInfo);

  double get height => score;
}

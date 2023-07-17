import 'dart:collection';

import 'package:game_template/src/game_internals/models/artist_global_info.dart';

class BuildingInfo {
  static final HashMap<ArtistGlobalInfo, BuildingInfo> _instances = HashMap();

  late double height;
  late final ArtistGlobalInfo _artistGlobalInfo;

  ArtistGlobalInfo get artistGlobalInfo => _artistGlobalInfo;

  factory BuildingInfo(double height, ArtistGlobalInfo artistGlobalInfo) {
    if (_instances.containsKey(artistGlobalInfo)) {
      var instance = _instances[artistGlobalInfo]!;
      instance.height = height;
      return instance;
    }
    var newBuilding = BuildingInfo._internal(height, artistGlobalInfo);
    _instances[artistGlobalInfo] = newBuilding;
    return newBuilding;
  }

  BuildingInfo._internal(this.height, this._artistGlobalInfo);
}

import 'dart:collection';
import 'package:game_template/src/game_internals/artist_global_info.dart';
import 'package:game_template/src/game_internals/pixel_map.dart';
import 'package:game_template/src/game_internals/position_state_interface.dart';
import 'building.dart';

class GenreGroupedPositionState implements PositionStateInterface {

  static final GenreGroupedPositionState _instance = GenreGroupedPositionState._internal();
  GenreGroupedPositionState._internal();
  factory GenreGroupedPositionState() {return _instance;}

  final PixelMap<Building> _positionMap = PixelMap<Building>();
  final HashMap<ArtistGlobalInfo, Building> _artistGlobalInfoToBuildingMap = HashMap();

  @override
  void changeHeight(ArtistGlobalInfo artistGlobalInfo, int height) {
    if (!_artistGlobalInfoToBuildingMap.containsKey(artistGlobalInfo)) {
      throw Exception("Artist info not in position state");
    }
    Building building = _artistGlobalInfoToBuildingMap[artistGlobalInfo]!;
    if (height < building.getHeight()) {
      throw Exception("New height of building smaller than old height");
    }
    _artistGlobalInfoToBuildingMap[artistGlobalInfo]!.setHeight(height);
  }

  @override
  Map<ArtistGlobalInfo, List<int>> getPositions() {
    HashMap<ArtistGlobalInfo, List<int>> output = HashMap();
    for (MapEntry<ArtistGlobalInfo, Building> mapEntry in _artistGlobalInfoToBuildingMap.entries) {
      var building = mapEntry.value;
      var position = building.getPosition();
      output[mapEntry.key] = [position[0], position[1], building.getHeight()];
    }
    return output;
  }

  @override
  void moveBuilding(ArtistGlobalInfo artistGlobalInfo,  int x, int y) {
    // TODO: implement moveBuilding

  }

  @override
  void placeNewBuilding(ArtistGlobalInfo artistGlobalInfo, int height) {
    // TODO: implement placeBuilding
  }



}








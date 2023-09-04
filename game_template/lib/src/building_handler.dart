

import 'dart:collection';


import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_template/src/city_screen.dart';

import 'game_internals/models/positioned_building_info.dart';
import 'game_internals/models/unpositioned_building_info.dart';
import 'game_internals/position_and_height_states/genre_grouped_position_state.dart';
import 'game_internals/position_and_height_states/grid_item.dart';
import 'game_internals/position_and_height_states/position_state.dart';
import 'game_internals/storage.dart';

class BuildingHandler {

  final PositionState _positionStateInterface;
  final CityScreen _cityScreen = CityScreen();
  final Storage _storage;

  BuildingHandler._internal(this._storage, this._positionStateInterface);

  static Future<BuildingHandler> create() async {
    var storage = await Storage.create();
    var positionState = await GenreGroupedPositionState.create(await storage.getPositionedBuildingInfos());
    return BuildingHandler._internal(storage, positionState);
  }

  Future run() async {
    // await _storage.clear();

    var buildingPositionsAfterObstacles = _positionStateInterface.getPositionsAndHeightsOfBuildings();
    var gridItemPositions = _positionStateInterface.getPositionsOfItems();
    await _cityScreen.setPositions(buildingPositionsAfterObstacles, gridItemPositions);
    //TODO save the unpositioned buildings too

    var positionsBeforeObstacles = _positionStateInterface.getPreObstaclePositions();
    Set<BuildingInfo> unpositionedInfos = HashSet();
    for (PositionedBuildingInfo pos in positionsBeforeObstacles) {
      unpositionedInfos.add(pos.unpositionedBuildingInfo());
    }
    _storage.save(unpositionedInfos, positionsBeforeObstacles);
    runApp(GameWidget(game: _cityScreen));
  }

  void addBuildings(Iterable<BuildingInfo> newBuildingInfos) {
    for (BuildingInfo buildingInfo in newBuildingInfos) {
      if (buildingInfo.height <= 0) {
        throw Exception('Height assigned to artist should be greater than 0');
      }
    }

    _positionStateInterface.placeBuildings(newBuildingInfos.toSet());

  }

}



/*
load in building infos from save - artist global info, score, positions
position state interface and height handler must be updated
get data from online, and update all heights/positions
save data

position state should be its own class
saving should take place within both height handler and position state separately

height handler passes data to position state which then passes data to city screen
 */



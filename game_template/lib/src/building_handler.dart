

import 'dart:collection';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_template/src/city_screen.dart';

import 'game_internals/models/positioned_building_info.dart';
import 'game_internals/models/unpositioned_building_info.dart';
import 'game_internals/position_and_height_states/genre_grouped_position_state.dart';
import 'game_internals/position_and_height_states/grid_item.dart';
import 'game_internals/position_and_height_states/position_state_interface.dart';

class BuildingHandler {
  final PositionStateInterface _positionStateInterface = GenreGroupedPositionState();
  final CityScreen _cityScreen = CityScreen();


  void run() {
    var buildingPositionsAfterObstacles = _positionStateInterface.getPositionsAndHeightsOfBuildings();
    var gridItemPositions = _positionStateInterface.getPositionsOfItems();
    _cityScreen.setPositions(buildingPositionsAfterObstacles, gridItemPositions);
    runApp(GameWidget(game: _cityScreen));
  }

  void addBuildings(Iterable<BuildingInfo> newBuildingInfos) {
    for (BuildingInfo buildingInfo in newBuildingInfos) {
      if (buildingInfo.height <= 0) {
        throw Exception('Height assigned to artist should be greater than 0');
      }
    }
    // _buildingInfos.addAll(newBuildingInfos);

    _positionStateInterface.placeBuildings(newBuildingInfos.toSet());

    // _buildingPositionsAfterObstacles =
    //     positionStateInterface.getPositionsAndHeightsOfBuildings();

    // _gridItemPositions = positionStateInterface.getPositionsOfItems();
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



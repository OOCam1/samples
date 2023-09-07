


import '../models/unpositioned_building_info.dart';

abstract class ScoreContract {

  Iterable<BuildingInfo> getUpdatedScores();
  Iterable<BuildingInfo> getNewBuildings();
  void generateScores();
}
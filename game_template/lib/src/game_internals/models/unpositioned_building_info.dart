import 'dart:collection';
import 'dart:math';

import 'package:dart_numerics/dart_numerics.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';


class BuildingInfo {
  static const double _score_threshold = 1;
  static final HashMap<ArtistGlobalInfo, BuildingInfo> _instances = HashMap();
  static const _inverseTanhHalf = 0.549306144334055;
  static const _halfwayScore = 10;

  //the amount of score you gain from being 100th for 4 weeks
  static const _fourWeeksConstant = 0.8;
  double score = 0;
  late final ArtistGlobalInfo _artistGlobalInfo;


  factory BuildingInfo(ArtistGlobalInfo artistGlobalInfo) {
    if (_instances.containsKey(artistGlobalInfo)) {
      var instance = _instances[artistGlobalInfo]!;
      return instance;
    }
    var newBuilding = BuildingInfo._internal(artistGlobalInfo);
    _instances[artistGlobalInfo] = newBuilding;
    return newBuilding;
  }

  ArtistGlobalInfo get artistGlobalInfo =>  _artistGlobalInfo;
  BuildingInfo._internal(this._artistGlobalInfo);

  //sigmoid function: converts positive number above 1 into number between 1 and 15
  double get height  {
    var result = 15*tanh(score*_inverseTanhHalf/_halfwayScore);
    return (result >= 1) ? result  : 0;
  }

  ///input negative ratio if this is first time app setup
  ///ratioToFourWeeks is the amount of time since last app update its been divided by four weeks
  ///inverse rank is 100-ranking of artist where ranking of artist goes from 0
  void addScore(double ratioToFourWeeks, int rank) {
    if (ratioToFourWeeks > 0) {
      score += ratioToFourWeeks * (99 - rank) * _fourWeeksConstant;
    }

    //pretty arbitrary starting value - means top 25 artists are halfway
    else {
      score += (100 - rank) / 7.5;
    }
  }
}




import 'dart:collection';

import 'package:game_template/src/game_internals/models/artist_global_info.dart';
import 'package:game_template/src/game_internals/models/unpositioned_building_info.dart';
import 'package:game_template/src/game_internals/position_and_height_states/score_contract.dart';
import 'package:game_template/src/game_internals/spotify_api/spotify_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage.dart';


///heights should be roughly between 1 and 10
class ScoreHandler implements ScoreContract {

  static const Duration _fourWeeks = Duration(days:28);
  static const Duration _sixMonths = Duration(days: 183);
  final Storage _storage;
  ScoreHandler(this._storage);
  final HashSet<BuildingInfo> _unbuiltBuildings = HashSet();
  final HashSet<BuildingInfo> _newBuildings = HashSet();
  final HashSet<BuildingInfo> _oldBuildings = HashSet();
  DateTime? _lastDateTime;
  bool _firstTime = true;



  @override
  Iterable<BuildingInfo> getNewBuildings() {
    HashSet<BuildingInfo> output = HashSet();
    output.addAll(_newBuildings);
    return output;
  }

  Iterable<BuildingInfo> getUnbuiltBuildings() {
    return HashSet()..addAll(_unbuiltBuildings);
  }

  @override
  Iterable<BuildingInfo> getUpdatedScores() {
    HashSet<BuildingInfo> output = HashSet();
    output.addAll(_oldBuildings);
    return output;
  }


  Future generateScores() async {
    await _loadState();
    var now = DateTime.now().toUtc();

    if (_firstTime) {
      var artists = await SpotifyApi.getTop99Artists("long_term");
        for (int i = 0; i < artists.length; i ++) {
          var building = BuildingInfo(artists[i])..addScore(-1, i);
          if (building.height <= 0) {
            _unbuiltBuildings.add(building);
          }
          else {
            _newBuildings.add(building);
          }
        }
    }
    else {
      Duration timeDiff = now.difference(_lastDateTime!);
      double timeRatio = timeDiff.inMicroseconds/_fourWeeks.inMicroseconds;
      List<ArtistGlobalInfo> artists;
      if (timeDiff.compareTo(_fourWeeks)  <= 0) {
        artists = await SpotifyApi.getTop99Artists("short_term");
      }
      else if (timeDiff.compareTo(_sixMonths) <= 0) {
        artists = await SpotifyApi.getTop99Artists("medium_term");
      }
      else {
        artists = await SpotifyApi.getTop99Artists("long_term");
      }
      var storedArtists = _unbuiltBuildings.union(_newBuildings).union(_oldBuildings);
      for (int rank = 0; rank < artists.length; rank ++) {
        var building = BuildingInfo(artists[rank]);
        var oldHeight = building.height;
        building.addScore(timeRatio, rank);
        if (building.height == 0) {
          _unbuiltBuildings.add(building);
        }
        else if (oldHeight == 0) {
          _newBuildings.add(building);
          _unbuiltBuildings.remove(building);
        }
      }
    }
    await _saveDate(now);
  }

  Future _loadState() async{
    var buildingInfos = await _storage.getBuildingInfos();
    for (BuildingInfo info in buildingInfos ) {
      if (info.score == 0) {
        _unbuiltBuildings.add(info);
      }
      else {
        _oldBuildings.add(info);
      }
    }
    var prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString('date');
    if (dateString != null) {
      _firstTime = false;
      _lastDateTime = DateTime.parse(dateString);
    }
  }

  Future _saveDate(DateTime date) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('date', date.toIso8601String());
  }

}

//pseducode:
/// if first time setup, load in top 100 lifetime from api and save them as old buildings with preset scores
/// and save datetime
/// else:
///    if it overlaps with recently played:
///         do nothing, do not update datetime difference
///
///
  /// calculate datetime difference
///
  /// if datetime difference under or roughly equal to 4 weeks:
///       inverse rank taken from short term
///   elif datetime difference between 4 weeks and 6 months:
///       inverse rank taken from medium term
///   elif datetime difference significantly over 6 months:
///       inverse rank taken from long term
///
///
///   for each building:
///       add to score the inverse rank* 4 weeks constant * datetimedifference/4 weeks
///       if height is newly over 0, add to new buildings
///       else, add to old
///  save datetime (storage will be saved later)
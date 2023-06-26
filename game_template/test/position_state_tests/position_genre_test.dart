

import 'dart:collection';
import 'dart:math';

import 'package:game_template/src/game_internals/artist_global_info.dart';
import 'package:game_template/src/game_internals/genre.dart';
import 'package:game_template/src/game_internals/position_and_height_states/genre_grouped_position_state.dart';
import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'package:test/test.dart';


ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName) {
  var primaryGenre = Genre(primaryGenreName.toString());
  return ArtistGlobalInfo(Uri.parse(''), '', '', [primaryGenre]);
}

void display(Map<ArtistGlobalInfo, List<int>> positions) {
  HashMap<Pixel, String> positionToGenre = HashMap();
  var xCoordMin = 0;
  var xCoordMax = 0;
  var yCoordMin = 0;
  var yCoordMax = 0;
  for (var mapEntry in positions.entries) {
    var position = mapEntry.value.sublist(0, 2);
    var pixelPosition = Pixel(position[0], position[1]);
    positionToGenre[pixelPosition] = mapEntry.key.primaryGenre.name;
    xCoordMin = min(xCoordMin, position[0]);
    xCoordMax = max(xCoordMax, position[0]);
    yCoordMin = min(yCoordMin, position[1]);
    yCoordMax = max(yCoordMax, position[1]);
  }
  for (int i = 0; i < 5; i ++) {
    print('');
  }

  for (int y = yCoordMin; y <= yCoordMax; y ++) {
    String str = "";
    for (int x = xCoordMin; x <= xCoordMax; x ++) {
      if (positionToGenre.containsKey(Pixel(x,y))) {
        String gd = positionToGenre[Pixel(x,y)]!;
        str += "|" + gd + " |";
      }
      else{str += "|  |";}

    }
    print(str);
  }
}

void main() {

  GenreGroupedPositionState positionState = GenreGroupedPositionState();
  test('add one artist to position_state is placed at 0,0', () {
    positionState.clear();
    var artistGlobalInfo = generateTestArtistGlobalInfo(0);
    positionState.placeNewBuilding(artistGlobalInfo, 5);
    var positions = positionState.getPositionsAndHeights();
    expect(positions[artistGlobalInfo], orderedEquals([0,0, 5]) );
  });

  test('adding two artists from same genre computes correctly', () {
    positionState.clear();
    var artistGlobalInfo = generateTestArtistGlobalInfo(0);
    positionState.placeNewBuilding(artistGlobalInfo, 5);
    var secondArtistGlobalInfo = generateTestArtistGlobalInfo(0);
    positionState.placeNewBuilding(secondArtistGlobalInfo, 3);
    var positions = positionState.getPositionsAndHeights();
    expect(positions[artistGlobalInfo], orderedEquals([0,0,5]));
    print(positions[secondArtistGlobalInfo]);
    int squareDistance = (pow(positions[secondArtistGlobalInfo]![0], 2) + pow(positions[secondArtistGlobalInfo]![1], 2)) as int;
    expect(squareDistance, 1);
    expect(positions[secondArtistGlobalInfo]![2], 3);

  });

  test('change height works', () {
    positionState.clear();
    var artistGlobalInfo = generateTestArtistGlobalInfo(0);
    var second = generateTestArtistGlobalInfo(2);
    positionState.placeNewBuilding(artistGlobalInfo, 2);
    positionState.placeNewBuilding(second, 5);
    positionState.changeHeight(artistGlobalInfo, 3);

    var positions = positionState.getPositionsAndHeights();
    expect(positions[artistGlobalInfo]![2], 3);
    expect(positions[second]![2], 5);
  });

  test('setting height to below zero throws exception', () {
    positionState.clear();
    var artistGlobalInfo = generateTestArtistGlobalInfo(0);
    try {
      positionState.placeNewBuilding(artistGlobalInfo, -3);
      throw Exception("Nothing happened");
    }
    on Exception catch (e) {
      print(e);
    }
  });

  test('Add 100 artists from different genres and check that each of them occupies exactly one square', () {
    positionState.clear();
    int numArtists = 100;
    HashSet<ArtistGlobalInfo> artists = HashSet();
    for (int i = 0; i <numArtists; i += 1) {
      artists.add(generateTestArtistGlobalInfo(i%10));
    }
    for (ArtistGlobalInfo artistGlobalInfo in artists) {
      positionState.placeNewBuilding(artistGlobalInfo, 6);
      display(positionState.getPositionsAndHeights());
    }
    var positions = positionState.getPositionsAndHeights();
    expect(positions.length, numArtists);

    HashSet<Pixel> occupiedPositions = HashSet();
    for (List<int> position in positions.values) {
      expect(position.length, 3);
      var p = Pixel(position[0], position[1]);
      assert(!occupiedPositions.contains(p));
      occupiedPositions.add(p);
    }
  });
}



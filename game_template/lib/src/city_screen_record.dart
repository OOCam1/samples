


import 'dart:ui';

import 'package:isar/isar.dart';

import 'game_internals/models/genre.dart';

part 'city_screen_record.g.dart';

@collection
class CityScreenRecord {

  Id id = Isar.autoIncrement;
  String? genreName;
  int? red;
  int? green;
  int? blue;
  double? opacity;

  CityScreenRecord.create(Genre genre, Color color) {
    genreName = genre.name;
    red = color.red;
    green = color.green;
    blue = color.blue;
    opacity = color.opacity;
  }
  CityScreenRecord();
}
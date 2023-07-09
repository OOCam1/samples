
import 'package:flame/components.dart';
import 'package:game_template/src/game_internals/models/artist_global_info.dart';

abstract class BuildingAsset extends PositionComponent {
  ArtistGlobalInfo get artistGlobalInfo;

}
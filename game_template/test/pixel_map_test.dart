import 'package:game_template/src/game_internals/position_and_height_states/pixel_map.dart';
import 'package:test/test.dart';


void main() {
  test('Empty map contains key returns false', () {
    var thing = PixelMap<String>();
    expect(thing.containsKey([0, 0]), false);
  });

  test('Empty map throws wrong type exception', () {
    var thing = PixelMap<String>();
    try {
      thing.containsKey('a');
  }
    on WrongKeyType {
      return;
  }
    catch (e) {
      throw Exception('Wrong key type did not happen');
    }
  });

  test('Map with matching first key but not second key returns containKey as false', () {
    var thing = PixelMap<int>();
    thing[[0,1]] = 2;
    expect(thing.containsKey([0,2]), false);
    expect(thing.containsKey([1,0]), false);
    expect(thing.containsKey([0,0]), false);
    expect(thing.containsKey([1,1]), false);
    expect(thing.containsKey([2,1]), false);
    expect(thing.containsKey([0,1]), true);
  });

  test('Map [] returns correct value', () {
    var thing = PixelMap<int>();
    thing[[0,1]] = 2;
    expect(thing[[0,1]], 2);
    thing[[0,0]] = 1;
    expect(thing[[0,0]], 1);
    thing[[1,1]] = 3;
    expect(thing[[1,1]], 3);
    thing[[1,0]] = 4;
    expect(thing[[1,0]], 4);
    thing[[1,0]] = 5;

    expect(thing[[1,0]], 5);
    expect(thing[[0,1]], 2);
    expect(thing[[0,0]], 1);
    expect(thing[[1,1]], 3);
  });

  test('Values returns correct items', () {
    var thing = PixelMap<int>();
    thing[[0,1]] = 1;
    thing[[0,0]] = 1;
    thing[[1,1]] = 3;
    thing[[1,0]] = 4;
    thing[[1,0]] = 5;
    expect(thing.values, unorderedEquals([1,1,5,3]));
  });
}

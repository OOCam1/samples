import 'package:game_template/src/game_internals/position_and_height_states/pixel.dart';
import 'package:test/test.dart';
void main() {

  test('Only one instance of pixel exists',() {
    var a = Pixel(1,2);
    var b = Pixel(1,2);
    expect(a, equals(b));
  });
  test('Creating pixels does not screw with others', () {
    var a = Pixel(1,2);
    var b = Pixel(1,2);
    expect(a.x, 1);
    expect(a.y, 2);
    var c = Pixel(1,3);
    expect(a.x, 1);
    expect(a.y, 2);
    var d = Pixel(0,2);
    expect(a.x, 1);
    expect(a.y, 2);
  });
  test('Map with matching first key but not second key returns containKey as false', () {
    var thing = <Pixel, int>{};
    thing[Pixel(0,1)] = 2;
    expect(thing.containsKey(Pixel(0,2)), false);
    expect(thing.containsKey(Pixel(1,0)), false);
    expect(thing.containsKey(Pixel(0,0)), false);
    expect(thing.containsKey(Pixel(1,1)), false);
    expect(thing.containsKey(Pixel(2,1)), false);
    expect(thing.containsKey(Pixel(0,1)), true);
  });

}
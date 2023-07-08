

import 'dart:collection';

class Pixel {
  late final int _x;
  late final int _y;
  static final HashMap<int, HashMap<int, Pixel>> pixels = HashMap();

  factory Pixel(int x, int y) {
    if (!pixels.containsKey(x)) {
      var newPixel = Pixel._internal(x, y);
      HashMap<int, Pixel> newYMap = HashMap();
      newYMap[y] = newPixel;
      pixels[x] = newYMap;
      return newPixel;
    }
    if(!pixels[x]!.containsKey(y)) {
      var newPixel = Pixel._internal(x, y);
      pixels[x]![y] = newPixel;
      return newPixel;
    }
    return pixels[x]![y]!;
  }

  Pixel._internal(this._x, this._y);

  int get x => _x;
  int get y => _y;

  @override
  bool equals(Pixel pixel) {
    return (pixel.x == _x && pixel.y == _y);
  }

  Set<Pixel> getAdjacents() {
    Set<Pixel> output = HashSet();
    output.add(Pixel(x-1, y));
    output.add(Pixel(x+1, y));
    output.add(Pixel(x, y+1));
    output.add(Pixel(x, y-1));
    return output;
  }

}
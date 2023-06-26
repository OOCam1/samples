import 'dart:collection';


class WrongKeyType implements Exception {}
class WrongKeyLength implements Exception {}

class PixelMap<T> implements Map<List<int>, T> {

  final HashMap<int, HashMap<int, T>>  _internalMap = HashMap();

  @override
  T? operator [](Object? key) {
    if (containsKey(key)) {
      var list = key as List<int>;
      return _internalMap[list[0]]?[list[1]];
    }
    return null;

  }

  @override
  void operator []=(List<int> key, T value) {
    List<int> list;
    try {
      list = key as List<int>;
    }
    on Exception {
      throw WrongKeyType();
    }

    if (list.length != 2) {
      throw WrongKeyLength();
    }
    int x = list[0];
    int y = list[1];
    if (!_internalMap.containsKey(x)) {
      var newMap = HashMap<int, T>();
      newMap[y] = value;
      _internalMap[x] = newMap;
    }
    else {
      _internalMap[x]![y] = value;
    }
  }

  @override
  void addAll(Map<List<int>, T> other) {
    // TODO: implement addAll
    throw UnimplementedError();
  }

  @override
  void addEntries(Iterable<MapEntry<List<int>, T>> newEntries) {
    // TODO: implement addEntries
    throw UnimplementedError();
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    throw UnimplementedError();
  }

  @override
  void clear() {
    // TODO: implement clear
    _internalMap.clear();
  }

  @override
  bool containsKey(Object? key) {
    List<int> list;
    try {
      list = key as List<int>;
    }
    catch (e) {
      throw WrongKeyType();
    }

    if (list.length != 2) {
      throw WrongKeyLength();
    }
    if (!_internalMap.containsKey(list[0])) {
      return false;
    }
    return _internalMap[list[0]]!.containsKey(list[1]);
  }

  @override
  bool containsValue(Object? value) {
    // TODO: implement containsValue
    throw UnimplementedError();
  }

  @override
  // TODO: implement entries
  Iterable<MapEntry<List<int>, T>> get entries =>
      throw UnimplementedError();

  @override
  void forEach(void Function(List<int> key, T value) action) {
    // TODO: implement forEach
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => throw UnimplementedError();

  @override
  // TODO: implement keys
  Iterable<List<int>> get keys => throw UnimplementedError();

  @override
  // TODO: implement length
  int get length {
    var count = 0;
    for (Map<int, T> mapValue in _internalMap.values) {
      count += mapValue.length;
    }
    return count;
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(List<int> key, T value) convert) {
    // TODO: implement map
    throw UnimplementedError();
  }

  @override
  T putIfAbsent(List<int> key, T Function() ifAbsent) {
    // TODO: implement putIfAbsent
    throw UnimplementedError();
  }

  @override
  T? remove(Object? key) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  void removeWhere(bool Function(List<int> key, T value) test) {
    // TODO: implement removeWhere
  }

  @override
  T update(List<int> key, T Function(T value) update, {T Function()? ifAbsent}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  void updateAll(T Function(List<int> key, T value) update) {
    // TODO: implement updateAll
  }

  @override
  // TODO: implement values
  Iterable<T> get values {
    List<T> values = <T>[];
    for (Map<int, T> mapValue in _internalMap.values) {
      values.addAll(mapValue.values);
    }
    return values;
  }

}
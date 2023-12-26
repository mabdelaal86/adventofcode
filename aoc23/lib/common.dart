import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math' show Point;

final spaceRe = RegExp(r" +");

extension IterableMath on Iterable<int> {
  int sum() => fold(0, (a, b) => a + b);
  int mul() => fold(1, (a, b) => a * b);
  int min() => reduce((a, b) => math.min(a, b));
  int max() => reduce((a, b) => math.max(a, b));
}

Stream<String> getData([String? name]) => File("data/${name ?? getStem(Platform.script)}.txt")
    .openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter());

String getStem(Uri path) => path.pathSegments.last.split(".")[0];


extension Echo<T> on T {
  T echo({String prefix = "", String Function(T p)? format}) {
    format ??= (T p) => "$p";
    print("$prefix${format(this)}");
    return this;
  }
}

T echo<T>(T obj, {String prefix = "", String Function(T p)? format}) => obj
    .echo(prefix: prefix, format: format);


extension IterableExt<T> on Iterable<T> {
  void printAll() => forEach((e) => print(e));

  Iterable<(T, K)> zip<K>(Iterable<K> other) sync* {
    final iter1 = iterator, iter2 = other.iterator;
    while (iter1.moveNext() && iter2.moveNext()) {
      yield (iter1.current, iter2.current);
    }
  }

  bool allAre(T value) => every((e) => e == value);
}

extension ListListExt<T> on List<List<T>> {
  int get width => first.length;
  bool containsPoint(Point<int> point) =>
      0 <= point.x && point.x < width && 0 <= point.y && point.y < length;
}

extension IterableRecord2Ext<K, V> on Iterable<(K, V)> {
  Map<K, V> toMap() => { for (var item in this) item.$1 : item.$2 };
}


enum Direction { north, west, east, south }

const dirDelta = {
  Direction.north: Point(0, -1),
  Direction.west: Point(-1, 0),
  Direction.east: Point(1, 0),
  Direction.south: Point(0, 1),
};

class Displacement {
  final Direction direction;
  final int distance;

  Displacement(this.direction, this.distance);
}


int lowestDivisor(int n) {
  if (n.isEven) return 2;
  for (int i = 3; i < n; i += 2) {
    if (n % i == 0) return i;
  }
  return n;
}

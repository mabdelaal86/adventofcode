import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math' show Point, Rectangle;

final spaceRe = RegExp(r" +");

extension IterableMath on Iterable<int> {
  int sum() => fold(0, (a, b) => a + b);
  int mul() => fold(1, (a, b) => a * b);
  int min() => reduce((a, b) => math.min(a, b));
  int max() => reduce((a, b) => math.max(a, b));
}

Stream<String> getData() => File("data/${getStem(Platform.script)}.txt")
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

extension IterableListExt<T> on Iterable<List<T>> {
  Rectangle<int> getBorders() => Rectangle(0, 0, first.length - 1, length - 1);
}

extension IterableRecord2Ext<K, V> on Iterable<(K, V)> {
  Map<K, V> toMap() => { for (var item in this) item.$1 : item.$2 };
}


enum Dir { n, w, e, s }

const dirDelta = {
  Dir.n: Point(0, -1),
  Dir.w: Point(-1, 0),
  Dir.e: Point(1, 0),
  Dir.s: Point(0, 1),
};


int lowestDivisor(int n) {
  if (n.isEven) return 2;
  for (int i = 3; i < n; i += 2) {
    if (n % i == 0) return i;
  }
  return n;
}

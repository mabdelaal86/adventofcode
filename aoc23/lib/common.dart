import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;

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

T echo<T>(T obj, {String prefix = "", String Function(T p)? format}) => obj.echo(prefix: prefix, format: format);

extension Echo<T> on T {
  T echo({String prefix = "", String Function(T p)? format}) {
    format ??= (T p) => "$p";
    print("$prefix${format(this)}");
    return this;
  }
}

extension PrintAll<T> on Iterable<T> {
  void printAll() => forEach((e) => print(e));
  Iterable<(T, K)> zip<K>(Iterable<K> other) sync* {
    final iter1 = iterator, iter2 = other.iterator;
    while (iter1.moveNext() && iter2.moveNext()) {
      yield (iter1.current, iter2.current);
    }
  }
}

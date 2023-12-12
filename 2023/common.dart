import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;

final spaceRe = RegExp(r" +");

extension IterableMath on Iterable<int> {
  int sum() => this.fold(0, (a, b) => a + b);
  int mul() => this.fold(1, (a, b) => a * b);
  int min() => this.reduce((a, b) => math.min(a, b));
  int max() => this.reduce((a, b) => math.max(a, b));
}

Stream<String> getData() => File("data/${getStem(Platform.script)}.txt")
    .openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter());

String getStem(Uri path) => path.pathSegments.last.split(".")[0];

extension Echo<T> on T {
  T echo({String prefix = "", String format(T p)?}) {
    format ??= (T p) => "$p";
    print("$prefix${format(this)}");
    return this;
  }
}

extension PrintAll<T> on Iterable<T> {
  void printAll() => this.forEach((e) => print(e));
}

Iterable<(T, K)> zip<T, K>(Iterator<T> iter1, Iterator<K> iter2) sync* {
  while (iter1.moveNext() && iter2.moveNext()) {
    yield (iter1.current, iter2.current);
  }
}

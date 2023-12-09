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

Stream<String> getData(String path) => File(path)
    .openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter());

extension Echo<T> on T {
  T echo() {
    print(this);
    return this;
  }
}

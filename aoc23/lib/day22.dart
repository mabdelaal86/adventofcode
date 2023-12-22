import 'dart:math';

import 'package:vector_math/vector_math.dart';
import 'package:quiver/collection.dart';

import 'common.dart';

final example = r"""
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
""".trim();

late final List<String> data;
// final processed = <Brick>[];

Future<void> main() async {
  // data = await getData().toList();
  data = example.split("\n");

  final processed = data.map(Brick.parse).toList();
  processed.sort((a, b) => a.bottom.compareTo(b.bottom));
  processed.printAll();
  // print(processed.every((e) => e.isOrthogonal));

  int count = 0;
  for (final (index, item) in processed.indexed) {
    for (final other in processed.skip(index + 1)) {
      if (item.mayCollide(other)) {
        print((item, other));
        count++;
        break;
      }
    }
  }

  print(count);
}

class Brick {
  final Vector3 start;
  final Vector3 end;

  Brick(this.start, this.end);

  factory Brick.parse(String line) {
    final parts = line.split("~");
    final start = Vector3.array(parts.first.split(",").map(double.parse).toList());
    final end = Vector3.array(parts.last.split(",").map(double.parse).toList());
    return Brick(start, end);
  }

  @override
  String toString() => "$start ~ $end";

  double get bottom => min(start.z, end.z);
  double get top => max(start.z, end.z);
  bool get isOrthogonal => start.xy == end.xy || start.xz == end.xz || start.yz == end.yz;

  void fall([int d = 1]) {
    start.z -= d;
    end.z -= d;
  }

  bool mayCollide(Brick other) =>
      rangeCollide(start.x, end.x, other.start.x, other.end.x) ||
      rangeCollide(start.y, end.y, other.start.y, other.end.y);

  static bool rangeCollide(double s1, double e1, double s2, double e2) {
    if (s1 > e1) (s1, e1) = (e1, s1);
    if (s2 > e2) (s2, e2) = (e2, s2);
    return !(s2 > e1 || s1 > e2);
  }
}

// part 1:
// part 2:

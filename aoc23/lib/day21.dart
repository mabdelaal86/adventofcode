import 'dart:math';

import 'package:quiver/iterables.dart';

import 'common.dart';

final example = r"""
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
""".trim();

late final List<String> data;
late final List<List<String>> processed;
final cache = <(Point<int>, int), Set<Point<int>>>{};
late Iterable<Point<int>> Function(Point<int> point) getAdjacent;

Future<void> main() async {
  // data = await getData().toList();
  data = example.split("\n");

  processed = data.map((e) => e.split("")).toList(growable: false);

  final start = findStart();

  getAdjacent = getAdjacent1;
  final part1 = canReachCached(start, 6);
  // final part1 = canReachCached(start, 64);
  print(part1.length);
  // print(part1);
  print("*********");

  getAdjacent = getAdjacent2;
  cache.clear();
  // var part2 = canReachCached(start, 26501365);
  var part2 = canReachCached(start, 6);
  print(part2.length);
  part2 = canReachCached(start, 10);
  print(part2.length);
  part2 = canReachCached(start, 50);
  print(part2.length);
  part2 = canReachCached(start, 100);
  print(part2.length);
}

Point<int> findStart() {
  for (final (y, row) in processed.indexed) {
    for (final (x, tile) in row.indexed) {
      if (tile == "S") return Point(x, y);
    }
  }
  throw Exception("Can't find Start");
}

Set<Point<int>> canReachCached(Point<int> start, int steps) =>
    cache[(start, steps)] ??= canReach(start, steps);

Set<Point<int>> canReach(Point<int> start, int steps) {
  final adjPoints = getAdjacent(start);
  if (steps == 1) return adjPoints.toSet();

  return {
    for (final adj in adjPoints)
      for (final point in canReachCached(adj, steps - 1))
        point
  };
}

String getTile(Point<int> point) => processed[point.y][point.x];

Iterable<Point<int>> getAdjacent1(Point<int> point) => dirDelta.values
    .map((e) => point + e)
    .where((e) => processed.containsPoint(e) && getTile(e) != "#");

Point<int> adjustPoint(Point<int> point) => Point(
  point.x % processed.width,
  point.y % processed.length,
);

Iterable<Point<int>> getAdjacent2(Point<int> point) => dirDelta.values
    .map((e) => (point + e))
    .where((e) => getTile(adjustPoint(e)) != "#");

void draw(Iterable<Point<int>> reached) {
  for (final y in range(-11, 22)) {
    final text = range(-11, 22)
        .map((x) => Point(x.toInt(), y.toInt()))
        .map((p) => reached.contains(p) ? "O" : getTile(adjustPoint(p)))
        .join();
    print(text);
  }
}

// part 1:
// part 2:

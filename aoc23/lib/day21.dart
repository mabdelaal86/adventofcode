import 'dart:math';

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
late final Rectangle<int> border;
final cache = <(Point<int>, int), Set<Point<int>>>{};

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");

  processed = data.map((e) => e.split("")).toList(growable: false);

  border = processed.getBorders();
  final start = findStart();
  final part1 = canReachCached(start, 64);
  print(part1.length);
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

Iterable<Point<int>> getAdjacent(Point<int> point) => dirDelta.values
    .map((e) => point + e)
    .where((e) => border.containsPoint(e) && getTile(e) != "#");

// part 1:
// part 2:

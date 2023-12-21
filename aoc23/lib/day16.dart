import 'dart:math';

import 'common.dart';

final example = r"""
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
""".trim();

late final List<List<String>> data;
late final Rectangle<int> border;

Future<void> main() async {
  data = await getData().map((e) => e.split("")).toList();
  // data = example.split("\n").map((e) => e.split("")).toList();

  border = Rectangle(0, 0, data.width - 1, data.length - 1);

  final part1 = beam(Point(0, 0), Point(-1, 0));
  print(part1);

  final part2 = getInitialPoints().map((e) => beam(e.$1, e.$2)).max();
  print(part2);
}

int beam(Point<int> start, Point<int> prev) {
  final energized = <Point<int>>{};
  final history = <(Point<int>, Point<int>)>{};
  encounter(start, prev, energized, history);
  return energized.length;
}

void encounter(
    Point<int> curr, Point<int> prev,
    Set<Point<int>> energized, Set<(Point<int>, Point<int>)> history)
{
  if (!border.containsPoint(curr)) return;
  if (!history.add((curr, prev))) return;
  energized.add(curr);

  for (final next in move(curr, prev)) {
    encounter(next, curr, energized, history);
  }
}

Iterable<Point<int>> move(Point<int> curr, Point<int> prev) {
  final dir = comingFrom(curr, prev);
  final nextDir = getNextDir(data[curr.y][curr.x], dir);
  return nextDir.map((e) => dirDelta[e]! + curr);
}

Dir comingFrom(Point<int> curr, Point<int> prev) {
  assert(curr != prev && (curr.x == prev.x || curr.y == prev.y));
  if (prev.x == curr.x) {
    return prev.y < curr.y ? Dir.n : Dir.s;
  } else {
    return prev.x < curr.x ? Dir.w : Dir.e;
  }
}

List<Dir> getNextDir(String tile, Dir comingDir) => switch (tile) {
  "." => switch (comingDir) {
    Dir.e => [Dir.w],
    Dir.w => [Dir.e],
    Dir.n => [Dir.s],
    Dir.s => [Dir.n],
  },
  "-" => switch (comingDir) {
    Dir.e => [Dir.w],
    Dir.w => [Dir.e],
    Dir.n || Dir.s => [Dir.e, Dir.w],
  },
  "|" => switch (comingDir) {
    Dir.n => [Dir.s],
    Dir.s => [Dir.n],
    Dir.e || Dir.w => [Dir.n, Dir.s],
  },
  "/" => switch (comingDir) {
    Dir.e => [Dir.s],
    Dir.w => [Dir.n],
    Dir.n => [Dir.w],
    Dir.s => [Dir.e],
  },
  "\\" => switch (comingDir) {
    Dir.e => [Dir.n],
    Dir.w => [Dir.s],
    Dir.n => [Dir.e],
    Dir.s => [Dir.w],
  },
  _ => throw("Unexpected!"),
};

Iterable<(Point<int>, Point<int>)> getInitialPoints() sync* {
  for (int i = border.left; i <= border.right; i++) {
    yield (Point(i, border.top), Point(i, border.top - 1));
    yield (Point(i, border.bottom), Point(i, border.bottom + 1));
  }
  for (int i = border.top; i <= border.bottom; i++) {
    yield (Point(border.left, i), Point(border.left - 1, i));
    yield (Point(border.right, i), Point(border.right + 1, i));
  }
}

/*
row = y
col = x
*/

// part 1:
// part 2:

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

Direction comingFrom(Point<int> curr, Point<int> prev) {
  assert(curr != prev && (curr.x == prev.x || curr.y == prev.y));
  if (prev.x == curr.x) {
    return prev.y < curr.y ? Direction.north : Direction.south;
  } else {
    return prev.x < curr.x ? Direction.west : Direction.east;
  }
}

List<Direction> getNextDir(String tile, Direction comingDir) => switch (tile) {
  "." => switch (comingDir) {
    Direction.east => [Direction.west],
    Direction.west => [Direction.east],
    Direction.north => [Direction.south],
    Direction.south => [Direction.north],
  },
  "-" => switch (comingDir) {
    Direction.east => [Direction.west],
    Direction.west => [Direction.east],
    Direction.north || Direction.south => [Direction.east, Direction.west],
  },
  "|" => switch (comingDir) {
    Direction.north => [Direction.south],
    Direction.south => [Direction.north],
    Direction.east || Direction.west => [Direction.north, Direction.south],
  },
  "/" => switch (comingDir) {
    Direction.east => [Direction.south],
    Direction.west => [Direction.north],
    Direction.north => [Direction.west],
    Direction.south => [Direction.east],
  },
  "\\" => switch (comingDir) {
    Direction.east => [Direction.north],
    Direction.west => [Direction.south],
    Direction.north => [Direction.east],
    Direction.south => [Direction.west],
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

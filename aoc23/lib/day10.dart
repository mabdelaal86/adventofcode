import 'dart:math';

import 'common.dart';

late final List<String> data;

final example1 = r"""
-L|F7
7S-7|
L|7||
-L-J|
L|-JF
""".trim();

final example2 = r"""
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
""".trim();

final example3 = r"""
...........
.S-------7.
.|F-----7|.
.||..F..||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........""".trim();

final example4 = r"""
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
""".trim();

final example5 = r"""
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
""".trim();

Future<void> main() async {
  data = await getData().toList();
  // data = example1.split("\n");
  // data = example2.split("\n");
  // data = example3.split("\n");
  // data = example4.split("\n");
  // data = example5.split("\n");

  final startPoint = findStart();
  final loopPoints = loopTilePoints(startPoint);
  final farthest = loopPoints.length ~/ 2;
  print(farthest);

  final enclosed = getAll()
      .where((e) => isInside(e.$2, loopPoints))
      .toList();
  print(enclosed.length);
}

const directions = {
  'N': Point(-1,  0),
  'S': Point( 1,  0),
  'E': Point( 0,  1),
  'W': Point( 0, -1),
};

const tileDir = {
  '|': "NS",
  '-': "WE",
  'L': "NE",
  'J': "NW",
  '7': "WS",
  'F': "ES",
};

Point<int> findStart() => data.indexed
    .where((r) => r.$2.contains('S'))
    .map((r) => Point(r.$1, r.$2.indexOf('S')))
    .first;

String tileAt(Point<int> loc) => data[loc.x][loc.y];

List<Point<int>> loopTilePoints(Point<int> startPoint) {
  List<Point<int>> loopItems = [startPoint];
  var preL = startPoint, preR = startPoint;
  var (curL, curR) = adjToStart(startPoint);

  while (curL != curR) {
    loopItems.addAll([curL, curR]);
    (preL, curL) = (curL, move(preL, curL));
    (preR, curR) = (curR, move(preR, curR));
  }

  loopItems.add(curL);

  assert(loopItems.length.isEven);
  return loopItems;
}

bool canMoveTo(Point<int> cur, Point<int> nxt) => adjTo(nxt).contains(cur);

(Point<int>, Point<int>) adjToStart(Point<int> startPoint) {
  final points = around(startPoint)
      .where((e) => canMoveTo(startPoint, e))
      .toList();
  
  assert(points.length == 2);
  return (points[0], points[1]);
}

Iterable<Point<int>> adjTo(Point<int> loc) => adjBy(tileDir[tileAt(loc)] ?? '')
    .map((e) => e + loc);

Iterable<Point<int>> adjBy(String dir) => directions.entries
    .where((e) => dir.contains(e.key))
    .map((e) => e.value);

Iterable<Point<int>> around(Point<int> loc) => directions.values
    .map((e) => e + loc)
    .where((e) => e.x >= 0 && e.y >= 0);

Point<int> move(Point<int> pre, Point<int> cur) => adjTo(cur)
    .firstWhere((e) => e != pre);

Iterable<(String, Point<int>)> getAll() sync* {
  for (final r in data.indexed) {
    for (final c in r.$2.split('').indexed) {
      yield (c.$2, Point(r.$1, c.$1));
    }
  }
}

final re = RegExp(r"(FJ|L7|\|)");

bool isInside(Point<int> point, List<Point<int>> loopPoints) {
  if (loopPoints.contains(point)) {
    return false;
  }

  final ss = List<Point<int>>
      .generate(point.y, (i) => Point(point.x, i))
      .where((e) => loopPoints.contains(e))
      .map((e) => tileAt(e).replaceFirst("S", "-")) // ??????????
      .where((e) => e != '-')
      .join();

  return re.allMatches(ss).length.isOdd;
}

// part 1: 7107
// part 2:

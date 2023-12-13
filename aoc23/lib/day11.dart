import 'dart:math';

import 'common.dart';

late final List<String> data;
late final List<Point<int>> galaxies;
// late final universeSize;
late final List<int> emptyRows, emptyCols;

final example = r"""
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
""".trim();

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");

  galaxies = findGalaxies();
  findEmpty();

  final expanded2 = expand(2);
  // assert(calcDistance(expanded2[4], expanded2[8]) == 9);

  final distances2 = getPairs(expanded2)
      .map((e) => calcDistance(e.$1, e.$2))
      .sum();
  print(distances2);

  // final distances10 = getPairs(expand(10))
  //     .map((e) => calcDistance(e.$1, e.$2))
  //     .sum();
  // print(distances10);
  //
  // final distances100 = getPairs(expand(100))
  //     .map((e) => calcDistance(e.$1, e.$2))
  //     .sum();
  // print(distances100);

  final distances1m = getPairs(expand(1000000))
      .map((e) => calcDistance(e.$1, e.$2))
      .sum();
  print(distances1m);
}

List<Point<int>> findGalaxies() => [
    for (final (r, row) in data.indexed)
      for (final (c, ch) in row.split('').indexed)
        if (ch == "#")
          Point(c, r)
  ];

void findEmpty() {
  emptyRows = data.indexed
      .where((e) => !e.$2.contains("#"))
      .map((e) => e.$1)
      .toList();
  emptyCols = Iterable<int>
      .generate(data[0].length)
      .where((i) => data.every((e) => e[i] != "#"))
      .toList();
}

List<Point<int>> expand(int factor) => [
    for (final galaxy in galaxies)
      Point(
          galaxy.x + emptyCols.where((e) => e < galaxy.x).length * (factor - 1),
          galaxy.y + emptyRows.where((e) => e < galaxy.y).length * (factor - 1),
      )
];

Iterable<(Point<int>, Point<int>)> getPairs(List<Point<int>> galaxies) sync* {
  for (final (i, galaxy1) in galaxies.indexed) {
    for (final galaxy2 in galaxies.skip(i + 1)) {
      yield (galaxy1, galaxy2);
    }
  }
}

int calcDistance(Point<int> a, Point<int> b) => (a.x - b.x).abs() + (a.y - b.y).abs();

// part 1:
// part 2: 82000210

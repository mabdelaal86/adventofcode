import 'package:basics/int_basics.dart';

import 'common.dart';

late final List<String> data;

final example = r"""
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
""".trim();

Future<void> main() async {
  // data = await getData().toList();
  data = example.split("\n");

  final tilted1 = data.rotateOnce().map(tiltRow);
  final part1 = tilted1.map(calcLoad).sum();
  print(part1);

  // final tilted2 = spin(1E+9.toInt());
  // tilted2.printAll();
  // final part2 = tilted2.map(calcLoad).sum();
  // print(part2);

  print(1E+9.toInt());
}

Iterable<String> spin(int cycles) {
  Iterable<String> res = data;

  for (final cycle in cycles.range) {
    for (final _ in 4.range) {
      res = res.rotateOnce().map(tiltRow);
    }
    if (cycle % 100000 == 0) print((cycle, res.map(calcLoad).sum()));
  }

  return res;
}

extension Rotate on Iterable<String> {
  Iterable<String> rotateOnce([bool anticlockwise = false]) =>
      map((e) => e.split(""))
      .rotate90(anticlockwise)
      .map((e) => e.join());
}

String tiltRow(String row) => row.splitMapJoin("#", onNonMatch: tiltPart);

String tiltPart(String group) {
  final rockCount = "O".allMatches(group).length;
  return "." * (group.length - rockCount) + "O" * rockCount;
}

int calcLoad(String row) => row.split("").indexed
    .where((e) => e.$2 == "O")
    .map((e) => e.$1 + 1)
    .sum();

// part 1:
// part 2:

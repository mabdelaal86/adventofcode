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
  data = await getData().toList();
  // data = example.split("\n");

  final rotated = data
      .map((e) => e.split(""))
      .rotate90()
      .map((e) => e.join());

  final part1 = rotated
      .map((e) => e.splitMapJoin("#", onNonMatch: tilt))
      .map(calcLoad)
      .sum();
  print(part1);
}

String tilt(String group) {
  final rockCount = "O".allMatches(group).length;
  return "." * (group.length - rockCount) + "O" * rockCount;
}

int calcLoad(String row) => row.split("").indexed
    .where((e) => e.$2 == "O")
    .map((e) => e.$1 + 1)
    .sum();

// part 1:
// part 2:

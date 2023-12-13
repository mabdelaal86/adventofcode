import 'common.dart';

late final List<String> data;

final example = r"""
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
""".trim();

Future<void> main() async {
  // data = await getData().toList();
  data = example.split("\n");
  data.printAll();
  print("=============");

  final areas = groupAreas().map(processRows);
  areas.printAll();
}

Iterable<List<String>> groupAreas() sync* {
  int start = 0;
  while(true) {
    int end = data.indexWhere((e) => e.isEmpty, start);
    if (end == -1) {
      yield data.sublist(start);
      break;
    }
    yield data.sublist(start, end);
    start = end + 1;
  }
}

Iterable<int> processRows(List<String> area) => area
    .map((e) => e.replaceAll("#", "1").replaceAll(".", "0"))
    .map(int.parse);

// part 1:
// part 2:

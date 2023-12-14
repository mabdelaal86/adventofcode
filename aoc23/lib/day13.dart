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

  final areas = groupAreas().map(processRows).toList();
  for (final a in areas) {
    a.forEach((e) {
      print(e.toRadixString(2));
    });
     print(".........");
  }
  print("----------");
  final rev = areas.map(transpose).map((e) => e.toList()).toList();
  for (final a in rev) {
    a.forEach((e) {
      print(e.toRadixString(2));
    });
     print(".........");
  }
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

List<int> processRows(List<String> area) => area
    .map((e) => e.replaceAll("#", "1").replaceAll(".", "0"))
    .map((e) => int.parse(e, radix: 2))
    .toList();

Iterable<int> transpose(List<int> group) sync* {
  final size = group.max().toRadixString(2).length;
  for (int i = 0; i < size; i++) {
    final shift = 1 << i;
    yield group
        .map((e) => e & shift).indexed
        .map((e) => e.$2 << e.$1)
        .sum();
  }
}

// part 1:
// part 2:

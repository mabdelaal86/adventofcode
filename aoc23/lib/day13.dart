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
  data = await getData().toList();
  // data = example.split("\n");

  final areas = groupAreas().map(processStrArea).toList();
  final part1 = summarize(areas, findMirror);
  print(part1);
  
  final part2 = summarize(areas, findSmudge);
  print(part2);
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

List<int> processStrArea(List<String> area) => area
    .map((e) => e.replaceAll("#", "1").replaceAll(".", "0"))
    .map((e) => int.parse(e, radix: 2))
    .toList();

List<int> transpose(List<int> group) {
  final colsCount = group.max().toRadixString(2).length;
  return Iterable<int>.generate(colsCount)
      .map((i) => colsCount - i - 1)
      .map((c) => group.indexed.map((e) => shift(e.$2, e.$1, c)).sum())
      .toList();
}

int shift(int value, int row, int col) {
  value &= 1 << col;
  if (col > row) {
    value >>= col - row;
  } else {
    value <<= row - col;
  }
  return value;
}

int summarize(List<List<int>> areas, int Function(List<int>) mirrorLen) {
  final tAreas = areas.map(transpose).toList();
  final rowMirrors = areas.map(mirrorLen);
  final colMirrors = tAreas.map(mirrorLen);
  return rowMirrors.zip(colMirrors)
      .map((e) => e.$1 * 100 + e.$2)
      .sum();
}

int findMirror(List<int> items) {
  for (int i = 1; i < items.length; i++) {
    final left = items.sublist(0, i).reversed;
    final right = items.skip(i);
    final diff = left.zip(right).map((e) => e.$1 ^ e.$2).sum();

    if (diff == 0) return i;
  }
  return 0;
}

int findSmudge(List<int> items) {
  for (int i = 1; i < items.length; i++) {
    final left = items.sublist(0, i).reversed;
    final right = items.skip(i);
    final diff = left.zip(right).map((e) => e.$1 ^ e.$2).toList();
    if (diff.where((e) => e != 0).singleOrNull case int z when isPowerOfTwo(z)) return i;
  }
  return 0;
}

bool isPowerOfTwo(int x) => (x != 0) && ((x & (x - 1)) == 0);
